package openfl._internal.renderer.opengl.shaders;


import lime.graphics.GLRenderContext;
import openfl.display.Shader;
import openfl.display.ShaderParameter;
import openfl.display.ShaderParameterType;


class GLBitmapShader extends Shader {
	
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		
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
		
		super ();
		
	}
	
	
	private override function __disable ():Void {
		
		gl.disableVertexAttribArray (data.aPosition.index);
		gl.disableVertexAttribArray (data.aTexCoord.index);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, null);
		gl.bindTexture (gl.TEXTURE_2D, null);
		
		#if desktop
		gl.disable (gl.TEXTURE_2D);
		#end
		
	}
	
	
	private override function __enable ():Void {
		
		gl.enableVertexAttribArray (data.aPosition.index);
		gl.enableVertexAttribArray (data.aTexCoord.index);
		gl.uniform1i (data.uImage0.index, 0);
		
		gl.activeTexture (gl.TEXTURE0);
		
		#if desktop
		gl.enable (gl.TEXTURE_2D);
		#end
		
	}
	
	
	private override function __init () {
		
		super.__init ();
		
		data.aPosition = new ShaderParameter ();
		data.aTexCoord = new ShaderParameter ();
		data.uMatrix = new ShaderParameter ();
		data.uImage0 = new ShaderParameter ();
		data.uAlpha = new ShaderParameter ();
		
		data.aPosition.index = gl.getAttribLocation (glProgram, "aPosition");
		data.aPosition.type = ShaderParameterType.FLOAT4;
		data.aTexCoord.index = gl.getAttribLocation (glProgram, "aTexCoord");
		data.aTexCoord.type = ShaderParameterType.FLOAT2;
		data.uMatrix.index = gl.getUniformLocation (glProgram, "uMatrix");
		data.uMatrix.type = ShaderParameterType.MATRIX4X4;
		data.uImage0.index = gl.getUniformLocation (glProgram, "uImage0");
		data.uImage0.type = null;
		data.uAlpha.index = gl.getUniformLocation (glProgram, "uAlpha");
		data.uAlpha.type = ShaderParameterType.FLOAT;
		
	}
	
	
}