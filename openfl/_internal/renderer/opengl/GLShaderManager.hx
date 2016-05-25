package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractShaderManager;
import openfl._internal.renderer.opengl.shaders.GLBitmapShader;
import openfl.display.Shader;

@:access(openfl.display.Shader)


class GLShaderManager extends AbstractShaderManager {
	
	
	private var currentShader:Shader;
	private var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		super ();
		
		this.gl = gl;
		
		defaultShader = new GLBitmapShader (gl);
		
	}
	
	
	public override function setShader (shader:Shader):Void {
		
		if (currentShader == shader) return;
		
		if (currentShader != null) {
			
			currentShader.__disable ();
			
		}
		
		if (shader == null) {
			
			currentShader = null;
			gl.useProgram (null);
			return;
			
		}
		
		currentShader = shader;
		
		gl.useProgram (shader.glProgram);
		currentShader.__enable ();
		
	}
	
	
}