package openfl._internal.renderer.opengl.utils;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.*;
import openfl.gl.GLProgram;

class ShaderManager {

	//TODO change this
	private static var compiledShadersCache:Map<String, GLProgram> = new Map();
	
	public var gl:GLRenderContext;
	public var currentShader:Shader;
	
	public var defaultShader:DefaultShader;
	
	public function new(gl:GLRenderContext) {
		setContext(gl);
	}
	
	public function setContext(gl:GLRenderContext) {
		this.gl = gl;
		
		defaultShader = new DefaultShader(gl);
		
		setShader(defaultShader, true);
		
	}
	
	public function destroy ():Void {
		
		defaultShader.destroy();
		
		gl = null;
		
	}
	
	public function setShader(shader:Shader, ?force:Bool = false) {
		if (shader == null) {
			// Assume we want to force, if we get called with null.
			currentShader = null;
			gl.useProgram(null);
			return true;
		}

		if (currentShader != null && !force && currentShader.ID == shader.ID) {
			return false;
		}
		currentShader = shader;
		
		gl.useProgram(shader.program);
		return true;
	}
	
}
