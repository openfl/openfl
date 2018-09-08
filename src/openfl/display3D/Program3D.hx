package openfl.display3D; #if !flash


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.RenderContext;
import lime.utils.BytePointer;
import lime.utils.Float32Array;
import lime.utils.Log;
import lime.utils.LogLevel;
import openfl._internal.formats.agal.AGALConverter;
import openfl._internal.renderer.SamplerState;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)


@:final class Program3D {
	
	
	@:noCompletion private var __alphaSamplerEnabled:Array<Uniform>;
	@:noCompletion private var __alphaSamplerUniforms:List<Uniform>;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __format:Context3DProgramFormat;
	@:noCompletion private var __fragmentShaderID:GLShader;
	@:noCompletion private var __fragmentSource:String;
	@:noCompletion private var __fragmentUniformMap:UniformMap;
	@:noCompletion private var __location:Map<String, Int>;
	@:noCompletion private var __memUsage:Int;
	@:noCompletion private var __positionScale:Uniform;
	@:noCompletion private var __programID:GLProgram;
	@:noCompletion private var __samplerStates:Array<SamplerState>;
	@:noCompletion private var __samplerUniforms:List<Uniform>;
	@:noCompletion private var __samplerUsageMask:Int;
	@:noCompletion private var __uniforms:List<Uniform>;
	@:noCompletion private var __vertexShaderID:GLShader;
	@:noCompletion private var __vertexSource:String;
	@:noCompletion private var __vertexUniformMap:UniformMap;
	
	
	@:noCompletion private function new (context3D:Context3D, format:Context3DProgramFormat) {
		
		__context = context3D;
		__format = format;
		
		__memUsage = 0;
		__samplerUsageMask = 0;
		
		__location = new Map ();
		__uniforms = new List<Uniform> ();
		__samplerUniforms = new List<Uniform> ();
		__alphaSamplerUniforms = new List<Uniform> ();
		__alphaSamplerEnabled = new Array<Uniform> ();
		
		__samplerStates = new Array<SamplerState> ();
		
	}
	
	
	public function dispose ():Void {
		
		__deleteShaders ();
		
	}
	
	
	public function getAttributeIndex (name:String):Int {
		
		if (__format == AGAL) {
			
			// TODO: Validate that it exists in the current program
			
			if (StringTools.startsWith (name, "va")) {
				
				return Std.parseInt (name.substring (2));
				
			} else {
				
				return -1;
				
			}
			
		} else {
			
			if (!__location.exists (name)) {
				
				if (__programID != null) {
					
					__location[name] = cast __context.gl.getAttribLocation (__programID, name);
					return __location[name];
					
				} else {
					
					return -1;
					
				}
				
			} else {
				
				return __location[name];
				
			}
			
		}
		
	}
	
	
	public function getConstantIndex (name:String):Int {
		
		if (__format == AGAL) {
			
			// TODO: Validate that it exists in the current program
			
			if (StringTools.startsWith (name, "vc")) {
				
				return Std.parseInt (name.substring (2));
				
			} else if (StringTools.startsWith (name, "fc")) {
				
				return Std.parseInt (name.substring (2));
				
			} else {
				
				return -1;
				
			}
			
		} else {
			
			if (!__location.exists (name)) {
				
				if (__programID != null) {
					
					__location[name] = cast __context.gl.getUniformLocation (__programID, name);
					return __location[name];
					
				} else {
					
					return -1;
					
				}
				
			} else {
				
				return __location[name];
				
			}
			
		}
		
	}
	
	
	public function upload (vertexProgram:ByteArray, fragmentProgram:ByteArray):Void {
		
		if (__format != AGAL) return;
		
		//var samplerStates = new Vector<SamplerState> (Context3D.MAX_SAMPLERS);
		var samplerStates = new Array<SamplerState> ();
		
		var glslVertex = AGALConverter.convertToGLSL (vertexProgram, null);
		var glslFragment = AGALConverter.convertToGLSL (fragmentProgram, samplerStates);
		
		if (Log.level == LogLevel.VERBOSE) {
			
			Log.info (glslVertex);
			Log.info (glslFragment);
			
		}
		
		__uploadFromGLSL (glslVertex, glslFragment);
		
		for (i in 0...samplerStates.length) {
			
			__samplerStates[i] = samplerStates[i];
			
		}
		
	}
	
	
	public function uploadSources (vertexSource:String, fragmentSource:String):Void {
		
		if (__format != GLSL) return;
		
		__uploadFromGLSL (vertexSource, fragmentSource);
		
	}
	
	
	@:noCompletion private function __buildUniformList ():Void {
		
		if (__format == GLSL) return;
		
		var gl = __context.gl;
		
		__uniforms.clear ();
		__samplerUniforms.clear ();
		__alphaSamplerUniforms.clear ();
		__alphaSamplerEnabled = [];
		
		__samplerUsageMask = 0;
		
		var numActive = 0;
		numActive = gl.getProgramParameter (__programID, gl.ACTIVE_UNIFORMS);
		
		var vertexUniforms = new List<Uniform> ();
		var fragmentUniforms = new List<Uniform> ();
		
		for (i in 0...numActive) {
			
			var info = gl.getActiveUniform (__programID, i);
			var name = info.name;
			var size = info.size;
			var uniformType = info.type;
			
			var uniform = new Uniform (__context);
			uniform.name = name;
			uniform.size = size;
			uniform.type = uniformType;
			
			uniform.location = gl.getUniformLocation (__programID, uniform.name);
			
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
				
			} else if (StringTools.startsWith (uniform.name, "sampler") && uniform.name.indexOf ("alpha") == -1) {
				
				uniform.regIndex = Std.parseInt (uniform.name.substring (7));
				__samplerUniforms.add (uniform);
				
				for (reg in 0...uniform.regCount) {
					
					__samplerUsageMask |= (1 << (uniform.regIndex + reg));
					
				}
				
			} else if (StringTools.startsWith (uniform.name, "sampler") && StringTools.endsWith (uniform.name, "_alpha")) {
				
				var len = uniform.name.indexOf ("_") - 7;
				uniform.regIndex = Std.parseInt (uniform.name.substring (7, 7 + len)) + 4;
				__alphaSamplerUniforms.add (uniform);
				
			} else if (StringTools.startsWith (uniform.name, "sampler") && StringTools.endsWith (uniform.name, "_alphaEnabled")) {
				
				uniform.regIndex = Std.parseInt (uniform.name.substring (7));
				__alphaSamplerEnabled[uniform.regIndex] = uniform;
				
			}
			
			if (Log.level == LogLevel.VERBOSE) {
				
				trace ('${i} name:${uniform.name} type:${uniform.type} size:${uniform.size} location:${uniform.location}');
				
			}
			
		}
		
		__vertexUniformMap = new UniformMap (Lambda.array (vertexUniforms));
		__fragmentUniformMap = new UniformMap (Lambda.array (fragmentUniforms));
		
	}
	
	
	@:noCompletion private function __deleteShaders ():Void {
		
		var gl = __context.gl;
		
		if (__programID != null) {
			
			// this causes an exception EntryPoIntNotFound ..
			// gl.DeleteProgram (1, ref __programID  );
			__programID = null;
			
		}
		
		if (__vertexShaderID != null) {
			
			gl.deleteShader (__vertexShaderID);
			__vertexShaderID = null;
			
		}
		
		if (__fragmentShaderID != null) {
			
			gl.deleteShader (__fragmentShaderID);
			__fragmentShaderID = null;
			
		}
		
	}
	
	
	@:noCompletion private function __flush ():Void {
		
		__vertexUniformMap.flush ();
		__fragmentUniformMap.flush ();
		
	}
	
	
	@:noCompletion private function __getSamplerState (sampler:Int):SamplerState {
		
		return __samplerStates[sampler];
		
	}
	
	
	@:noCompletion private function __markDirty (isVertex:Bool, index:Int, count:Int):Void {
		
		if (isVertex) {
			
			__vertexUniformMap.markDirty (index, count);
			
		} else {
			
			__fragmentUniformMap.markDirty (index, count);
			
		}
		
	}
	
	
	@:noCompletion private function __setPositionScale (positionScale:Float32Array):Void {
		
		if (__positionScale != null) {
			
			var gl = __context.gl;
			gl.uniform4fv (__positionScale.location, positionScale);
			
		}
		
	}
	
	
	@:noCompletion private function __setSamplerState (sampler:Int, state:SamplerState):Void {
		
		__samplerStates[sampler] = state;
		
	}
	
	
	@:noCompletion private function __uploadFromGLSL (vertexShaderSource:String, fragmentShaderSource:String):Void {
		
		var gl = __context.gl;
		
		__deleteShaders ();
		
		__vertexSource = vertexShaderSource;
		__fragmentSource = fragmentShaderSource;
		
		__vertexShaderID = gl.createShader (gl.VERTEX_SHADER);
		gl.shaderSource (__vertexShaderID, vertexShaderSource);
		
		gl.compileShader (__vertexShaderID);
		
		var shaderCompiled = gl.getShaderParameter (__vertexShaderID, gl.COMPILE_STATUS);
		
		if (shaderCompiled == 0) {
			
			var vertexInfoLog = gl.getShaderInfoLog (__vertexShaderID);
			
			if (vertexInfoLog != null && vertexInfoLog.length != 0) {
				
				trace ('vertex: ${vertexInfoLog}');
				
			}
			
			throw new Error ("Error compiling vertex shader: " + vertexInfoLog);
			
		}
		
		__fragmentShaderID = gl.createShader (gl.FRAGMENT_SHADER);
		gl.shaderSource (__fragmentShaderID, fragmentShaderSource);
		
		gl.compileShader (__fragmentShaderID);
		
		var fragmentCompiled = gl.getShaderParameter (__fragmentShaderID, gl.COMPILE_STATUS);
		
		if (fragmentCompiled == 0) {
			
			var fragmentInfoLog = gl.getShaderInfoLog (__fragmentShaderID);
			
			if (fragmentInfoLog != null && fragmentInfoLog.length != 0) {
				
				trace ('fragment: ${fragmentInfoLog}');
				
			}
			
			throw new Error ("Error compiling fragment shader: " + fragmentInfoLog);
			
		}
		
		__programID = gl.createProgram ();
		gl.attachShader (__programID, __vertexShaderID);
		
		gl.attachShader (__programID, __fragmentShaderID);
		
		// TODO: AGAL version specific number of attributes?
		for (i in 0...16) {
		// for (i in 0...Context3D.MAX_ATTRIBUTES) {
			
			var name = "va" + i;
			
			if (vertexShaderSource.indexOf (" " + name) != -1) {
				
				gl.bindAttribLocation (__programID, i, name);
				
			}
			
		}
		
		gl.linkProgram (__programID);
		
		var infoLog:String = gl.getProgramInfoLog (__programID);
		
		if (infoLog != null && infoLog.length != 0 && StringTools.trim (infoLog) != "") {
			
			trace ('program: ${infoLog}');
			
		}
		
		__buildUniformList ();
		
	}
	
	
	@:noCompletion private function __use ():Void {
		
		var context = __context;
		var gl = context.gl;
		
		gl.useProgram (__programID);
		
		__vertexUniformMap.markAllDirty ();
		__fragmentUniformMap.markAllDirty ();
		
		for (sampler in __samplerUniforms) {
			
			if (sampler.regCount == 1) {
				
				gl.uniform1i (sampler.location, sampler.regIndex);
				
			} else {
				
				throw new IllegalOperationError ("!!! TODO: uniform location on webgl");
				
			}
			
		}
		
		for (sampler in __alphaSamplerUniforms) {
			
			if (sampler.regCount == 1) {
				
				gl.uniform1i (sampler.location, sampler.regIndex);
				
			} else {
				
				throw new IllegalOperationError ("!!! TODO: uniform location on webgl");
				
			}
			
		}
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)


@:dox(hide) @:noCompletion class Uniform {
	
	
	public var name:String;
	public var location:GLUniformLocation;
	public var type:Int;
	public var size:Int;
	public var regData:Float32Array;
	public var regIndex:Int;
	public var regCount:Int;
	public var isDirty:Bool;
	
	public var context:Context3D;
	public var regDataPointer:BytePointer;
	
	
	public function new (context:Context3D) {
		
		this.context = context;
		
		isDirty = true;
		regDataPointer = new BytePointer ();
		
	}
	
	
	public function flush ():Void {
		
		#if (js && html5)
		var gl = context.gl;
		#else
		var gl = context.__context.gles2;
		#end
		
		var index:Int = regIndex * 4;
		switch (type) {
			
			#if (js && html5)
			case GL.FLOAT_MAT2: gl.uniformMatrix2fv (location, false, __getUniformRegisters (index, size * 2 * 2));
			case GL.FLOAT_MAT3: gl.uniformMatrix3fv (location, false, __getUniformRegisters (index, size * 3 * 3));
			case GL.FLOAT_MAT4: gl.uniformMatrix4fv (location, false, __getUniformRegisters (index, size * 4 * 4));
			case GL.FLOAT_VEC2: gl.uniform2fv (location, __getUniformRegisters (index, regCount * 2));
			case GL.FLOAT_VEC3: gl.uniform3fv (location, __getUniformRegisters (index, regCount * 3));
			case GL.FLOAT_VEC4: gl.uniform4fv (location, __getUniformRegisters (index, regCount * 4));
			default: gl.uniform4fv (location, __getUniformRegisters (index, regCount * 4));
			#else
			case GL.FLOAT_MAT2: gl.uniformMatrix2fv (location, size, false, __getUniformRegisters (index, size * 2 * 2));
			case GL.FLOAT_MAT3: gl.uniformMatrix3fv (location, size, false, __getUniformRegisters (index, size * 3 * 3));
			case GL.FLOAT_MAT4: gl.uniformMatrix4fv (location, size, false, __getUniformRegisters (index, size * 4 * 4));
			case GL.FLOAT_VEC2: gl.uniform2fv (location, regCount, __getUniformRegisters (index, regCount * 2));
			case GL.FLOAT_VEC3: gl.uniform3fv (location, regCount, __getUniformRegisters (index, regCount * 3));
			case GL.FLOAT_VEC4: gl.uniform4fv (location, regCount, __getUniformRegisters (index, regCount * 4));
			default: gl.uniform4fv (location, regCount, __getUniformRegisters (index, regCount * 4));
			#end
			
		}
		
	}
	
	
	#if (js && html5)
	@:noCompletion private inline function __getUniformRegisters (index:Int, size:Int):Float32Array {
		
		return regData.subarray (index, index + size);
		
	}
	#else
	@:noCompletion private inline function __getUniformRegisters (index:Int, size:Int):BytePointer {
		
		regDataPointer.set (regData, index * 4);
		return regDataPointer;
		
	}
	#end
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) @:noCompletion class UniformMap {
	
	
	// TODO: it would be better to use a bitmask with a dirty bit per uniform, but not super important now
	
	@:noCompletion private var __allDirty:Bool;
	@:noCompletion private var __anyDirty:Bool;
	@:noCompletion private var __registerLookup:Vector<Uniform>;
	@:noCompletion private var __uniforms:Array<Uniform>;
	
	
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


#else
typedef Program3D = flash.display3D.Program3D;
#end