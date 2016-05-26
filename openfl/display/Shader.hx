package openfl.display;


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLProgram;
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
	
	
	public function new (code:ByteArray = null) {
		
		byteCode = code;
		precisionHint = FULL;
		
		glVertexSource =
			
			"attribute vec4 aPosition;
			attribute vec2 aTexCoord;
			varying vec2 vTexCoord;
			
			uniform mat4 uMatrix;
			
			void main(void) {
				
				vTexCoord = aTexCoord;
				gl_Position = uMatrix * aPosition;
				
			}";
		
		glFragmentSource = 
			
			"varying vec2 vTexCoord;
			uniform sampler2D uImage0;
			uniform float uAlpha;
			
			void main(void) {
				
				vec4 color = texture2D (uImage0, vTexCoord);
				
				if (color.a == 0.0) {
					
					gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
					
				} else {
					
					gl_FragColor = vec4 (color.rgb / color.a, color.a * uAlpha);
					
				}
				
			}";
		
		__init ();
		
	}
	
	
	private function __disable ():Void {
		
		if (glProgram != null) {
			
			var value, parameter:ShaderParameter;
			
			for (field in Reflect.fields (data)) {
				
				value = Reflect.field (data, field);
				
				if (Std.is (value, ShaderParameter)) {
					
					parameter = cast value;
					
					switch (parameter.type) {
						
						case BOOL2, BOOL3, BOOL4, INT2, INT3, INT4, FLOAT2, FLOAT3, FLOAT4:
							
							gl.disableVertexAttribArray (parameter.index);
						
						default:
						
					}
					
				}
				
			}
			
			gl.bindBuffer (gl.ARRAY_BUFFER, null);
			gl.bindTexture (gl.TEXTURE_2D, null);
			
			#if desktop
			gl.disable (gl.TEXTURE_2D);
			#end
			
		}
		
	}
	
	
	private function __enable ():Void {
		
		__init ();
		
		if (glProgram != null) {
			
			var parameter:ShaderParameter, value;
			var textureCount = 0;
			
			for (field in Reflect.fields (data)) {
				
				value = Reflect.field (data, field);
				
				if (Std.is (value, ShaderInput)) {
					
					gl.uniform1i (value.index, textureCount);
					textureCount++;
					
				} else {
					
					parameter = cast value;
					
					switch (parameter.type) {
						
						case BOOL2, BOOL3, BOOL4, INT2, INT3, INT4, FLOAT2, FLOAT3, FLOAT4:
							
							gl.enableVertexAttribArray (parameter.index);
						
						default:
						
					}
					
				}
				
			}
			
			if (textureCount > 0) {
				
				gl.activeTexture (gl.TEXTURE0);
				
				#if desktop
				gl.enable (gl.TEXTURE_2D);
				#end
				
			}
			
		}
		
	}
	
	
	private function __init ():Void {
		
		if (data == null) {
			
			data = new ShaderData (null);
			
		}
		
		if (gl != null && glProgram == null && glFragmentSource != null && glVertexSource != null) {
			
			var fragment = 
				
				"#ifdef GL_ES
				precision " + (precisionHint == FULL ? "mediump" : "lowp") + " float;
				#endif
				" + glFragmentSource;
			
			glProgram = GLUtils.createProgram (glVertexSource, fragment);
			
			if (glProgram != null) {
				
				__processGLData (glVertexSource, "attribute");
				__processGLData (glVertexSource, "uniform");
				__processGLData (glFragmentSource, "uniform");
				
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
				
				if (storageType == "uniform") {
					
					input.index = gl.getUniformLocation (glProgram, name);
					
				} else {
					
					input.index = gl.getAttribLocation (glProgram, name);
					
				}
				
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
				
				if (storageType == "uniform") {
					
					parameter.index = gl.getUniformLocation (glProgram, name);
					
				} else {
					
					parameter.index = gl.getAttribLocation (glProgram, name);
					
				}
				
				Reflect.setField (data, name, parameter);
				
			}
			
			position = regex.matchedPos ();
			lastMatch = position.pos + position.len;
			
		}
		
	}
	
	
}