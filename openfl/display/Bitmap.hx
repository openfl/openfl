package openfl.display; #if !openfl_legacy


import openfl._internal.renderer.canvas.CanvasBitmap;
import openfl._internal.renderer.opengl.GLBitmap;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.UnshrinkableArray;

#if (js && html5)
import js.html.ImageElement;
#end


@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Rectangle)


class Bitmap extends DisplayObject {


	public var bitmapData:BitmapData;
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;

	#if (js && html5)
	private var __image:ImageElement;
	#end


	public function new (bitmapData:BitmapData = null, pixelSnapping:PixelSnapping = null, smoothing:Bool = false) {

		super ();

		this.bitmapData = bitmapData;
		this.pixelSnapping = pixelSnapping;
		this.smoothing = smoothing;
		this.__useSeparateRenderScaleTransform = false;

		if (pixelSnapping == null) {

			this.pixelSnapping = PixelSnapping.AUTO;

		}

	}


	private override function __getBounds (rect:Rectangle):Void {

		if (bitmapData != null) {

			rect.setTo (0, 0, bitmapData.width, bitmapData.height);

		}

	}


	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:UnshrinkableArray<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {

		if (!__mustEvaluateHitTest || !hitObject.visible || __isMask || bitmapData == null) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;

		__getWorldTransform ();

		var px = __worldTransform.__transformInverseX (x, y);
		var py = __worldTransform.__transformInverseY (x, y);

		if (px > 0 && py > 0 && px <= bitmapData.width && py <= bitmapData.height) {

			if (stack != null && !interactiveOnly) {

				stack.push (hitObject);

			}

			return true;

		}

		return false;

	}


	private override function __hitTestMask (x:Float, y:Float):Bool {

		if (bitmapData == null) return false;

		__getWorldTransform ();

		var px = __worldTransform.__transformInverseX (x, y);
		var py = __worldTransform.__transformInverseY (x, y);

		if (px > 0 && py > 0 && px <= bitmapData.width && py <= bitmapData.height) {

			return true;

		}

		return false;

	}


	public override function __renderCanvas (renderSession:RenderSession):Void {

		CanvasBitmap.render (this, renderSession);

	}


	public override function __renderCanvasMask (renderSession:RenderSession):Void {

		renderSession.context.rect (0, 0, width, height);

	}


	public override function __renderGL (renderSession:RenderSession):Void {

		if (__cacheAsBitmap) {
			__isCachingAsBitmap = true;
			__cacheGL(renderSession);
			__isCachingAsBitmap = false;
			return;
		}
		__preRenderGL (renderSession);
		GLBitmap.render (this, renderSession);
		__postRenderGL (renderSession);

	}

	// :TODO:
	/*
	public override function __updateMask (maskGraphics:Graphics):Void {

		maskGraphics.__commands.overrideMatrix (this.__worldTransform);
		maskGraphics.beginFill (0);
		maskGraphics.drawRect (0, 0, bitmapData.width, bitmapData.height);

		if (maskGraphics.__bounds == null) {

			maskGraphics.__bounds = new Rectangle ();

		}

		__getBounds (maskGraphics.__bounds);

		super.__updateMask (maskGraphics);

	}*/



	// Get & Set Methods




	private override function get_height ():Float {

		if (bitmapData != null) {

			return bitmapData.height * scaleY;

		}

		return 0;

	}


	private override function set_height (value:Float):Float {

		if (bitmapData != null) {

			if (value != bitmapData.height) {

				scaleY = value / bitmapData.height;

			}

			return value;

		}

		return 0;

	}


	private override function get_width ():Float {

		if (bitmapData != null) {

			return bitmapData.width * scaleX;

		}

		return 0;

	}


	private override function set_width (value:Float):Float {

		if (bitmapData != null) {

			if (value != bitmapData.width) {

				scaleX = value / bitmapData.width;

			}

			return value;

		}

		return 0;

	}


}


#else
typedef Bitmap = openfl._legacy.display.Bitmap;
#end
