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
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.display.ShaderParameter;
import openfl.display.ShaderParameterType;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.ShaderInput)
@:access(openfl.display.ShaderParameter)
@:access(openfl.display.Stage)


@:final class Program3D {
	
	
	@:noCompletion private var __agalAlphaSamplerEnabled:Array<Uniform>;
	@:noCompletion private var __agalAlphaSamplerUniforms:List<Uniform>;
	@:noCompletion private var __agalFragmentUniformMap:UniformMap;
	@:noCompletion private var __agalPositionScale:Uniform;
	@:noCompletion private var __agalSamplerUniforms:List<Uniform>;
	@:noCompletion private var __agalSamplerUsageMask:Int;
	@:noCompletion private var __agalUniforms:List<Uniform>;
	@:noCompletion private var __agalVertexUniformMap:UniformMap;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __format:Context3DProgramFormat;
	@:noCompletion private var __glFragmentShader:GLShader;
	@:noCompletion private var __glFragmentSource:String;
	@:noCompletion private var __glProgram:GLProgram;
	@:noCompletion private var __glslAttribNames:Array<String>;
	@:noCompletion private var __glslAttribTypes:Array<ShaderParameterType>;
	@:noCompletion private var __glslSamplerNames:Array<String>;
	@:noCompletion private var __glslUniformNames:Array<String>;
	@:noCompletion private var __glslUniformTypes:Array<ShaderParameterType>;
	@:noCompletion private var __glVertexShader:GLShader;
	@:noCompletion private var __glVertexSource:String;
	// @:noCompletion private var __memUsage:Int;
	@:noCompletion private var __samplerStates:Array<SamplerState>;
	
	
	@:noCompletion private function new (context3D:Context3D, format:Context3DProgramFormat) {
		
		__context = context3D;
		__format = format;
		
		if (__format == AGAL) {
			
			// __memUsage = 0;
			__agalSamplerUsageMask = 0;
			__agalUniforms = new List<Uniform> ();
			__agalSamplerUniforms = new List<Uniform> ();
			__agalAlphaSamplerUniforms = new List<Uniform> ();
			__agalAlphaSamplerEnabled = new Array<Uniform> ();
			
		} else {
			
			__glslAttribNames = new Array ();
			__glslAttribTypes = new Array ();
			__glslSamplerNames = new Array ();
			__glslUniformNames = new Array ();
			__glslUniformTypes = new Array ();
			
		}
		
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
			
			for (i in 0...__glslAttribNames.length) {
				
				if (__glslAttribNames[i] == name) return i;
				
			}
			
			return -1;
			
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
			
			for (i in 0...__glslUniformNames.length) {
				
				if (__glslUniformNames[i] == name) return i;
				
			}
			
			return -1;
			
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
		
		__deleteShaders ();
		__uploadFromGLSL (glslVertex, glslFragment);
		__buildAGALUniformList ();
		
		for (i in 0...samplerStates.length) {
			
			__samplerStates[i] = samplerStates[i];
			
		}
		
	}
	
	
	public function uploadSources (vertexSource:String, fragmentSource:String):Void {
		
		if (__format != GLSL) return;
		
		// TODO: Precision hint?
		
		var prefix = 
			
			"#ifdef GL_ES
			#ifdef GL_FRAGMENT_PRECISION_HIGH
			precision highp float;
			#else
			precision mediump float;
			#endif
			#endif
			";
		
		var vertex = prefix + vertexSource;
		var fragment = prefix + fragmentSource;
		
		if (vertex == __glVertexSource && fragment == __glFragmentSource) return;
		
		__processGLSLData (vertexSource, "attribute");
		__processGLSLData (vertexSource, "uniform");
		__processGLSLData (fragmentSource, "uniform");
		
		__deleteShaders ();	
		__uploadFromGLSL (vertex, fragment);
		
		// Sort by index
		
		var samplerNames = __glslSamplerNames;
		var attribNames = __glslAttribNames;
		var attribTypes = __glslAttribTypes;
		var uniformNames = __glslUniformNames;
		var uniformTypes = __glslUniformTypes;
		
		__glslSamplerNames = new Array ();
		__glslAttribNames = new Array ();
		__glslAttribTypes = new Array ();
		__glslUniformNames = new Array ();
		
		var gl = __context.gl;
		var index:Int;
		
		for (name in samplerNames) {
			
			index = cast gl.getUniformLocation (__glProgram, name);
			__glslSamplerNames[index] = name;
			
		}
		
		for (i in 0...attribNames.length) {
			
			index = gl.getAttribLocation (__glProgram, attribNames[i]);
			__glslAttribNames[index] = attribNames[i];
			__glslAttribTypes[index] = attribTypes[i];
			
		}
		
		for (i in 0...uniformNames.length) {
			
			index = cast gl.getUniformLocation (__glProgram, uniformNames[i]);
			__glslAttribNames[index] = uniformNames[i];
			__glslAttribTypes[index] = uniformTypes[i];
			
		}
		
	}
	
	
	@:noCompletion private function __buildAGALUniformList ():Void {
		
		if (__format == GLSL) return;
		
		var gl = __context.gl;
		
		__agalUniforms.clear ();
		__agalSamplerUniforms.clear ();
		__agalAlphaSamplerUniforms.clear ();
		__agalAlphaSamplerEnabled = [];
		
		__agalSamplerUsageMask = 0;
		
		var numActive = 0;
		numActive = gl.getProgramParameter (__glProgram, gl.ACTIVE_UNIFORMS);
		
		var vertexUniforms = new List<Uniform> ();
		var fragmentUniforms = new List<Uniform> ();
		
		for (i in 0...numActive) {
			
			var info = gl.getActiveUniform (__glProgram, i);
			var name = info.name;
			var size = info.size;
			var uniformType = info.type;
			
			var uniform = new Uniform (__context);
			uniform.name = name;
			uniform.size = size;
			uniform.type = uniformType;
			
			uniform.location = gl.getUniformLocation (__glProgram, uniform.name);
			
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
			
			__agalUniforms.add (uniform);
			
			if (uniform.name == "vcPositionScale") {
				
				__agalPositionScale = uniform;
				
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
				__agalSamplerUniforms.add (uniform);
				
				for (reg in 0...uniform.regCount) {
					
					__agalSamplerUsageMask |= (1 << (uniform.regIndex + reg));
					
				}
				
			} else if (StringTools.startsWith (uniform.name, "sampler") && StringTools.endsWith (uniform.name, "_alpha")) {
				
				var len = uniform.name.indexOf ("_") - 7;
				uniform.regIndex = Std.parseInt (uniform.name.substring (7, 7 + len)) + 4;
				__agalAlphaSamplerUniforms.add (uniform);
				
			} else if (StringTools.startsWith (uniform.name, "sampler") && StringTools.endsWith (uniform.name, "_alphaEnabled")) {
				
				uniform.regIndex = Std.parseInt (uniform.name.substring (7));
				__agalAlphaSamplerEnabled[uniform.regIndex] = uniform;
				
			}
			
			if (Log.level == LogLevel.VERBOSE) {
				
				trace ('${i} name:${uniform.name} type:${uniform.type} size:${uniform.size} location:${uniform.location}');
				
			}
			
		}
		
		__agalVertexUniformMap = new UniformMap (Lambda.array (vertexUniforms));
		__agalFragmentUniformMap = new UniformMap (Lambda.array (fragmentUniforms));
		
	}
	
	
	@:noCompletion private function __deleteShaders ():Void {
		
		var gl = __context.gl;
		
		if (__glProgram != null) {
			
			__glProgram = null;
			
		}
		
		if (__glVertexShader != null) {
			
			gl.deleteShader (__glVertexShader);
			__glVertexShader = null;
			
		}
		
		if (__glFragmentShader != null) {
			
			gl.deleteShader (__glFragmentShader);
			__glFragmentShader = null;
			
		}
		
	}
	
	
	@:noCompletion private function __disable ():Void {
		
		if (__format == GLSL) {
			
			// var gl = __context.gl;
			// var textureCount = 0;
			
			// for (input in __glslInputBitmapData) {
				
			// 	input.__disableGL (__context, textureCount);
			// 	textureCount++;
				
			// }
			
			// for (parameter in __glslParamBool) {
				
			// 	parameter.__disableGL (__context);
				
			// }
			
			// for (parameter in __glslParamFloat) {
				
			// 	parameter.__disableGL (__context);
				
			// }
			
			// for (parameter in __glslParamInt) {
				
			// 	parameter.__disableGL (__context);
				
			// }
			
			// // __context.__bindGLArrayBuffer (null);
			
			// if (__context.__context.type == OPENGL) {
				
			// 	gl.disable (gl.TEXTURE_2D);
				
			// }
			
		}
		
	}
	
	
	@:noCompletion private function __enable ():Void {
		
		var gl = __context.gl;
		gl.useProgram (__glProgram);
		
		if (__format == AGAL) {
				
			__agalVertexUniformMap.markAllDirty ();
			__agalFragmentUniformMap.markAllDirty ();
			
			for (sampler in __agalSamplerUniforms) {
				
				if (sampler.regCount == 1) {
					
					gl.uniform1i (sampler.location, sampler.regIndex);
					
				} else {
					
					throw new IllegalOperationError ("!!! TODO: uniform location on webgl");
					
				}
				
			}
			
			for (sampler in __agalAlphaSamplerUniforms) {
				
				if (sampler.regCount == 1) {
					
					gl.uniform1i (sampler.location, sampler.regIndex);
					
				} else {
					
					throw new IllegalOperationError ("!!! TODO: uniform location on webgl");
					
				}
				
			}
			
		} else {
			
			// var textureCount = 0;
			
			// var gl = __context.gl;
			
			// for (input in __glslInputBitmapData) {
				
			// 	gl.uniform1i (input.index, textureCount);
			// 	textureCount++;
				
			// }
			
			// if (__context.__context.type == OPENGL && textureCount > 0) {
				
			// 	gl.enable (gl.TEXTURE_2D);
				
			// }
			
		}
		
	}
	
	
	@:noCompletion private function __flush ():Void {
		
		if (__format == AGAL) {
			
			__agalVertexUniformMap.flush ();
			__agalFragmentUniformMap.flush ();
			
		} else {
			
			// TODO
			return;
			
			// var textureCount = 0;
			
			// for (input in __glslInputBitmapData) {
				
			// 	input.__updateGL (__context, textureCount);
			// 	textureCount++;
				
			// }
			
			// for (parameter in __glslParamBool) {
				
			// 	parameter.__updateGL (__context);
				
			// }
			
			// for (parameter in __glslParamFloat) {
				
			// 	parameter.__updateGL (__context);
				
			// }
			
			// for (parameter in __glslParamInt) {
				
			// 	parameter.__updateGL (__context);
				
			// }
			
		}
		
	}
	
	
	@:noCompletion private function __getSamplerState (sampler:Int):SamplerState {
		
		return __samplerStates[sampler];
		
	}
	
	
	@:noCompletion private function __markDirty (isVertex:Bool, index:Int, count:Int):Void {
		
		if (__format == GLSL) return;
		
		if (isVertex) {
			
			__agalVertexUniformMap.markDirty (index, count);
			
		} else {
			
			__agalFragmentUniformMap.markDirty (index, count);
			
		}
		
	}
	
	
	@:noCompletion private function __processGLSLData (source:String, storageType:String):Void {
		
		var lastMatch = 0, position, regex, name, type;
		
		if (storageType == "uniform") {
			
			regex = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/;
			
		} else {
			
			regex = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/;
			
		}
		
		while (regex.matchSub (source, lastMatch)) {
			
			type = regex.matched (1);
			name = regex.matched (2);
			
			if (StringTools.startsWith (name, "gl_")) {
				
				continue;
				
			}
			
			if (StringTools.startsWith (type, "sampler")) {
				
				__glslSamplerNames.push (name);
				
			} else {
				
				var parameterType:ShaderParameterType = switch (type) {
					
					case "bool": BOOL;
					case "double", "float": FLOAT;
					case "int", "uint": INT;
					case "bvec2": BOOL2;
					case "bvec3": BOOL3;
					case "bvec4": BOOL4;
					case "ivec2", "uvec2": INT2;
					case "ivec3", "uvec3": INT3;
					case "ivec4", "uvec4": INT4;
					case "vec2", "dvec2": FLOAT2;
					case "vec3", "dvec3": FLOAT3;
					case "vec4", "dvec4": FLOAT4;
					case "mat2", "mat2x2": MATRIX2X2;
					case "mat2x3": MATRIX2X3;
					case "mat2x4": MATRIX2X4;
					case "mat3x2": MATRIX3X2;
					case "mat3", "mat3x3": MATRIX3X3;
					case "mat3x4": MATRIX3X4;
					case "mat4x2": MATRIX4X2;
					case "mat4x3": MATRIX4X3;
					case "mat4", "mat4x4": MATRIX4X4;
					default: null;
					
				}
				
				if (storageType == "uniform") {
					
					__glslUniformNames.push (name);
					__glslUniformTypes.push (parameterType);
					
				} else {
					
					__glslAttribNames.push (name);
					__glslAttribTypes.push (parameterType);
					
				}
				
			}
			
			position = regex.matchedPos ();
			lastMatch = position.pos + position.len;
			
		}
		
	}
	
	
	@:noCompletion private function __setPositionScale (positionScale:Float32Array):Void {
		
		if (__format == GLSL) return;
		
		if (__agalPositionScale != null) {
			
			var gl = __context.gl;
			gl.uniform4fv (__agalPositionScale.location, positionScale);
			
		}
		
	}
	
	
	@:noCompletion private function __setSamplerState (sampler:Int, state:SamplerState):Void {
		
		__samplerStates[sampler] = state;
		
	}
	
	
	@:noCompletion private function __uploadFromGLSL (vertexShaderSource:String, fragmentShaderSource:String):Void {
		
		var gl = __context.gl;
		
		__glVertexSource = vertexShaderSource;
		__glFragmentSource = fragmentShaderSource;
		
		__glVertexShader = gl.createShader (gl.VERTEX_SHADER);
		gl.shaderSource (__glVertexShader, vertexShaderSource);
		gl.compileShader (__glVertexShader);
		
		if (gl.getShaderParameter (__glVertexShader, gl.COMPILE_STATUS) == 0) {
			
			var message = "Error compiling vertex shader";
			message += "\n" + gl.getShaderInfoLog (__glVertexShader);
			message += "\n" + vertexShaderSource;
			Log.error (message);
			
		}
		
		__glFragmentShader = gl.createShader (gl.FRAGMENT_SHADER);
		gl.shaderSource (__glFragmentShader, fragmentShaderSource);
		gl.compileShader (__glFragmentShader);
		
		if (gl.getShaderParameter (__glFragmentShader, gl.COMPILE_STATUS) == 0) {
			
			var message = "Error compiling fragment shader";
			message += "\n" + gl.getShaderInfoLog (__glFragmentShader);
			message += "\n" + fragmentShaderSource;
			Log.error (message);
			
		}
		
		__glProgram = gl.createProgram ();
		
		if (__format == AGAL) {
			
			// TODO: AGAL version specific number of attributes?
			for (i in 0...16) {
			// for (i in 0...Context3D.MAX_ATTRIBUTES) {
				
				var name = "va" + i;
				
				if (vertexShaderSource.indexOf (" " + name) != -1) {
					
					gl.bindAttribLocation (__glProgram, i, name);
					
				}
				
			}
			
		} else {
			
			// Fix support for drivers that don't draw if attribute 0 is disabled
			for (name in __glslAttribNames) {
				
				if (name.indexOf ("Position") > -1 && StringTools.startsWith (name, "openfl_")) {
					
					gl.bindAttribLocation (__glProgram, 0, name);
					break;
					
				}
				
			}
			
		}
		
		gl.attachShader (__glProgram, __glVertexShader);
		gl.attachShader (__glProgram, __glFragmentShader);
		gl.linkProgram (__glProgram);
		
		if (gl.getProgramParameter (__glProgram, gl.LINK_STATUS) == 0) {
			
			var message = "Unable to initialize the shader program";
			message += "\n" + gl.getProgramInfoLog (__glProgram);
			Log.error (message);
			
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