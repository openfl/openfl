package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLRenderContext;
import openfl.display.BlendMode;


class BlendModeManager {
	
	
	public var currentBlendMode:BlendMode;
	public var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		currentBlendMode = null;
		
	}
	
	
	public function destroy ():Void {
		
		gl = null;
		
	}
	
	
	public function setBlendMode (blendMode:BlendMode):Bool {
		
		if (blendMode == null) blendMode = BlendMode.NORMAL;
		if (currentBlendMode == blendMode) {
			
			return false;
			
		}
		
		currentBlendMode = blendMode;
		
		var blendModeWebGL = GLRenderer.blendModesWebGL[currentBlendMode];
		gl.blendFunc (blendModeWebGL[0], blendModeWebGL[1]);
		
		return true;
		
	}
	
	
}