package openfl.display; #if !flash


import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.utils.Float32Array;
import lime.utils.Log;
import openfl._internal.renderer.ShaderBuffer;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display.ShaderInput)
@:access(openfl.display.ShaderParameter)

// #if (!display && !macro)
#if !macro
@:autoBuild(openfl._internal.macros.ShaderMacro.build())
#end


class Shader {
	
	
	@:noCompletion private static var __programs = new Map<String, Program3D> ();
	
	public var byteCode (null, default):ByteArray;
	public var data (get, set):ShaderData;
	public var glFragmentSource (get, set):String;
	public var glProgram (default, null):GLProgram;
	public var glVertexSource (get, set):String;
	public var precisionHint:ShaderPrecision;
	public var program:Program3D;
	
	@:noCompletion private var __alpha:ShaderParameter<Float>;
	@:noCompletion private var __bitmap:ShaderInput<BitmapData>;
	@:noCompletion private var __colorMultiplier:ShaderParameter<Float>;
	@:noCompletion private var __colorOffset:ShaderParameter<Float>;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __data:ShaderData;
	@:noCompletion private var __glFragmentSource:String;
	@:noCompletion private var __glSourceDirty:Bool;
	@:noCompletion private var __glVertexSource:String;
	@:noCompletion private var __hasColorTransform:ShaderParameter<Bool>;
	@:noCompletion private var __inputBitmapData:Array<ShaderInput<BitmapData>>;
	@:noCompletion private var __isGenerated:Bool;
	@:noCompletion private var __matrix:ShaderParameter<Float>;
	@:noCompletion private var __numPasses:Int;
	@:noCompletion private var __paramBool:Array<ShaderParameter<Bool>>;
	@:noCompletion private var __paramFloat:Array<ShaderParameter<Float>>;
	@:noCompletion private var __paramInt:Array<ShaderParameter<Int>>;
	@:noCompletion private var __position:ShaderParameter<Float>;
	@:noCompletion private var __textureCoord:ShaderParameter<Float>;
	@:noCompletion private var __texture:ShaderInput<BitmapData>;
	@:noCompletion private var __textureSize:ShaderParameter<Float>;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperties (Shader.prototype, {
			"data": { get: untyped __js__ ("function () { return this.get_data (); }"), set: untyped __js__ ("function (v) { return this.set_data (v); }") },
			"glFragmentSource": { get: untyped __js__ ("function () { return this.get_glFragmentSource (); }"), set: untyped __js__ ("function (v) { return this.set_glFragmentSource (v); }") },
			"glVertexSource": { get: untyped __js__ ("function () { return this.get_glVertexSource (); }"), set: untyped __js__ ("function (v) { return this.set_glVertexSource (v); }") },
		});
		
	}
	#end
	
	
	public function new (code:ByteArray = null) {
		
		byteCode = code;
		precisionHint = FULL;
		
		__glSourceDirty = true;
		__numPasses = 1;
		__data = new ShaderData (code);
		
	}
	
	
	@:noCompletion private function __clearUseArray ():Void {
		
		for (parameter in __paramBool) {
			
			parameter.__useArray = false;
			
		}
		
		for (parameter in __paramFloat) {
			
			parameter.__useArray = false;
			
		}
		
		for (parameter in __paramInt) {
			
			parameter.__useArray = false;
			
		}
		
	}
	
	
	// private function __clone ():Shader {
		
		// var classType = Type.getClass (this);
		// var shader = Type.createInstance (classType, []);
		
		// for (input in __inputBitmapData) {
			
		// 	if (input.input != null) {
				
		// 		var field = Reflect.field (shader.data, input.name);
				
		// 		field.channels = input.channels;
		// 		field.height = input.height;
		// 		field.input = input.input;
		// 		field.smoothing = input.smoothing;
		// 		field.width = input.width;
				
		// 	}
			
		// }
		
		// for (param in __paramBool) {
			
		// 	if (param.value != null) {
				
		// 		Reflect.field (shader.data, param.name).value = param.value.copy ();
				
		// 	}
			
		// }
		
		// for (param in __paramFloat) {
			
		// 	if (param.value != null) {
				
		// 		Reflect.field (shader.data, param.name).value = param.value.copy ();
				
		// 	}
			
		// }
		
		// for (param in __paramInt) {
			
		// 	if (param.value != null) {
				
		// 		Reflect.field (shader.data, param.name).value = param.value.copy ();
				
		// 	}
			
		// }
		
		// return shader;
		
	// }
	
	
	@:noCompletion private function __createGLShader (source:String, type:Int):GLShader {
		
		var gl = __context.gl;
		
		var shader = gl.createShader (type);
		gl.shaderSource (shader, source);
		gl.compileShader (shader);
		
		if (gl.getShaderParameter (shader, gl.COMPILE_STATUS) == 0) {
			
			var message = (type == gl.VERTEX_SHADER) ? "Error compiling vertex shader" : "Error compiling fragment shader";
			message += "\n" + gl.getShaderInfoLog (shader);
			message += "\n" + source;
			Log.error (message);
			
		}
		
		return shader;
		
	}
	
	
	@:noCompletion private function __createGLProgram (vertexSource:String, fragmentSource:String):GLProgram {
		
		var gl = __context.gl;
		
		var vertexShader = __createGLShader (vertexSource, gl.VERTEX_SHADER);
		var fragmentShader = __createGLShader (fragmentSource, gl.FRAGMENT_SHADER);
		
		var program = gl.createProgram ();
		
		// Fix support for drivers that don't draw if attribute 0 is disabled
		for (param in __paramFloat) {
			
			if (param.name.indexOf ("Position") > -1 && StringTools.startsWith (param.name, "openfl_")) {
				
				gl.bindAttribLocation (program, 0, param.name);
				break;
				
			}
			
		}
		
		gl.attachShader (program, vertexShader);
		gl.attachShader (program, fragmentShader);
		gl.linkProgram (program);
		
		if (gl.getProgramParameter (program, gl.LINK_STATUS) == 0) {
			
			var message = "Unable to initialize the shader program";
			message += "\n" + gl.getProgramInfoLog (program);
			Log.error (message);
			
		}
		
		return program;
		
	}
	
	
	@:noCompletion private function __disable ():Void {
		
		if (program != null) {
			
			__disableGL ();
			
		}
		
	}
	
	
	@:noCompletion private function __disableGL ():Void {
		
		var gl = __context.gl;
		
		var textureCount = 0;
		for (input in __inputBitmapData) {
			
			input.__disableGL (__context, textureCount);
			textureCount++;
			
		}
		
		for (parameter in __paramBool) {
			
			parameter.__disableGL (__context);
			
		}
		
		for (parameter in __paramFloat) {
			
			parameter.__disableGL (__context);
			
		}
		
		for (parameter in __paramInt) {
			
			parameter.__disableGL (__context);
			
		}
		
		__context.__bindGLArrayBuffer (null);
		
		if (__context.__context.type == OPENGL) {
			
			gl.disable (gl.TEXTURE_2D);
			
		}
		
	}
	
	
	@:noCompletion private function __enable ():Void {
		
		__init ();
		
		if (program != null) {
			
			__enableGL ();
			
		}
		
	}
	
	
	@:noCompletion private function __enableGL ():Void {
		
		var textureCount = 0;
		
		var gl = __context.gl;
		
		for (input in __inputBitmapData) {
			
			gl.uniform1i (input.index, textureCount);
			textureCount++;
			
		}
		
		if (__context.__context.type == OPENGL && textureCount > 0) {
			
			gl.enable (gl.TEXTURE_2D);
			
		}
		
	}
	
	
	@:noCompletion private function __init ():Void {
		
		if (__data == null) {
			
			__data = cast new ShaderData (null);
			
		}
		
		if (__glFragmentSource != null && __glVertexSource != null && (program == null || __glSourceDirty)) {
			
			__initGL ();
			
		}
		
	}
	
	
	@:noCompletion private function __initGL ():Void {
		
		if (__glSourceDirty || __paramBool == null) {
			
			__glSourceDirty = false;
			program = null;
			
			__inputBitmapData = new Array ();
			__paramBool = new Array ();
			__paramFloat = new Array ();
			__paramInt = new Array ();
			
			__processGLData (glVertexSource, "attribute");
			__processGLData (glVertexSource, "uniform");
			__processGLData (glFragmentSource, "uniform");
			
		}
		
		if (__context != null && program == null) {
			
			var gl = __context.gl;
			
			var prefix = 
				
				"#ifdef GL_ES
					#ifdef GL_FRAGMENT_PRECISION_HIGH
					precision highp float;
					#else
					precision " + (precisionHint == FULL ? "mediump" : "lowp") + " float;
					#endif // GL_FRAGMENT_PRECISION_HIGH
				#endif // GL_ES
				";
			
			var vertex = prefix + glVertexSource;
			var fragment = prefix + glFragmentSource;
			
			var id = vertex + fragment;
			
			if (__programs.exists (id)) {
				
				program = __programs.get (id);
				
			} else {
				
				program = __context.createProgram (GLSL);
				
				// TODO
				// program.uploadSources (vertex, fragment);
				program.__programID = __createGLProgram (vertex, fragment);
				
				__programs.set (id, program);
				
			}
			
			if (program != null) {
				
				glProgram = program.__programID;
				
				for (input in __inputBitmapData) {
					
					if (input.__isUniform) {
						
						input.index = gl.getUniformLocation (glProgram, input.name);
						
					} else {
						
						input.index = gl.getAttribLocation (glProgram, input.name);
						
					}
					
				}
				
				for (parameter in __paramBool) {
					
					if (parameter.__isUniform) {
						
						parameter.index = gl.getUniformLocation (glProgram, parameter.name);
						
					} else {
						
						parameter.index = gl.getAttribLocation (glProgram, parameter.name);
						
					}
					
				}
				
				for (parameter in __paramFloat) {
					
					if (parameter.__isUniform) {
						
						parameter.index = gl.getUniformLocation (glProgram, parameter.name);
						
					} else {
						
						parameter.index = gl.getAttribLocation (glProgram, parameter.name);
						
					}
					
				}
				
				for (parameter in __paramInt) {
					
					if (parameter.__isUniform) {
						
						parameter.index = gl.getUniformLocation (glProgram, parameter.name);
						
					} else {
						
						parameter.index = gl.getAttribLocation (glProgram, parameter.name);
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __processGLData (source:String, storageType:String):Void {
		
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
			
			var isUniform = (storageType == "uniform");
			
			if (StringTools.startsWith (type, "sampler")) {
				
				var input = new ShaderInput<BitmapData> ();
				input.name = name;
				input.__isUniform = isUniform;
				__inputBitmapData.push (input);
				
				switch (name) {
					
					case "openfl_Texture": __texture = input;
					case "bitmap": __bitmap = input;
					default:
					
				}
				
				Reflect.setField (__data, name, input);
				if (__isGenerated) Reflect.setField (this, name, input);
				
			} else if (!Reflect.hasField (__data, name) || Reflect.field (__data, name) == null) {
				
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
				
				var length = switch (parameterType) {
					
					case BOOL2, INT2, FLOAT2: 2;
					case BOOL3, INT3, FLOAT3: 3;
					case BOOL4, INT4, FLOAT4, MATRIX2X2: 4;
					case MATRIX3X3: 9;
					case MATRIX4X4: 16;
					default: 1;
					
				}
				
				var arrayLength = switch (parameterType) {
					
					case MATRIX2X2: 2;
					case MATRIX3X3: 3;
					case MATRIX4X4: 4;
					default: 1;
					
				}
				
				switch (parameterType) {
					
					case BOOL, BOOL2, BOOL3, BOOL4:
						
						var parameter = new ShaderParameter<Bool> ();
						parameter.name = name;
						parameter.type = parameterType;
						parameter.__arrayLength = arrayLength;
						parameter.__isBool = true;
						parameter.__isUniform = isUniform;
						parameter.__length = length;
						__paramBool.push (parameter);
						
						if (name == "openfl_HasColorTransform") {
							
							__hasColorTransform = parameter;
							
						}
						
						Reflect.setField (__data, name, parameter);
						if (__isGenerated) Reflect.setField (this, name, parameter);
					
					case INT, INT2, INT3, INT4:
						
						var parameter = new ShaderParameter<Int> ();
						parameter.name = name;
						parameter.type = parameterType;
						parameter.__arrayLength = arrayLength;
						parameter.__isInt = true;
						parameter.__isUniform = isUniform;
						parameter.__length = length;
						__paramInt.push (parameter);
						Reflect.setField (__data, name, parameter);
						if (__isGenerated) Reflect.setField (this, name, parameter);
					
					default:
						
						var parameter = new ShaderParameter<Float> ();
						parameter.name = name;
						parameter.type = parameterType;
						parameter.__arrayLength = arrayLength;
						if (arrayLength > 0) parameter.__uniformMatrix = new Float32Array (arrayLength * arrayLength);
						parameter.__isFloat = true;
						parameter.__isUniform = isUniform;
						parameter.__length = length;
						__paramFloat.push (parameter);
						
						if (StringTools.startsWith (name, "openfl_")) {
							
							switch (name) {
								
								case "openfl_Alpha": __alpha = parameter;
								case "openfl_ColorMultiplier": __colorMultiplier = parameter;
								case "openfl_ColorOffset": __colorOffset = parameter;
								case "openfl_Matrix": __matrix = parameter;
								case "openfl_Position": __position = parameter;
								case "openfl_TextureCoord": __textureCoord = parameter;
								case "openfl_TextureSize": __textureSize = parameter;
								default:
								
							}
							
						}
						
						Reflect.setField (__data, name, parameter);
						if (__isGenerated) Reflect.setField (this, name, parameter);
					
				}
				
			}
			
			position = regex.matchedPos ();
			lastMatch = position.pos + position.len;
			
		}
		
	}
	
	
	@:noCompletion private function __update ():Void {
		
		if (program != null) {
			
			__updateGL ();
			
		}
		
	}
	
	
	@:noCompletion private function __updateFromBuffer (shaderBuffer:ShaderBuffer):Void {
		
		if (program != null) {
			
			__updateGLFromBuffer (shaderBuffer);
			
		}
		
	}
	
	
	@:noCompletion private function __updateGL ():Void {
		
		var textureCount = 0;
		
		for (input in __inputBitmapData) {
			
			input.__updateGL (__context, textureCount);
			textureCount++;
			
		}
		
		for (parameter in __paramBool) {
			
			parameter.__updateGL (__context);
			
		}
		
		for (parameter in __paramFloat) {
			
			parameter.__updateGL (__context);
			
		}
		
		for (parameter in __paramInt) {
			
			parameter.__updateGL (__context);
			
		}
		
	}
	
	
	@:noCompletion private function __updateGLFromBuffer (shaderBuffer:ShaderBuffer):Void {
		
		var textureCount = 0;
		var input, inputData, inputFilter, inputMipFilter, inputWrap;
		
		for (i in 0...shaderBuffer.inputCount) {
			
			input = shaderBuffer.inputRefs[i];
			inputData = shaderBuffer.inputs[i];
			inputFilter = shaderBuffer.inputFilter[i];
			inputMipFilter = shaderBuffer.inputMipFilter[i];
			inputWrap = shaderBuffer.inputWrap[i];
			
			if (inputData != null) {
				
				input.__updateGL (__context, textureCount, inputData, inputFilter, inputMipFilter, inputWrap);
				textureCount++;
				
			}
			
		}
		
		var gl = __context.gl;
		
		if (shaderBuffer.paramDataLength > 0) {
			
			if (shaderBuffer.paramDataBuffer == null) {
				
				shaderBuffer.paramDataBuffer = gl.createBuffer ();
				
			}
			
			//Log.verbose ("bind param data buffer (length: " + shaderBuffer.paramData.length + ") (" + shaderBuffer.paramCount + ")");
			
			__context.__bindGLArrayBuffer (shaderBuffer.paramDataBuffer);
			gl.bufferData (gl.ARRAY_BUFFER, shaderBuffer.paramData, gl.DYNAMIC_DRAW);
			
		} else {
			
			//Log.verbose ("bind buffer null");
			
			__context.__bindGLArrayBuffer (null);
			
		}
		
		var boolIndex = 0;
		var floatIndex = 0;
		var intIndex = 0;
		
		var boolCount = shaderBuffer.paramBoolCount;
		var floatCount = shaderBuffer.paramFloatCount;
		var paramData = shaderBuffer.paramData;
		
		var boolRef, floatRef, intRef, hasOverride;
		var overrideBoolValue:Array<Bool> = null, overrideFloatValue:Array<Float> = null, overrideIntValue:Array<Int> = null;
		
		for (i in 0...shaderBuffer.paramCount) {
			
			hasOverride = false;
			
			if (i < boolCount) {
				
				boolRef = shaderBuffer.paramRefs_Bool[boolIndex];
				
				for (j in 0...shaderBuffer.overrideCount) {
					
					if (boolRef.name == shaderBuffer.overrideNames[j]) {
						
						overrideBoolValue = cast shaderBuffer.overrideValues[j];
						hasOverride = true;
						break;
						
					}
					
				}
				
				if (hasOverride) {
					
					boolRef.__updateGL (__context, overrideBoolValue);
					
				} else {
					
					boolRef.__updateGLFromBuffer (__context, paramData, shaderBuffer.paramPositions[i], shaderBuffer.paramLengths[i]);
					
				}
				
				boolIndex++;
				
			} else if (i < boolCount + floatCount) {
				
				floatRef = shaderBuffer.paramRefs_Float[floatIndex];
				
				for (j in 0...shaderBuffer.overrideCount) {
					
					if (floatRef.name == shaderBuffer.overrideNames[j]) {
						
						overrideFloatValue = cast shaderBuffer.overrideValues[j];
						hasOverride = true;
						break;
						
					}
					
				}
				
				if (hasOverride) {
					
					floatRef.__updateGL (__context, overrideFloatValue);
					
				} else {
					
					floatRef.__updateGLFromBuffer (__context, paramData, shaderBuffer.paramPositions[i], shaderBuffer.paramLengths[i]);
					
				}
				
				floatIndex++;
				
			} else {
				
				intRef = shaderBuffer.paramRefs_Int[intIndex];
				
				for (j in 0...shaderBuffer.overrideCount) {
					
					if (intRef.name == shaderBuffer.overrideNames[j]) {
						
						overrideIntValue = cast shaderBuffer.overrideValues[j];
						hasOverride = true;
						break;
						
					}
					
				}
				
				if (hasOverride) {
					
					intRef.__updateGL (__context, overrideIntValue);
					
				} else {
					
					intRef.__updateGLFromBuffer (__context, paramData, shaderBuffer.paramPositions[i], shaderBuffer.paramLengths[i]);
					
				}
				
				intIndex++;
				
			}
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_data ():ShaderData {
		
		if (__glSourceDirty || __data == null) {
			
			__init ();
			
		}
		
		return __data;
		
	}
	
	
	@:noCompletion private function set_data (value:ShaderData):ShaderData {
		
		return __data = cast value;
		
	}
	
	
	@:noCompletion private function get_glFragmentSource ():String {
		
		return __glFragmentSource;
		
	}
	
	
	@:noCompletion private function set_glFragmentSource (value:String):String {
		
		if (value != __glFragmentSource) {
			
			__glSourceDirty = true;
			
		}
		
		return __glFragmentSource = value;
		
	}
	
	
	@:noCompletion private function get_glVertexSource ():String {
		
		return __glVertexSource;
		
	}
	
	
	@:noCompletion private function set_glVertexSource (value:String):String {
		
		if (value != __glVertexSource) {
			
			__glSourceDirty = true;
			
		}
		
		return __glVertexSource = value;
		
	}
	
	
}


#else
typedef Shader = flash.display.Shader;
#end
