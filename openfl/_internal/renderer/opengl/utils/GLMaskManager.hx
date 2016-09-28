package openfl._internal.renderer.opengl.utils;

import haxe.ds.GenericStack;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractMaskManager;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;


class GLMaskManager extends AbstractMaskManager {
	
	
	public var gl:GLRenderContext;
	
	private var clips:Array<Rectangle>;
	private var currentClip:Rectangle;
	private var savedClip:Rectangle;


	private var maskBitmapTable:GenericStack<BitmapData>;
	private var maskMatrixTable:GenericStack<Matrix>;


	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
		setContext (renderSession.gl);
		
		clips = [];
		maskBitmapTable = new GenericStack<BitmapData> ();
		maskMatrixTable = new GenericStack<Matrix> ();

	}
	
	
	public function destroy () {
		
		gl = null;
		
	}
	
	
	override public function pushRect(rect:Rectangle, transform:Matrix):Void {
		
		if (rect == null) return;
		
		var m = transform.clone ();
		// correct coords from top-left (OpenFL) to bottom-left (GL)
		@:privateAccess GLBitmap.flipMatrix (m, renderSession.renderer.viewport.height);
		var clip = rect.clone ();
		@:privateAccess clip.__transform (clip, m);
		
		if (currentClip != null /*&& currentClip.intersects(clip)*/) {
			
			clip = currentClip.intersection (clip);
			
		}
		
		var restartBatch = (currentClip == null || clip.isEmpty () || currentClip.containsRect (clip));
		
		clips.push (clip);
		currentClip = clip;
		
		if (restartBatch) {
			
			renderSession.spriteBatch.stop ();
			renderSession.spriteBatch.start (
				currentClip,
				maskBitmapTable.first(),
				maskMatrixTable.first()
			 );

		}
		
	}
	
	
	public override function pushMask (mask:DisplayObject) {
		
		renderSession.spriteBatch.stop ();

		#if mask_as_bitmap

			var maskBounds = mask.getBounds (null);

			var bitmap = @:privateAccess BitmapData.__asRenderTexture ();
			@:privateAccess bitmap.__resize (Math.ceil (maskBounds.width), Math.ceil (maskBounds.height));

			var m = mask.__renderScaleTransform.clone();
			m.translate(-maskBounds.x, -maskBounds.y);

			mask.visible = true;
			@:privateAccess mask.__isMask = false;

			@:privateAccess bitmap.__drawGL(renderSession, mask, m, true, false, true);
			bitmap.draw(mask);

			var maskMatrix = mask.__worldTransform.clone();
			maskMatrix.invert();
			maskMatrix.scale( 1.0 / bitmap.width, 1.0 / bitmap.height );

			maskBitmapTable.add (bitmap);
			maskMatrixTable.add (maskMatrix);
			renderSession.spriteBatch.start (currentClip, bitmap, maskMatrix);

			mask.visible = false;
			@:privateAccess mask.__isMask = true;
		#else
			renderSession.stencilManager.pushMask (mask, renderSession);
			renderSession.spriteBatch.start (currentClip);
		#end


	}
	
	
	public override function popMask () {
		
		renderSession.spriteBatch.stop ();
		#if mask_as_bitmap
			var bitmap = maskBitmapTable.pop();
			maskMatrixTable.pop();

			bitmap.dispose();

			renderSession.spriteBatch.start (currentClip, maskBitmapTable.first (),  maskMatrixTable.first ());
		#else
			renderSession.stencilManager.popMask (null, renderSession);
			renderSession.spriteBatch.start (currentClip);
		#end

	}
	
	override public function popRect():Void {
		
		renderSession.spriteBatch.stop ();
		
		clips.pop ();
		currentClip = clips[clips.length - 1];

		renderSession.spriteBatch.start (currentClip, maskBitmapTable.first (),  maskMatrixTable.first ());

	}
	
	override public function saveState():Void {
		
		savedClip = currentClip;
		currentClip = null;
		
	}
	
	override public function restoreState():Void {
		
		currentClip = savedClip;
		savedClip = null;
		
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
