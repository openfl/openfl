package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLRenderContext;


class MaskManager {
	
	
	public var count:Int;
	public var gl:GLRenderContext;
	public var maskPosition:Int;
	public var maskStack:Array<Dynamic>;
	public var reverse:Bool;
	
	
	public function new (gl:GLRenderContext) {
		
		maskStack = [];
		maskPosition = 0;
		
		setContext (gl);
		
		reverse = false;
		count = 0;
		
	}
	
	
	public function destroy ():Void {
		
		maskStack = null;
		gl = null;
		
	}
	
	
	public function popMask (maskData:Dynamic, renderSession:Dynamic):Void {
		
		var gl = this.gl;
		renderSession.stencilManager.popStencil (maskData, maskData._webGL[GLRenderer.glContextId].data[0], renderSession);
		
	}
	
	
	public function pushMask (maskData:Dynamic, renderSession:Dynamic):Void {
		
		var gl = renderSession.gl;
		
		if (maskData.dirty) {
			
			GraphicsRenderer.updateGraphics (maskData, gl);
			
		}
		
		if (maskData._webGL[GLRenderer.glContextId].data.length == 0) return;
		renderSession.stencilManager.pushStencil (maskData, maskData._webGL[GLRenderer.glContextId].data[0], renderSession);
		
	}
	
	
	public function setContext (gl:GLRenderContext):Void {
		
		this.gl = gl;
		
	}
	
	
}