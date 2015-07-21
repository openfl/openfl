package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractMaskManager;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;


class GLMaskManager extends AbstractMaskManager {
	
	
	public var gl:GLRenderContext;
	
	
	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
		setContext (renderSession.gl);
		
	}
	
	
	public function destroy () {
		
		gl = null;
		
	}
	
	
	public override function pushMask (mask:DisplayObject) {
		
		renderSession.stencilManager.pushMask (mask, renderSession);
		
	}
	
	
	public override function popMask () {
		
		renderSession.stencilManager.popMask (null, renderSession);
		
	}
	
	
	public function setContext (gl:GLRenderContext) {
		
		if (renderSession != null) {
			
			renderSession.gl = gl;
			
		}
		
		this.gl = gl;
		
	}
	
	
}

/*
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
	
	
	public function popMask (maskData:Dynamic, renderSession:RenderSession):Void {
		
		var gl = this.gl;
		renderSession.stencilManager.popStencil (maskData, maskData._webGL[GLRenderer.glContextId].data[0], renderSession);
		
	}
	
	
	public function pushMask (maskData:Dynamic, renderSession:RenderSession):Void {
		
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
*/

/*class MaskManager {
	
	
	private var renderSession:RenderSession;
	
	
	public function new (renderSession:RenderSession) {
		
		this.renderSession = renderSession;
		
	}
	
	
	public function pushMask (mask:IBitmapDrawable):Void {
		
		var context = renderSession.context;
		
		context.save ();
		
		//var cacheAlpha = mask.__worldAlpha;
		var transform = mask.__worldTransform;
		if (transform == null) transform = new Matrix ();
		
		context.setTransform (transform.a, transform.c, transform.b, transform.d, transform.tx, transform.ty);
		
		context.beginPath ();
		mask.__renderMask (renderSession);
		
		context.clip ();
		
		//mask.worldAlpha = cacheAlpha;
		
	}
	
	
	public function pushRect (rect:Rectangle, transform:Matrix):Void {
		
		var context = renderSession.context;
		context.save ();
		
		context.setTransform (transform.a, transform.c, transform.b, transform.d, transform.tx, transform.ty);
		
		context.beginPath ();
		context.rect (rect.x, rect.y, rect.width, rect.height);
		context.clip ();
		
	}
	
	
	public function popMask ():Void {
		
		renderSession.context.restore ();
		
	}
	
	
}*/