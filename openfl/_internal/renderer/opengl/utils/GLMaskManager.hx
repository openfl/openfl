package openfl._internal.renderer.opengl.utils;

import haxe.ds.GenericStack;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractMaskManager;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.utils.UnshrinkableArray;


class GLMaskManager extends AbstractMaskManager {


	public var gl:GLRenderContext;

	private var clips:Array<Rectangle>;
	private var currentClip:Rectangle;
	private var savedClip:Rectangle;


	private var maskBitmapTable:UnshrinkableArray<BitmapData>;
	private var maskMatrixTable:UnshrinkableArray<Matrix>;
	private var maskCount:Int;


	public function new (renderSession:RenderSession) {

		super (renderSession);

		setContext (renderSession.gl);

		clips = [];
		maskBitmapTable = new UnshrinkableArray<BitmapData> (128);
		maskMatrixTable = new UnshrinkableArray<Matrix> (128);
		maskCount = 0;

	}


	public function destroy () {

		gl = null;

	}


	override public function pushRect(rect:Rectangle, transform:Matrix):Void {

		var m = transform.clone ();
		// correct coords from top-left (OpenFL) to bottom-left (GL)
		@:privateAccess GLBitmap.flipMatrix (m, renderSession.renderer.viewport.height);
		var clip = rect.clone ();
		clip.__transform (clip, m);

		if (currentClip != null /*&& currentClip.intersects(clip)*/) {

			clip = currentClip.intersection (clip);

		}

		var restartBatch = (currentClip == null || clip.isEmpty () || currentClip.containsRect (clip));

		clips.push (clip);
		currentClip = clip;

		if (restartBatch) {

			renderSession.spriteBatch.start (
				currentClip,
				maskBitmapTable.last(),
				maskMatrixTable.last()
			 );

		}

	}


	public override function pushMask (mask:DisplayObject) {

		if (!renderSession.usesMainSpriteBatch) {

			renderSession.spriteBatch.stop ();

		}

		var bitmap:BitmapData = null;
		var maskMatrix:Matrix = null;

		if (mask != null) {

			// :TODO: in case of inner mask, detect if any ancestor has been modified since the previous mask has been pushed
			// in the meantime, let's update inner masks every frame

			if( @:privateAccess mask.__cachedBitmap == null || @:privateAccess mask.__updateCachedBitmap || maskCount > 0) {

				@:privateAccess mask.__visible = true;
				@:privateAccess mask.__isMask = false;
				@:privateAccess DisplayObject.__isCachingAsMask = true;
				mask.__update (true, false);

				mask.__updateCachedBitmapFn (renderSession, maskBitmapTable.last (), maskMatrixTable.last ());

				@:privateAccess DisplayObject.__isCachingAsMask = false;
				@:privateAccess mask.__isMask = true;
				@:privateAccess mask.__visible = false;
				@:privateAccess mask.__renderable = false;
			}

			bitmap = @:privateAccess mask.__cachedBitmap;

		}

		if (bitmap != null)
		{
			var renderTargetBaseTransform = renderSession.getRenderTargetBaseTransform ();
			maskMatrix = Matrix.pool.get();
			bitmap.getLocalTransform(maskMatrix);
			maskMatrix.concat (@:privateAccess mask.__renderTransform);
			maskMatrix.concat (renderTargetBaseTransform);
			maskMatrix.invert ();
			maskMatrix.scale ( 1.0 / bitmap.physicalWidth, 1.0 / bitmap.physicalHeight );
			++maskCount;
		}

		maskBitmapTable.push(bitmap);
		maskMatrixTable.push(maskMatrix);

		renderSession.spriteBatch.start (currentClip, bitmap, maskMatrix);
	}


	public override function popMask () {

		var bitmap = maskBitmapTable.pop();

		if (bitmap != null) {
			--maskCount;
		}

		var maskMatrix = maskMatrixTable.pop();

		if (maskMatrix != null) {
			Matrix.pool.put (maskMatrix);
		}

		renderSession.spriteBatch.start (currentClip, maskBitmapTable.last(),  maskMatrixTable.last());
	}

	override public function popRect():Void {

		clips.pop ();
		currentClip = clips[clips.length - 1];

		renderSession.spriteBatch.start (currentClip, maskBitmapTable.last(),  maskMatrixTable.last());

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
