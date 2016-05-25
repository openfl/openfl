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
	
	
}