package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractShaderManager;
import openfl.display.Shader;

@:access(openfl.display.Shader)


class GLShaderManager extends AbstractShaderManager {
	
	
	private var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		super ();
		
		this.gl = gl;
		
		defaultShader = new Shader ();
		defaultShader.gl = gl;
		defaultShader.__init ();
		
	}
	
	
	public override function setShader (shader:Shader):Void {
		
		if (currentShader == shader) {
			
			if (currentShader != null) currentShader.__update ();
			return;
			
		}
		
		if (currentShader != null) {
			
			currentShader.__disable ();
			
		}
		
		if (shader == null) {
			
			currentShader = null;
			gl.useProgram (null);
			return;
			
		}
		
		currentShader = shader;
		
		if (currentShader.gl == null) {
			
			currentShader.gl = gl;
			currentShader.__init ();
			
		}
		
		gl.useProgram (shader.glProgram);
		currentShader.__enable ();
		currentShader.__update ();
		
	}
	
	
}