package openfl.display3D;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.utils.Float32Array;
import lime.utils.Log;
import openfl._internal.stage3D.AGALConverter;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;
import openfl.Vector;

@:access(openfl.display3D.Context3D)


@:final class Program3D {
	
	
	private static var verbose = (Log.level == LogLevel.VERBOSE);
	
	private var __alphaSamplerUniforms:List<Uniform>;
	private var __context:Context3D;
	private var __fragmentShaderID:GLShader;
	private var __fragmentSource:String;
	private var __fragmentUniformMap:UniformMap;
	private var __memUsage:Int;
	private var __positionScale:Uniform;
	private var __programID:GLProgram;
	private var __samplerStates:Vector<SamplerState>;
	private var __samplerUniforms:List<Uniform>;
	private var __samplerUsageMask:Int;
	private var __uniforms:List<Uniform>;
	private var __vertexShaderID:GLShader;
	private var __vertexSource:String;
	private var __vertexUniformMap:UniformMap;
	
	
	private function new (context3D:Context3D) {
		
		__context = context3D;
		
		__memUsage = 0;
		__samplerUsageMask = 0;
		
		__uniforms = new List<Uniform> ();
		__samplerUniforms = new List<Uniform> ();
		__alphaSamplerUniforms = new List<Uniform> ();
		
		__samplerStates = new Vector<SamplerState> (Context3D.MAX_SAMPLERS);
		
	}
	
	
	public function dispose ():Void {
		
		__deleteShaders ();
		
	}
	
	
	public function upload (vertexProgram:ByteArray, fragmentProgram:ByteArray):Void {
		
		var samplerStates = new Vector<SamplerState> (Context3D.MAX_SAMPLERS);
		
		var glslVertex = AGALConverter.ConvertToGLSL (vertexProgram, null);
		var glslFragment = AGALConverter.ConvertToGLSL (fragmentProgram, samplerStates);
		
		__uploadFromGLSL (glslVertex, glslFragment);
		
		for (i in 0...samplerStates.length) {
			
			__setSamplerState (i, samplerStates[i]);
			
		}
		
	}
	
	
	private function __buildUniformList ():Void {
		
		__uniforms.clear ();
		__samplerUniforms.clear ();
		__alphaSamplerUniforms.clear ();
		
		__samplerUsageMask = 0;
		
		var numActive = 0;
		numActive = GL.getProgramParameter (__programID, GL.ACTIVE_UNIFORMS);
		GLUtils.CheckGLError ();
		
		var vertexUniforms = new List<Uniform> ();
		var fragmentUniforms = new List<Uniform> ();
		
		for (i in 0...numActive) {
			
			var info = GL.getActiveUniform (__programID, i);
			var name = info.name;
			var size = info.size;
			var uniformType = info.type;
			GLUtils.CheckGLError ();
			
			var uniform = new Uniform ();
			uniform.name = name;
			uniform.size = size;
			uniform.type = uniformType;
			
			uniform.location = GL.getUniformLocation (__programID, uniform.name);
			GLUtils.CheckGLError ();
			
			var indexBracket = uniform.name.indexOf ('[');
			
			if (indexBracket >= 0) {
				
				uniform.name = uniform.name.substring (0, indexBracket);
				
			}
			
			switch (uniform.type) {
				
				case GL.FLOAT_MAT2: uniform.regCount = 2;
				case GL.FLOAT_MAT3: uniform.regCount = 3;
				case GL.FLOAT_MAT4: uniform.regCount = 4;
				default: uniform.regCount = 1;
				
			}
			
			uniform.regCount *= uniform.size;
			
			__uniforms.add (uniform);
			
			if (uniform.name == "vcPositionScale") {
				
				__positionScale = uniform;
				
			} else if (StringTools.startsWith (uniform.name, "vc")) {
				
				uniform.regIndex = Std.parseInt (uniform.name.substring (2));
				uniform.regData = __context.__vertexConstants;
				vertexUniforms.add (uniform);
				
			} else if (StringTools.startsWith (uniform.name, "fc")) {
				
				uniform.regIndex = Std.parseInt (uniform.name.substring (2));
				uniform.regData = __context.__fragmentConstants;
				fragmentUniforms.add (uniform);
				
			} else if (StringTools.startsWith (uniform.name, "sampler") && !StringTools.endsWith (uniform.name, "_alpha")) {
				
				uniform.regIndex = Std.parseInt (uniform.name.substring (7));
				__samplerUniforms.add (uniform);
				
				for (reg in 0...uniform.regCount) {
					
					__samplerUsageMask |= (1 << (uniform.regIndex + reg));
					
				}
				
			} else if (StringTools.startsWith (uniform.name, "sampler") && StringTools.endsWith (uniform.name, "_alpha")) {
				
				var len = uniform.name.indexOf ("_") - 7;
				uniform.regIndex = Std.parseInt (uniform.name.substring (7, 7 + len)) + 4;
				__alphaSamplerUniforms.add (uniform);
				
			}
			
			if (verbose) {
				
				trace ('${i} name:${uniform.name} type:${uniform.type} size:${uniform.size} location:${uniform.location}');
				
			}
			
		}
		
		__vertexUniformMap = new UniformMap (Lambda.array (vertexUniforms));
		__fragmentUniformMap = new UniformMap (Lambda.array (fragmentUniforms));
		
	}
	
	
	private function __deleteShaders ():Void {
		
		if (__programID != null) {
			
			// this causes an exception EntryPoIntNotFound ..
			// GL.DeleteProgram (1, ref __programID  );
			__programID = null;
			
		}
		
		if (__vertexShaderID != null) {
			
			GL.deleteShader (__vertexShaderID);
			GLUtils.CheckGLError ();
			__vertexShaderID = null;
			
		}
		
		if (__fragmentShaderID != null) {
			
			GL.deleteShader (__fragmentShaderID);
			GLUtils.CheckGLError ();
			__fragmentShaderID = null;
			
		}
		
		if (__memUsage != 0) {
			
			__context.__statsDecrement (Context3D.Context3DTelemetry.COUNT_PROGRAM);
			__context.__statsSubtract (Context3D.Context3DTelemetry.MEM_PROGRAM, __memUsage);
			__memUsage = 0;
			
		}
		
	}
	
	
	private function __flush ():Void {
		
		__vertexUniformMap.flush ();
		__fragmentUniformMap.flush ();
		
	}
	
	
	private function __getSamplerState (sampler:Int):SamplerState {
		
		return __samplerStates[sampler];
		
	}
	
	
	private function __markDirty (isVertex:Bool, index:Int, count:Int):Void {
		
		if (isVertex) {
			
			__vertexUniformMap.markDirty (index, count);
			
		} else {
			
			__fragmentUniformMap.markDirty (index, count);
			
		}
		
	}
	
	
	private function __setPositionScale (positionScale:Float32Array):Void {
		
		if (__positionScale != null) {
			
			GL.uniform4fv (__positionScale.location, /*1,*/ positionScale);
			GLUtils.CheckGLError ();
			
		}
		
	}
	
	
	public function __setSamplerState (sampler:Int, state:SamplerState):Void {
		
		__samplerStates[sampler] = state;
		
	}
	
	
	private function __uploadFromGLSL (vertexShaderSource:String, fragmentShaderSource:String):Void {
		
		__deleteShaders ();
		
		if (verbose) {
			
			trace (vertexShaderSource);
			trace (fragmentShaderSource);
			
		}
		
		__vertexSource = vertexShaderSource;
		__fragmentSource = fragmentShaderSource;
		
		__vertexShaderID = GL.createShader (GL.VERTEX_SHADER);
		GL.shaderSource (__vertexShaderID, vertexShaderSource);
		GLUtils.CheckGLError ();
		
		GL.compileShader (__vertexShaderID);
		GLUtils.CheckGLError ();
		
		var shaderCompiled = GL.getShaderParameter (__vertexShaderID, GL.COMPILE_STATUS);
		
		GLUtils.CheckGLError ();
		
		if (shaderCompiled == 0) {
			
			var vertexInfoLog = GL.getShaderInfoLog (__vertexShaderID);
			
			if (vertexInfoLog != null && vertexInfoLog.length != 0) {
				
				trace ('vertex: ${vertexInfoLog}');
				
			}
			
			throw new Error ("Error compiling vertex shader: " + vertexInfoLog);
			
		}
		
		__fragmentShaderID = GL.createShader (GL.FRAGMENT_SHADER);
		GL.shaderSource (__fragmentShaderID, fragmentShaderSource);
		GLUtils.CheckGLError ();
		
		GL.compileShader (__fragmentShaderID);
		GLUtils.CheckGLError ();
		
		var fragmentCompiled = GL.getShaderParameter (__fragmentShaderID, GL.COMPILE_STATUS);
		
		if (fragmentCompiled == 0) {
			
			var fragmentInfoLog = GL.getShaderInfoLog (__fragmentShaderID);
			
			if (fragmentInfoLog != null && fragmentInfoLog.length != 0) {
				
				trace ('fragment: ${fragmentInfoLog}');
				
			}
			
			throw new Error ("Error compiling fragment shader: " + fragmentInfoLog);
			
		}
		
		__programID = GL.createProgram ();
		GL.attachShader (__programID, __vertexShaderID);
		GLUtils.CheckGLError ();
		
		GL.attachShader (__programID, __fragmentShaderID);
		GLUtils.CheckGLError ();
		
		for (i in 0...Context3D.MAX_ATTRIBUTES) {
			
			var name = "va" + i;
			
			if (vertexShaderSource.indexOf (" " + name) != -1) {
				
				GL.bindAttribLocation (__programID, i, name);
				
			}
			
		}
		
		GL.linkProgram (__programID);
		
		var infoLog = GL.getProgramInfoLog (__programID);
		
		if (infoLog != null && infoLog.length != 0) {
			
			trace ("program: ${infoLog}");
			
		}
		
		__buildUniformList ();
		
		__memUsage = 1; // TODO, figure out a way to get this
		__context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_PROGRAM);
		__context.__statsAdd (Context3D.Context3DTelemetry.MEM_PROGRAM, __memUsage);
		
	}
	
	
	private function __use ():Void {
		
		GL.useProgram (__programID);
		GLUtils.CheckGLError ();
		
		__vertexUniformMap.markAllDirty ();
		__fragmentUniformMap.markAllDirty ();
		
		for (sampler in __samplerUniforms) {
			
			if (sampler.regCount == 1) {
				
				GL.uniform1i (sampler.location, sampler.regIndex);
				GLUtils.CheckGLError ();
				
			} else {
				
				throw new IllegalOperationError ("!!! TODO: uniform location on webgl");
				
				/*
					TODO: Figure out +i on WebGL.
					// sampler array?
					for(i in 0...sampler.regCount) {
						GL.uniform1i(sampler.location + i, sampler.regIndex + i);
						GLUtils.CheckGLError ();
					}
					*/
			}
			
		}
		
		for (sampler in __alphaSamplerUniforms) {
			
			if (sampler.regCount == 1) {
				
				GL.uniform1i (sampler.location, sampler.regIndex);
				GLUtils.CheckGLError ();
				
			} else {
				
				throw new IllegalOperationError ("!!! TODO: uniform location on webgl");
				
				/*
					TODO: Figure out +i on WebGL.
					// sampler array?
					for(i in 0...sampler.regCount) {
						GL.uniform1i(sampler.location + i, sampler.regIndex + i);
						GLUtils.CheckGLError ();
					}
					*/
				
			}
			
		}
		
	}
	
	
}


private class Uniform {
	
	
	public var name:String;
	public var location:GLUniformLocation;
	public var type:Int;
	public var size:Int;
	public var regData:Float32Array;
	public var regIndex:Int;
	public var regCount:Int;
	public var isDirty:Bool;
	
	
	public function new () {
		
		isDirty = true;
		
	}
	
	
	public function flush ():Void {
		
		var index:Int = regIndex * 4;
		switch (type) {
			
			case GL.FLOAT_MAT2: GL.uniformMatrix2fv (location, false, __getRegisters (index, size * 2 * 2));
			case GL.FLOAT_MAT3: GL.uniformMatrix3fv (location, false, __getRegisters (index, size * 3 * 3));
			case GL.FLOAT_MAT4: GL.uniformMatrix4fv (location, false, __getRegisters (index, size * 4 * 4));
			case GL.FLOAT_VEC2: GL.uniform2fv (location, __getRegisters (index, regCount * 2));
			case GL.FLOAT_VEC3: GL.uniform3fv (location, __getRegisters (index, regCount * 3));
			case GL.FLOAT_VEC4: GL.uniform4fv (location, __getRegisters (index, regCount * 4));
			default: GL.uniform4fv (location, __getRegisters (index, regCount * 4));
			
		}
		
		GLUtils.CheckGLError ();
		
	}
	
	
	private function __getRegisters (index:Int, size:Int):Float32Array {
		
		// TODO
		// HACK: on Neko, CPP, subarray returns a view into the RegData
		// array. When uploading that data as a uniform, it will upload
		// the underlying array, which is far too long, causing it to
		// throw an exception. Workaround here is just to create a new
		// array and copy it directly so we know that it will be the
		// right size. Significant downside is that we're introducing
		// an extra copy.
		
		#if (js && html5)
		return this.regData.subarray (index, index + size);
		#else
		var result = new Float32Array (size);
		
		for (i in 0...size) {
			
			result[i] = this.regData[index + i];
			
		}
		
		return result;
		#end
		
	}
	
	
}


private class UniformMap {
	
	
	// TODO: it would be better to use a bitmask with a dirty bit per uniform, but not super important now
	
	private var __allDirty:Bool;
	private var __anyDirty:Bool;
	private var __registerLookup:Vector<Uniform>;
	private var __uniforms:Array<Uniform>;
	
	
	public function new (list:Array<Uniform>) {
		
		__uniforms = list;
		
		__uniforms.sort (function (a, b):Int {
			
			return Reflect.compare (a.regIndex, b.regIndex);
			
		});
		
		var total = 0;
		
		for (uniform in __uniforms) {
			
			if (uniform.regIndex + uniform.regCount > total) {
				
				total = uniform.regIndex + uniform.regCount;
				
			}
			
		}
		
		__registerLookup = new Vector<Uniform> (total);
		
		for (uniform in __uniforms) {
			
			for (i in 0...uniform.regCount) {
				
				__registerLookup[uniform.regIndex + i] = uniform;
				
			}
			
		}
		
		__anyDirty = __allDirty = true;
		
	}
	
	
	public function flush ():Void {
		
		if (__anyDirty) {
			
			for (uniform in __uniforms) {
				
				if (__allDirty || uniform.isDirty) {
					
					uniform.flush ();
					uniform.isDirty = false;
					
				}
				
			}
			
			__anyDirty = __allDirty = false;
			
		}
		
	}
	
	
	public function markAllDirty ():Void {
		
		__allDirty = true;
		__anyDirty = true;
		
	}
	
	
	public function markDirty (start:Int, count:Int):Void {
		
		if (__allDirty) {
			
			return;
			
		}
		
		var end = start + count;
		
		if (end > __registerLookup.length) {
			
			end = __registerLookup.length;
			
		}
		
		var index = start;
		
		while (index < end) {
			
			var uniform = __registerLookup[index];
			
			if (uniform != null) {
				
				uniform.isDirty = true;
				__anyDirty = true;
				
				index = uniform.regIndex + uniform.regCount;
				
			} else {
				
				index ++;
				
			}
			
		}
		
	}
	
	
}