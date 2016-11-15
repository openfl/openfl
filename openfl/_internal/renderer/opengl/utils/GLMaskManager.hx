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

		var maskBounds = Rectangle.pool.get();
		maskBounds.setEmpty();
		@:privateAccess mask.__getRenderBounds (maskBounds);


		if( @:privateAccess mask.__cachedBitmap == null ){
			var bitmap = @:privateAccess BitmapData.__asRenderTexture ();
			@:privateAccess bitmap.__resize (Math.ceil (maskBounds.width), Math.ceil (maskBounds.height));

			var m = Matrix.pool.get();
			m.copyFrom(mask.__renderScaleTransform);
			m.translate(-maskBounds.x, -maskBounds.y);

			mask.visible = true;
			@:privateAccess mask.__isMask = false;

			@:privateAccess bitmap.__drawGL(renderSession, mask, m, true, false, true);
			Matrix.pool.put(m);
			@:privateAccess mask.__cachedBitmap = bitmap;

			mask.visible = false;
			@:privateAccess mask.__isMask = true;
			@:privateAccess mask.__renderable = false;
		}

		var bitmap = @:privateAccess mask.__cachedBitmap;

		var maskMatrix = mask.__renderTransform.clone();

		maskMatrix.invert();
		maskMatrix.translate( -maskBounds.x, -maskBounds.y );
		Rectangle.pool.put(maskBounds);
		maskMatrix.scale( 1.0 / bitmap.width, 1.0 / bitmap.height );

		maskBitmapTable.add (bitmap);
		maskMatrixTable.add (maskMatrix);
		renderSession.spriteBatch.start (currentClip, bitmap, maskMatrix);

	}
	
	
	public override function popMask () {
		
		renderSession.spriteBatch.stop ();
		maskBitmapTable.pop();
		maskMatrixTable.pop();

		renderSession.spriteBatch.start (currentClip, maskBitmapTable.first (),  maskMatrixTable.first ());
	}
	
	public override function disableMask(){

		renderSession.spriteBatch.stop();
		maskBitmapTable.add(null);
		maskMatrixTable.add(null);

	}

	public override function enableMask(){
		renderSession.spriteBatch.stop();
		maskBitmapTable.pop();
		maskMatrixTable.pop();
		renderSession.spriteBatch.start( currentClip, maskBitmapTable.first(), maskMatrixTable.first());
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
