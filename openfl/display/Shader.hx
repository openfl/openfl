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
	
	private var __isUniform:Map<String, Bool>;
	private var __inputs:Array<ShaderInput>;
	private var __parameters:Array<ShaderParameter>;
	private var __uniformMatrix2:Float32Array;
	private var __uniformMatrix3:Float32Array;
	private var __uniformMatrix4:Float32Array;
	
	
	public function new (code:ByteArray = null) {
		
		// TODO: Consider a macro generic build
		
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
		
		for (parameter in __parameters) {
			
			gl.disableVertexAttribArray (parameter.index);
			
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
		
		for (input in __inputs) {
			
			gl.uniform1i (input.index, textureCount);
			textureCount++;
			
		}
		
		#if desktop
		if (textureCount > 0) {
			
			gl.enable (gl.TEXTURE_2D);
			
		}
		#end
		
		for (parameter in __parameters) {
			
			if (parameter.value == null) {
				
				gl.enableVertexAttribArray (parameter.index);
				
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
		
		if (__inputs == null) {
			
			__isUniform = new Map ();
			
			__inputs = new Array ();
			__parameters = new Array ();
			
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
				
				for (input in __inputs) {
					
					if (__isUniform.get (input.name)) {
						
						input.index = gl.getUniformLocation (glProgram, input.name);
						
					} else {
						
						input.index = gl.getAttribLocation (glProgram, input.name);
						
					}
					
				}
				
				for (parameter in __parameters) {
					
					if (__isUniform.get (parameter.name)) {
						
						parameter.index = gl.getUniformLocation (glProgram, parameter.name);
						
					} else {
						
						parameter.index = gl.getAttribLocation (glProgram, parameter.name);
						
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
				
				var input = new ShaderInput ();
				input.name = name;
				__inputs.push (input);
				Reflect.setField (data, name, input);
				
			} else {
				
				var parameter = new ShaderParameter ();
				
				parameter.type = switch (type) {
					
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
				
				parameter.name = name;
				__parameters.push (parameter);
				Reflect.setField (data, name, parameter);
				
			}
			
			__isUniform.set (name, storageType == "uniform");
			
			position = regex.matchedPos ();
			lastMatch = position.pos + position.len;
			
		}
		
	}
	
	
	private function __update ():Void {
		
		if (glProgram != null) {
			
			__updateGL ();
			
		}
		
	}
	
	
	private function __updateGL ():Void {
		
		var textureCount = 0;
		
		for (input in __inputs) {
			
			if (input.input != null) {
				
				gl.activeTexture (gl.TEXTURE0 + textureCount);
				gl.bindTexture (gl.TEXTURE_2D, input.__bitmapData.getTexture (gl));
				
			}
			
			textureCount++;
			
		}
		
		var index, boolValues:Array<Bool> = null, floatValues:Array<Float> = null, intValues:Array<Int> = null;
		
		for (parameter in __parameters) {
			
			if (parameter.value != null) {
				
				switch (parameter.type) {
					
					case BOOL, BOOL2, BOOL3, BOOL4:
						
						boolValues = cast parameter.value;
					
					case INT, INT2, INT3, INT4:
						
						intValues = cast parameter.value;
					
					default:
						
						floatValues = cast parameter.value;
					
				}
				
				index = parameter.index;
				
				switch (parameter.type) {
					
					case BOOL:
						
						gl.uniform1i (index, boolValues[0] ? 1 : 0);
					
					case BOOL2:
						
						gl.uniform2i (index, boolValues[0] ? 1 : 0, boolValues[1] ? 1 : 0);
					
					case BOOL3:
						
						gl.uniform3i (index, boolValues[0] ? 1 : 0, boolValues[1] ? 1 : 0, boolValues[2] ? 1 : 0);
					
					case BOOL4:
						
						gl.uniform4i (index, boolValues[0] ? 1 : 0, boolValues[1] ? 1 : 0, boolValues[2] ? 1 : 0, boolValues[3] ? 1 : 0);
					
					case FLOAT:
						
						gl.uniform1f (index, floatValues[0]);
					
					case FLOAT2:
						
						gl.uniform2f (index, floatValues[0], floatValues[1]);
					
					case FLOAT3:
						
						gl.uniform3f (index, floatValues[0], floatValues[1], floatValues[2]);
					
					case FLOAT4:
						
						gl.uniform4f (index, floatValues[0], floatValues[1], floatValues[2], floatValues[3]);
					
					case INT:
						
						gl.uniform1i (index, intValues[0]);
					
					case INT2:
						
						gl.uniform2i (index, intValues[0], intValues[1]);
					
					case INT3:
						
						gl.uniform3i (index, intValues[0], intValues[1], intValues[2]);
					
					case INT4:
						
						gl.uniform4i (index, intValues[0], intValues[1], intValues[2], intValues[3]);
					
					case MATRIX2X2:
						
						for (i in 0...4) {
							
							__uniformMatrix2[i] = floatValues[i];
							
						}
						
						gl.uniformMatrix2fv (index, false, __uniformMatrix2);
					
					//case MATRIX2X3:
					//case MATRIX2X4:
					//case MATRIX3X2:
					
					case MATRIX3X3:
						
						for (i in 0...9) {
							
							__uniformMatrix3[i] = floatValues[i];
							
						}
						
						gl.uniformMatrix3fv (index, false, __uniformMatrix3);
					
					//case MATRIX3X4:
					//case MATRIX4X2:
					//case MATRIX4X3:
					
					case MATRIX4X4:
						
						for (i in 0...16) {
							
							__uniformMatrix4[i] = floatValues[i];
							
						}
						
						gl.uniformMatrix4fv (index, false, __uniformMatrix4);
					
					default:
					
				}
				
			}
			
		}
		
	}
	
	
}