package openfl._internal.renderer.opengl;


import lime.graphics.opengl.GLProgram;
import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractShader;
import openfl._internal.renderer.opengl.GLShader;
import openfl._internal.renderer.AbstractShaderManager;
import openfl._internal.renderer.opengl.shaders.GLBitmapShader;


class GLShaderManager extends AbstractShaderManager {
	
	
	private static var compiledShadersCache:Map<String, GLProgram> = new Map ();
	
	private var currentShader:GLShader;
	private var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		super ();
		
		this.gl = gl;
		
		defaultShader = new GLBitmapShader (gl);
		
	}
	
	
	public override function setShader (shader:AbstractShader):Void {
		
		if (currentShader == shader) return;
		
		if (currentShader != null) {
			
			currentShader.disable ();
			
		}
		
		if (shader == null) {
			
			currentShader = null;
			gl.useProgram (null);
			return;
			
		}
		
		var glShader:GLShader = cast shader;
		currentShader = glShader;
		
		gl.useProgram (glShader.program);
		currentShader.enable ();
		
	}
	
	
}