package openfl.display;


import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.GLUtils;
import openfl.utils.ByteArray;

@:access(openfl.display.ShaderParameter)


class Shader {
	
	
	public var byteCode (null, default):ByteArray;
	public var data:ShaderData;
	public var glFragmentSource:String;
	public var glProgram:GLProgram;
	public var glVertexSource:String;
	public var precisionHint:ShaderPrecision;
	
	private var gl:GLRenderContext;
	private var glAttributes:Map<String, ShaderParameter>;
	private var glUniforms:Map<String, ShaderParameter>;
	
	
	public function new (code:ByteArray = null) {
		
		byteCode = code;
		precisionHint = FULL;
		
		__init ();
		
	}
	
	
	private function __disable ():Void {
		
		
		
	}
	
	
	private function __enable ():Void {
		
		__init ();
		
	}
	
	
	private function __getGLParameterType (type:String):ShaderParameterType {
		
		return switch (type) {
			
			case "vec2": FLOAT2;
			case "vec3": FLOAT3;
			case "vec4": FLOAT4;
			case "mat2": MATRIX2X2;
			case "mat3": MATRIX3X3;
			case "mat4": MATRIX4X4;
			default: null;
			
		}
		
	}
	
	
	private function __init ():Void {
		
		if (gl != null && glProgram == null) {
			
			var fragment = 
				
				"#ifdef GLES
				precision " + (precisionHint == FULL ? "mediump" : "lowp") + " float
				#endif
				" + glFragmentSource;
			
			glProgram = GLUtils.createProgram (glVertexSource, fragment);
			
		}
		
		if (data == null) {
			
			data = new ShaderData (null);
			
			if (glProgram != null) {
				
				glAttributes = new Map ();
				glUniforms = new Map ();
				
				var lastMatch = 0;
				var parameter, matchedPos;
				var attribute = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
				
				while (attribute.matchSub (glVertexSource, lastMatch)) {
					
					if (!glAttributes.exists (attribute.matched (2))) {
						
						parameter = new ShaderParameter ();
						parameter.type = __getGLParameterType (attribute.matched (1));
						Reflect.setField (data, attribute.matched (2), parameter);
						glAttributes.set (attribute.matched (2), parameter);
						
					}
					
					matchedPos = attribute.matchedPos ();
					lastMatch = matchedPos.pos + matchedPos.len;
					
				}
				
				lastMatch = 0;
				var uniform = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
				
				while (uniform.matchSub (glFragmentSource, lastMatch)) {
					
					if (!glUniforms.exists (uniform.matched (2))) {
						
						parameter = new ShaderParameter ();
						parameter.type = __getGLParameterType (uniform.matched (1));
						Reflect.setField (data, uniform.matched (2), parameter);
						glUniforms.set (uniform.matched (2), parameter);
						
					}
					
					matchedPos = uniform.matchedPos ();
					lastMatch = matchedPos.pos + matchedPos.len;
					
				}
				
				lastMatch = 0;
				
				while (uniform.matchSub (glVertexSource, lastMatch)) {
					
					if (!glUniforms.exists (uniform.matched (2))) {
						
						parameter = new ShaderParameter ();
						parameter.type = __getGLParameterType (uniform.matched (1));
						Reflect.setField (data, uniform.matched (2), parameter);
						glUniforms.set (uniform.matched (2), parameter);
						
					}
					
					matchedPos = uniform.matchedPos ();
					lastMatch = matchedPos.pos + matchedPos.len;
					
				}
				
				for (key in glAttributes.keys ()) {
					
					glAttributes.get (key).index = gl.getAttribLocation (glProgram, key);
					
				}
				
				for (key in glUniforms.keys ()) {
					
					glUniforms.get (key).index = gl.getUniformLocation (glProgram, key);
					
				}
				
			}
			
		}
		
	}
	
	
}