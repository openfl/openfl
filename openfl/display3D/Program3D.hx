package openfl.display3D;

import openfl._internal.stage3D.AGALConverter;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;
import openfl.Vector;
import openfl.utils.Float32Array;
import openfl.gl.GL;
import openfl.gl.GLUniformLocation;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;


private class Uniform {
    public var Name:String;
    public var Location:GLUniformLocation;
    public var Type:Int;
    public var Size:Int;
    public var RegData:Float32Array; // Was Float[]
    public var RegIndex:Int; // virtual register index
    public var RegCount:Int; // virtual register count (usually 1 except for matrices)
    public var IsDirty:Bool = true;

    public function new()
    {}

    private function getRegisters(index:Int, size:Int):Float32Array
    {
        // HACK: on Neko, CPP, subarray returns a view into the RegData
        // array. When uploading that data as a uniform, it will upload
        // the underlying array, which is far too long, causing it to
        // throw an exception. Workaround here is just to create a new
        // array and copy it directly so we know that it will be the
        // right size. Significant downside is that we're introducing
        // an extra copy.
#if (js && html5)
        return this.RegData.subarray(index, size);
#else
        var result = new Float32Array(size);
        for (i in 0...size) {
            result[i] = this.RegData[index + i];
        }
        return result;
#end
    }

    public function Flush():Void
    {
        // get pointer to constant data
        //fixed(Float *constants = this.RegData)
        //{
        // add register index
        //Float *value = constants + RegIndex * 4;
        // set uniform
        switch (Type) {
            case GL.FLOAT_MAT2:
                GL.uniformMatrix2fv(Location, false, getRegisters(RegIndex * 4, Size * 2 * 2));

            case GL.FLOAT_MAT3:
                GL.uniformMatrix3fv(Location, false, getRegisters(RegIndex * 4, Size * 3 * 3));

            case GL.FLOAT_MAT4:
                GL.uniformMatrix4fv(Location, false, getRegisters(RegIndex * 4, Size * 4 * 4));

            case GL.FLOAT_VEC2:
                GL.uniform2fv(Location, getRegisters(RegIndex * 4, RegCount * 2));

            case GL.FLOAT_VEC3:
                GL.uniform3fv(Location, getRegisters(RegIndex * 4, RegCount * 3));

            case GL.FLOAT_VEC4:
                GL.uniform4fv(Location, getRegisters(RegIndex * 4, RegCount * 4));

            default:
                GL.uniform4fv(Location, getRegisters(RegIndex * 4, RegCount * 4));
        }
        GLUtils.CheckGLError();
        //}
    }
}

// this class encapsulates uniform variables mapped to register ranges
private class UniformMap {

    // TODO: it would be better to use a bitmask with a dirty bit per uniform, but not super important now
    private var mAnyDirty:Bool ;
    private var mAllDirty:Bool ;

    private var mUniforms:Array<Uniform>;
    private var mRegisterLookup:Vector<Uniform>;

    public function new(list:Array<Uniform>)
    {
        mUniforms = list;

        // sort uniforms by their register index
        mUniforms.sort(function(a, b):Int
        { return Reflect.compare(a.RegIndex, b.RegIndex); });
        //Array.Sort(mUniforms, (a,b) => b.RegIndex.CompareTo(a.RegIndex));

        // get total number of registers used
        var total:Int = 0;
        for (uniform in mUniforms) {
            if (uniform.RegIndex + uniform.RegCount > total) {
                total = uniform.RegIndex + uniform.RegCount;
            }
        }

        // create lookup table from register -> uniform
        mRegisterLookup = new Vector<Uniform>(total);
        for (uniform in mUniforms) {
            for (i in 0...uniform.RegCount) {
                mRegisterLookup[uniform.RegIndex + i] = uniform;
            }
        }

        // set dirty flags
        mAnyDirty = mAllDirty = true;
    }

    public function MarkDirty(start:Int, count:Int):Void
    {
        if (mAllDirty) {
            // dont need to track individual uniforms if we are all dirty
            return;
        }

        // compute end of register range
        var end:Int = start + count;
        if (end > mRegisterLookup.length) end = mRegisterLookup.length;

        // loop until end
        //for(index in start...end) {
        var index = start;
        while (index < end) {
            var uniform = mRegisterLookup[index];
            if (uniform != null) {
                // mark uniform as dirty
                uniform.IsDirty = true;
                mAnyDirty = true;
                // go to next register
                index = uniform.RegIndex + uniform.RegCount;
            } else {
                // no uniform at this location...
                index ++;
            }
        }
    }

    public function MarkAllDirty():Void
    {
        mAllDirty = true;
        mAnyDirty = true;
    }

    public function Flush():Void
    {
        if (mAnyDirty) {
            // flush all uniforms
            for (uniform in mUniforms) {
                if (mAllDirty || uniform.IsDirty) {
                    uniform.Flush();
                    // clear dirty flag
                    uniform.IsDirty = false;
                }
            }

            // clear all dirty flags
            mAnyDirty = mAllDirty = false;
        }
    }
}


class Program3D {


    public static var Verbose:Bool = true;


    //
    // Methods
    //

    private /*readonly*/ var mContext:Context3D;
    private var mMemUsage:Int = 0;

    private var mVertexShaderId:GLShader = null;
    private var mFragmentShaderId:GLShader = null;
    private var mProgramId:GLProgram = null;

//#pragma warning disable 414		// the fields below are assigned but never used
    private var mVertexSource:String;
    private var mFragmentSource:String;
//#pragma warning restore 414

    // uniform lookup tables
    private var mUniforms:List<Uniform> = new List<Uniform>();
    private var mSamplerUniforms:List<Uniform> = new List<Uniform>();
    private var mAlphaSamplerUniforms:List<Uniform> = new List<Uniform> ();
    private var mPositionScale:Uniform;

    // sampler state information
    private var mSamplerStates:Vector<SamplerState> = new Vector<SamplerState>(Context3D.MaxSamplers);
    private var mSamplerUsageMask:Int = 0;

    private var mVertexUniformMap:UniformMap;
    private var mFragmentUniformMap:UniformMap;

    public function new(context3D:Context3D)
    {
        mContext = context3D;
    }

    public function dispose():Void
    {
        deleteShaders();
    }

    private function deleteShaders():Void
    {
        if (mProgramId != null) {
            // this causes an exception EntryPoIntNotFound ..
            // GL.DeleteProgram (1, ref mProgramId  );
            mProgramId = null;
        }

        if (mVertexShaderId != null) {
            GL.deleteShader(mVertexShaderId);
            GLUtils.CheckGLError();
            mVertexShaderId = null;
        }

        if (mFragmentShaderId != null) {
            GL.deleteShader(mFragmentShaderId);
            GLUtils.CheckGLError();
            mFragmentShaderId = null;
        }

        if (mMemUsage != 0) {
            mContext.statsDecrement(Context3D.Stats.Count_Program);
            mContext.statsSubtract(Context3D.Stats.Mem_Program, mMemUsage);
            mMemUsage = 0;
        }
    }

    public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void
    {
        throw new IllegalOperationError();
    }

    public function upload(vertexProgram:ByteArray, fragmentProgram:ByteArray):Void
    {

        // create array to hold sampler states
        var samplerStates = new Vector<SamplerState>(Context3D.MaxSamplers);

        // convert shaders from AGAL to GLSL
        var glslVertex = AGALConverter.ConvertToGLSL(vertexProgram, null);
        var glslFragment = AGALConverter.ConvertToGLSL(fragmentProgram, samplerStates);
        // upload as GLSL
        uploadFromGLSL(glslVertex, glslFragment);
        // set sampler states from agal
        for (i in 0...samplerStates.length) {
            setSamplerState(i, samplerStates[i]);
        }
    }

    public function uploadFromGLSL(vertexShaderSource:String, fragmentShaderSource:String):Void
    {
        // delete existing shaders
        deleteShaders();

        if (Verbose) {
            trace(vertexShaderSource);
            trace(fragmentShaderSource);
        }

        mVertexSource = vertexShaderSource;
        mFragmentSource = fragmentShaderSource;

        // compiler vertex shader
        mVertexShaderId = GL.createShader(GL.VERTEX_SHADER);
        GL.shaderSource(mVertexShaderId, vertexShaderSource);
        GLUtils.CheckGLError();

        GL.compileShader(mVertexShaderId);
        GLUtils.CheckGLError();

        var shaderCompiled:Int = GL.getShaderParameter(mVertexShaderId, GL.COMPILE_STATUS);

        GLUtils.CheckGLError();

        if (shaderCompiled == 0) {
            var vertexInfoLog = GL.getShaderInfoLog(mVertexShaderId);
            if (vertexInfoLog != null && vertexInfoLog.length != 0) {
                trace('vertex: ${vertexInfoLog}');
            }

            throw new Error("Error compiling vertex shader: " + vertexInfoLog);
        }

        // compile fragment shader
        mFragmentShaderId = GL.createShader(GL.FRAGMENT_SHADER);
        GL.shaderSource(mFragmentShaderId, fragmentShaderSource);
        GLUtils.CheckGLError();

        GL.compileShader(mFragmentShaderId);
        GLUtils.CheckGLError();

        var fragmentCompiled:Int = GL.getShaderParameter(mFragmentShaderId, GL.COMPILE_STATUS);

        if (fragmentCompiled == 0) {
            var fragmentInfoLog = GL.getShaderInfoLog(mFragmentShaderId);
            if (fragmentInfoLog != null && fragmentInfoLog.length != 0) {
                trace('fragment: ${fragmentInfoLog}');
            }

            throw new Error("Error compiling fragment shader: " + fragmentInfoLog);
        }

        // create program
        mProgramId = GL.createProgram();
        GL.attachShader(mProgramId, mVertexShaderId);
        GLUtils.CheckGLError();

        GL.attachShader(mProgramId, mFragmentShaderId);
        GLUtils.CheckGLError();

        // bind all attribute locations
        for (i in 0...Context3D.MaxAttributes) {
            var name = "va" + i;
            if (vertexShaderSource.indexOf(" " + name) != -1) {
                GL.bindAttribLocation(mProgramId, i, name);
            }
        }

        // Link the program
        GL.linkProgram(mProgramId);

        var infoLog = GL.getProgramInfoLog(mProgramId);
        if (infoLog != null && infoLog.length != 0) {
            trace("program: ${infoLog}");
        }

        // build uniform list
        buildUniformList();

        // update stats for this program
        mMemUsage = 1; // TODO, figure out a way to get this
        mContext.statsIncrement(Context3D.Stats.Count_Program);
        mContext.statsAdd(Context3D.Stats.Mem_Program, mMemUsage);
    }

    // flushes program's Internal state (called before each draw)
    /*internal*/

    public function Flush():Void
    {
        mVertexUniformMap.Flush();
        mFragmentUniformMap.Flush();
    }

    // marks a range of constant registers as being dirty
    /*internal*/

    public function MarkDirty(isVertex:Bool, index:Int, count:Int):Void
    {
        if (isVertex) {
            mVertexUniformMap.MarkDirty(index, count);
        } else {
            mFragmentUniformMap.MarkDirty(index, count);
        }
    }

    /*internal*/

    public function Use():Void
    {
        // use program
        GL.useProgram(mProgramId);
        GLUtils.CheckGLError();

        mVertexUniformMap.MarkAllDirty();
        mFragmentUniformMap.MarkAllDirty();

        // update texture units for all sampler uniforms
        for (sampler in mSamplerUniforms) {
            if (sampler.RegCount == 1) {
                // single sampler
                GL.uniform1i(sampler.Location, sampler.RegIndex);
                GLUtils.CheckGLError();
            } else {
                throw new IllegalOperationError("!!! TODO: uniform location on webgl");
                /*
                    TODO: Figure out +i on WebGL.
					// sampler array?
                    for(i in 0...sampler.RegCount) {
						GL.uniform1i(sampler.Location + i, sampler.RegIndex + i);
						GLUtils.CheckGLError ();
					}
                    */
            }
        }

        for (sampler in mAlphaSamplerUniforms) {
            if (sampler.RegCount == 1) {
                // single sampler
                GL.uniform1i(sampler.Location, sampler.RegIndex);
                GLUtils.CheckGLError();
            } else {
                throw new IllegalOperationError("!!! TODO: uniform location on webgl");
                /*
                    TODO: Figure out +i on WebGL.
					// sampler array?
                    for(i in 0...sampler.RegCount) {
						GL.uniform1i(sampler.Location + i, sampler.RegIndex + i);
						GLUtils.CheckGLError ();
					}
                    */
            }
        }
    }

    /*internal*/

    public function SetPositionScale(positionScale:Float32Array):Void
    {
        // update position scale
        if (mPositionScale != null) {
            GL.uniform4fv(mPositionScale.Location, /*1,*/ positionScale);
            GLUtils.CheckGLError();
        }
    }

    private function buildUniformList():Void
    {
        // clear Internal lists
        mUniforms.clear();
        mSamplerUniforms.clear();
        mAlphaSamplerUniforms.clear();

        mSamplerUsageMask = 0;

        var numActive:Int = 0;
        numActive = GL.getProgramParameter(mProgramId, GL.ACTIVE_UNIFORMS);
        GLUtils.CheckGLError();

        var vertexUniforms = new List<Uniform>();
        var fragmentUniforms = new List<Uniform>();

        for (i in 0...numActive) {
            // create new uniform
            var info = GL.getActiveUniform(mProgramId, i);
            var name = info.name;
            var size = info.size;
            var uniformType = info.type;
            GLUtils.CheckGLError();

            var uniform = new Uniform();
            uniform.Name = name;
            uniform.Size = size;
            uniform.Type = uniformType;

#if (cpp || (js && html5) || neko || PLATFORM_MONOTOUCH || PLATFORM_MONOMAC)
            uniform.Location = GL.getUniformLocation(mProgramId, uniform.Name);
            GLUtils.CheckGLError();
#elseif PLATFORM_MONODROID
            uniform.Location = GL.getUniformLocation(mProgramId, new StringBuilder(uniform.Name, 0, uniform.Name.Length, uniform.Name.Length));
            GLUtils.CheckGLError();
#end
            // remove array [x] from names
            var indexBracket:Int = uniform.Name.indexOf('[');
            if (indexBracket >= 0) {
                uniform.Name = uniform.Name.substring(0, indexBracket);
            }

            // determine register count for uniform
            switch (uniform.Type)
            {
                case GL.FLOAT_MAT2: uniform.RegCount = 2;
                case GL.FLOAT_MAT3: uniform.RegCount = 3;
                case GL.FLOAT_MAT4: uniform.RegCount = 4;
                default:
                    uniform.RegCount = 1; // 1 by default
            }

            // multiple regcount by size
            uniform.RegCount *= uniform.Size;

            // add uniform to program list
            mUniforms.add(uniform);

            if (uniform.Name == "vcPositionScale") {
                mPositionScale = uniform;
            }
            else if (StringTools.startsWith(uniform.Name, "vc")) {
                // vertex uniform
                uniform.RegIndex = Std.parseInt(uniform.Name.substring(2));
                uniform.RegData = mContext.mVertexConstants;
                vertexUniforms.add(uniform);
            }
            else if (StringTools.startsWith(uniform.Name, "fc")) {
                // fragment uniform
                uniform.RegIndex = Std.parseInt(uniform.Name.substring(2));
                uniform.RegData = mContext.mFragmentConstants;
                fragmentUniforms.add(uniform);
            }
            else if (StringTools.startsWith(uniform.Name, "sampler") && !StringTools.endsWith(uniform.Name, "_alpha")) {
                // sampler uniform
                uniform.RegIndex = Std.parseInt(uniform.Name.substring(7));
                // add to list of sampler uniforms
                mSamplerUniforms.add(uniform);

                // set sampler usage mask for this sampler uniform
                for (reg in 0...uniform.RegCount) {
                    mSamplerUsageMask |= (1 << (uniform.RegIndex + reg));
                }
            }
            else if (StringTools.startsWith(uniform.Name, "sampler") && StringTools.endsWith(uniform.Name, "_alpha")) {
                // sampler uniform
                var len:Int = uniform.Name.indexOf("_") - 7;
                uniform.RegIndex = Std.parseInt(uniform.Name.substring(7, 7 + len)) + 4;
                // add to list of sampler uniforms
                mAlphaSamplerUniforms.add(uniform);
            }

            if (Verbose) {
                trace('${i} name:${uniform.Name} type:${uniform.Type} size:${uniform.Size} location:${uniform.Location}');
            }
        }

        // create register maps for vertex/fragment uniforms
        mVertexUniformMap = new UniformMap(Lambda.array(vertexUniforms) /*.ToArray()*/ );
        mFragmentUniformMap = new UniformMap(Lambda.array(fragmentUniforms) /*.ToArray()*/ );
    }

    public function getSamplerState(sampler:Int):SamplerState
    {
        return mSamplerStates[sampler];
    }

    // sets the sampler state for a sampler when this program is used

    public function setSamplerState(sampler:Int, state:SamplerState):Void
    {
        mSamplerStates[sampler] = state;
    }

    public var samplerUsageMask(get, null):Int;

    public function get_samplerUsageMask():Int
    {
        return mSamplerUsageMask;
    }

/* Stubs
    public Program3D(Context3D context3D)
    {
        throw new NotImplementedException();
    }

    {
        throw new NotImplementedException();
    }

    public Void uploadFromByteArray(ByteArray data, Int byteArrayOffset, Int startOffset, Int count)
    {
        throw new NotImplementedException();
    }

    public Void upload(ByteArray vertexProgram, ByteArray fragmentProgram)
    {
        throw new NotImplementedException();
    }

    public Int programId {
    get {
    throw new NotImplementedException();
    }
    }

    private Void prIntProgramInfo (String name, Int id)
    {
    throw new NotImplementedException();
    }

    private String loadShaderSource (String name)
    {
    throw new NotImplementedException();
    }

    public Void uploadFromGLSLFiles (String vertexShaderName, String fragmentShaderName)
    {
    throw new NotImplementedException();
    }

    public Void uploadFromGLSL(String vertexShaderSource, String fragmentShaderSource)
    {
    throw new NotImplementedException();
    }
public Void dispose()

*/

}
	
