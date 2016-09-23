package openfl.display;


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;
import lime.utils.GLUtils;
import openfl.utils.ByteArray;

@:access(openfl.display.ShaderInput)
@:access(openfl.display.ShaderParameter)


class Shader {
	
	
	public var byteCode (null, default):ByteArray;
	public var data:ShaderData;
	public var glFragmentSource:String;
	public var glProgram:GLProgram;
	public var glVertexSource:String;
	public var precisionHint:ShaderPrecision;
	
	private var gl:GLRenderContext;
	
	private var __inputBitmapData:Array<ShaderInput<BitmapData>>;
	private var __paramBool:Array<ShaderParameter<Bool>>;
	private var __paramInt:Array<ShaderParameter<Int>>;
	private var __paramFloat:Array<ShaderParameter<Float>>;
	private var __uniformMatrix2:Float32Array;
	private var __uniformMatrix3:Float32Array;
	private var __uniformMatrix4:Float32Array;
	
	
	public function new (code:ByteArray = null) {
		
		byteCode = code;
		precisionHint = FULL;
		
		if (glVertexSource == null) {
			
			glVertexSource =
				
				"attribute float aAlpha;
				attribute vec4 aPosition;
				attribute vec2 aTexCoord;
				varying float vAlpha;
				varying vec2 vTexCoord;
				
				uniform mat4 uMatrix;
				
				void main(void) {
					
					vAlpha = aAlpha;
					vTexCoord = aTexCoord;
					gl_Position = uMatrix * aPosition;
					
				}";
			
		}
		
		if (glFragmentSource == null) {
			
			glFragmentSource = 
				
				"varying float vAlpha;
				varying vec2 vTexCoord;
				uniform sampler2D uImage0;
				
				void main(void) {
					
					vec4 color = texture2D (uImage0, vTexCoord);
					
					if (color.a == 0.0) {
						
						gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
						
					} else {
						
						gl_FragColor = vec4 (color.rgb / color.a, color.a * vAlpha);
						
					}
					
				}";
				
		}
		
		__init ();
		
	}
	
	
	private function __disable ():Void {
		
		if (glProgram != null) {
			
			__disableGL ();
			
		}
		
	}
	
	
	private function __disableGL ():Void {
		
		for (param in __paramBool) {
			
			switch (param.type) {
				
				case BOOL2, BOOL3, BOOL4:
					
					gl.disableVertexAttribArray (param.index);
				
				default:
				
			}
			
		}
		
		for (param in __paramFloat) {
			
			switch (param.type) {
				
				case FLOAT2, FLOAT3, FLOAT4:
					
					gl.disableVertexAttribArray (param.index);
				
				default:
				
			}
			
		}
		
		for (param in __paramInt) {
			
			switch (param.type) {
				
				case INT2, INT3, INT4:
					
					gl.disableVertexAttribArray (param.index);
				
				default:
				
			}
			
		}
		
		gl.bindBuffer (gl.ARRAY_BUFFER, null);
		gl.bindTexture (gl.TEXTURE_2D, null);
		
		#if desktop
		gl.disable (gl.TEXTURE_2D);
		#end
		
	}
	
	
	private function __enable ():Void {
		
		__init ();
		
		if (glProgram != null) {
			
			__enableGL ();
			
		}
		
	}
	
	
	private function __enableGL ():Void {
		
		var textureCount = 0;
		
		for (input in __inputBitmapData) {
			
			#if desktop
			if (textureCount == 0) {
				
				gl.enable (gl.TEXTURE_2D);
				
			}
			#end
			
			gl.uniform1i (input.index, textureCount);
			
			if (input.input != null) {
				
				gl.activeTexture (gl.TEXTURE0 + textureCount);
				gl.bindTexture (gl.TEXTURE_2D, input.input.getTexture (gl));
				
			}
			
			textureCount++;
			
		}
		
		var boolValue, floatValue, intValue;
		
		for (param in __paramBool) {
			
			boolValue = param.value;
			
			if (boolValue != null) {
				
				switch (param.type) {
					
					case BOOL:
						
						gl.uniform1i (param.index, boolValue[0] ? 1 : 0);
					
					case BOOL2:
						
						gl.uniform2i (param.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0);
					
					case BOOL3:
						
						gl.uniform3i (param.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0);
					
					case BOOL4:
						
						gl.uniform4i (param.index, boolValue[0] ? 1 : 0, boolValue[1] ? 1 : 0, boolValue[2] ? 1 : 0, boolValue[3] ? 1 : 0);
					
					default:
					
				}
				
			} else {
				
				switch (param.type) {
					
					case BOOL2, BOOL3, BOOL4:
						
						gl.enableVertexAttribArray (param.index);
					
					default:
					
				}
				
			}
			
		}
		
		for (param in __paramFloat) {
			
			floatValue = param.value;
			
			if (floatValue != null) {
				
				switch (param.type) {
					
					case FLOAT:
						
						gl.uniform1f (param.index, floatValue[0]);
					
					case FLOAT2:
						
						gl.uniform2f (param.index, floatValue[0], floatValue[1]);
					
					case FLOAT3:
						
						gl.uniform3f (param.index, floatValue[0], floatValue[1], floatValue[2]);
					
					case FLOAT4:
						
						gl.uniform4f (param.index, floatValue[0], floatValue[1], floatValue[2], floatValue[3]);
					
					case MATRIX2X2:
						
						for (i in 0...4) {
							
							__uniformMatrix2[i] = floatValue[i];
							
						}
						
						gl.uniformMatrix2fv (param.index, false, __uniformMatrix2);
					
					//case MATRIX2X3:
					//case MATRIX2X4:
					//case MATRIX3X2:
					
					case MATRIX3X3:
						
						for (i in 0...9) {
							
							__uniformMatrix3[i] = floatValue[i];
							
						}
						
						gl.uniformMatrix3fv (param.index, false, __uniformMatrix3);
					
					//case MATRIX3X4:
					//case MATRIX4X2:
					//case MATRIX4X3:
					
					case MATRIX4X4:
						
						for (i in 0...16) {
							
							__uniformMatrix4[i] = floatValue[i];
							
						}
						
						trace (__uniformMatrix4);
						
						gl.uniformMatrix4fv (param.index, false, __uniformMatrix4);
					
					default:
					
				}
				
			} else {
				
				switch (param.type) {
					
					case FLOAT2, FLOAT3, FLOAT4:
						
						gl.enableVertexAttribArray (param.index);
					
					default:
					
				}
				
			}
			
		}
		
		for (param in __paramInt) {
			
			intValue = param.value;
			
			if (intValue != null) {
				
				switch (param.type) {
					
					case INT:
						
						gl.uniform1i (param.index, intValue[0]);
					
					case INT2:
						
						gl.uniform2i (param.index, intValue[0], intValue[1]);
					
					case INT3:
						
						gl.uniform3i (param.index, intValue[0], intValue[1], intValue[2]);
					
					case INT4:
						
						gl.uniform4i (param.index, intValue[0], intValue[1], intValue[2], intValue[3]);
					
					default:
					
				}
				
			} else {
				
				switch (param.type) {
					
					case INT2, INT3, INT4:
						
						gl.enableVertexAttribArray (param.index);
					
					default:
					
				}
				
			}
			
		}
		
	}
	
	
	private function __init ():Void {
		
		if (data == null) {
			
			data = new ShaderData (null);
			
		}
		
		if (glFragmentSource != null && glVertexSource != null) {
			
			__initGL ();
			
		}
		
	}
	
	
	private function __initGL ():Void {
		
		if (__paramBool == null) {
			
			__inputBitmapData = new Array ();
			__paramBool = new Array ();
			__paramInt = new Array ();
			__paramFloat = new Array ();
			__uniformMatrix2 = new Float32Array (4);
			__uniformMatrix3 = new Float32Array (9);
			__uniformMatrix4 = new Float32Array (16);
			
			__processGLData (glVertexSource, "attribute");
			__processGLData (glVertexSource, "uniform");
			__processGLData (glFragmentSource, "uniform");
			
		}
		
		if (gl != null && glProgram == null && glFragmentSource != null && glVertexSource != null) {
			
			var fragment = 
				
				"#ifdef GL_ES
				precision " + (precisionHint == FULL ? "mediump" : "lowp") + " float;
				#endif
				" + glFragmentSource;
			
			glProgram = GLUtils.createProgram (glVertexSource, fragment);
			
			if (glProgram != null) {
				
				for (input in __inputBitmapData) {
					
					if (input.__isUniform) {
						
						input.index = gl.getUniformLocation (glProgram, input.__name);
						
					} else {
						
						input.index = gl.getAttribLocation (glProgram, input.__name);
						
					}
					
				}
				
				for (param in __paramBool) {
					
					if (param.__isUniform) {
						
						param.index = gl.getUniformLocation (glProgram, param.__name);
						
					} else {
						
						param.index = gl.getAttribLocation (glProgram, param.__name);
						
					}
					
				}
				
				for (param in __paramFloat) {
					
					if (param.__isUniform) {
						
						param.index = gl.getUniformLocation (glProgram, param.__name);
						
					} else {
						
						param.index = gl.getAttribLocation (glProgram, param.__name);
						
					}
					
				}
				
				for (param in __paramInt) {
					
					if (param.__isUniform) {
						
						param.index = gl.getUniformLocation (glProgram, param.__name);
						
					} else {
						
						param.index = gl.getAttribLocation (glProgram, param.__name);
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	private function __processGLData (source:String, storageType:String):Void {
		
		var lastMatch = 0, position, regex, name, type;
		
		if (storageType == "uniform") {
			
			regex = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
			
		} else {
			
			regex = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
			
		}
		
		while (regex.matchSub (source, lastMatch)) {
			
			type = regex.matched (1);
			name = regex.matched (2);
			
			if (StringTools.startsWith (type, "sampler")) {
				
				var input = new ShaderInput<BitmapData> ();
				input.__isUniform = (storageType == "uniform");
				input.__name = name;
				__inputBitmapData.push (input);
				Reflect.setField (data, name, input);
				
			} else {
				
				var paramType:ShaderParameterType = switch (type) {
					
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
				
				var isUniform = (storageType == "uniform");
				
				switch (paramType) {
					
					case BOOL, BOOL2, BOOL3, BOOL4:
						
						var param = new ShaderParameter<Bool> ();
						param.type = paramType;
						param.__isUniform = isUniform;
						param.__name = name;
						__paramBool.push (param);
						Reflect.setField (data, name, param);
					
					case INT, INT2, INT3, INT4:
						
						var param = new ShaderParameter<Int> ();
						param.type = paramType;
						param.__isUniform = isUniform;
						param.__name = name;
						__paramInt.push (param);
						Reflect.setField (data, name, param);
					
					default:
						
						var param = new ShaderParameter<Float> ();
						param.type = paramType;
						param.__isUniform = isUniform;
						param.__name = name;
						__paramFloat.push (param);
						Reflect.setField (data, name, param);
					
				}
				
			}
			
			position = regex.matchedPos ();
			lastMatch = position.pos + position.len;
			
		}
		
	}
	
	
}