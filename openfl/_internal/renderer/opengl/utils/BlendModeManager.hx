package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLRenderContext;


class BlendModeManager {
	
	
	public var currentBlendMode:Int;
	public var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		currentBlendMode = 99999;
		
	}
	
	
	public function destroy ():Void {
		
		gl = null;
		
	}
	
	
	public function setBlendMode (blendMode:Null<Int>):Bool {
		
		if (blendMode == null) blendMode = 0;
		if (this.currentBlendMode == blendMode) {
			
			return false;
			
		}
		
		currentBlendMode = blendMode;
		
		var blendModeWebGL = GLRenderer.blendModesWebGL[currentBlendMode];
		gl.blendFunc (blendModeWebGL[0], blendModeWebGL[1]);
		
		return true;
		
	}
	
	
}