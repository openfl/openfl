package openfl.display;

#if !flash
import openfl.display._internal.CairoBitmap;
import openfl.display._internal.CairoDisplayObject;
import openfl.display._internal.CanvasBitmap;
import openfl.display._internal.CanvasDisplayObject;
import openfl.display._internal.Context3DBitmap;
import openfl.display._internal.Context3DDisplayObject;
import openfl.display._internal.DOMBitmap;
import openfl.display._internal.DOMDisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
#if (js && html5)
import js.html.ImageElement;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
class Bitmap extends DisplayObject
{
	public var bitmapData(get, set):BitmapData;
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;

	#if (js && html5)
	@:noCompletion private var __image:ImageElement;
	#end
	@:noCompletion private var __bitmapData:BitmapData;
	@:noCompletion private var __imageVersion:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(Bitmap.prototype, "bitmapData", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_bitmapData (); }"),
			set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_bitmapData (v); }")
		});
	}
	#end

	public function new(bitmapData:BitmapData = null, pixelSnapping:PixelSnapping = null, smoothing:Bool = false)
	{
		super();

		__bitmapData = bitmapData;
		this.pixelSnapping = pixelSnapping;
		this.smoothing = smoothing;

		if (pixelSnapping == null)
		{
			this.pixelSnapping = PixelSnapping.AUTO;
		}
	}

	@:noCompletion private override function __enterFrame(deltaTime:Int):Void
	{
		if (__bitmapData != null && __bitmapData.image != null && __bitmapData.image.version != __imageVersion)
		{
			__setRenderDirty();
		}
	}

	@:noCompletion private override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		var bounds = Rectangle.__pool.get();
		if (__bitmapData != null)
		{
			bounds.setTo(0, 0, __bitmapData.width, __bitmapData.height);
		}
		else
		{
			bounds.setTo(0, 0, 0, 0);
		}

		bounds.__transform(bounds, matrix);
		rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		Rectangle.__pool.release(bounds);
	}

	@:noCompletion private override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool,
			hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask || __bitmapData == null) return false;
		if (mask != null && !mask.__hitTestMask(x, y)) return false;

		__getRenderTransform();

		var px = __renderTransform.__transformInverseX(x, y);
		var py = __renderTransform.__transformInverseY(x, y);

		if (px > 0 && py > 0 && px <= __bitmapData.width && py <= __bitmapData.height)
		{
			if (__scrollRect != null && !__scrollRect.contains(px, py))
			{
				return false;
			}

			if (stack != null && !interactiveOnly)
			{
				stack.push(hitObject);
			}

			return true;
		}

		return false;
	}

	@:noCompletion private override function __hitTestMask(x:Float, y:Float):Bool
	{
		if (__bitmapData == null) return false;

		__getRenderTransform();

		var px = __renderTransform.__transformInverseX(x, y);
		var py = __renderTransform.__transformInverseY(x, y);

		if (px > 0 && py > 0 && px <= __bitmapData.width && py <= __bitmapData.height)
		{
			return true;
		}

		return false;
	}

	@:noCompletion private override function __renderCairo(renderer:CairoRenderer):Void
	{
		#if lime_cairo
		__updateCacheBitmap(renderer, /*!__worldColorTransform.__isDefault ()*/ false);

		if (__bitmapData != null && __bitmapData.image != null)
		{
			__imageVersion = __bitmapData.image.version;
		}

		if (__cacheBitmap != null && !__isCacheBitmapRender)
		{
			CairoBitmap.render(__cacheBitmap, renderer);
		}
		else
		{
			CairoDisplayObject.render(this, renderer);
			CairoBitmap.render(this, renderer);
		}

		__renderEvent(renderer);
		#end
	}

	@:noCompletion private override function __renderCairoMask(renderer:CairoRenderer):Void
	{
		renderer.cairo.rectangle(0, 0, width, height);
	}

	@:noCompletion private override function __renderCanvas(renderer:CanvasRenderer):Void
	{
		__updateCacheBitmap(renderer, /*!__worldColorTransform.__isDefault ()*/ false);

		if (__bitmapData != null && __bitmapData.image != null)
		{
			__imageVersion = __bitmapData.image.version;
		}

		if (__cacheBitmap != null && !__isCacheBitmapRender)
		{
			CanvasBitmap.render(__cacheBitmap, renderer);
		}
		else
		{
			CanvasDisplayObject.render(this, renderer);
			CanvasBitmap.render(this, renderer);
		}

		__renderEvent(renderer);
	}

	@:noCompletion private override function __renderCanvasMask(renderer:CanvasRenderer):Void
	{
		renderer.context.rect(0, 0, width, height);
	}

	@:noCompletion private override function __renderDOM(renderer:DOMRenderer):Void
	{
		__updateCacheBitmap(renderer, /*!__worldColorTransform.__isDefault ()*/ false);

		if (__cacheBitmap != null && !__isCacheBitmapRender)
		{
			__renderDOMClear(renderer);
			__cacheBitmap.stage = stage;

			DOMBitmap.render(__cacheBitmap, renderer);
		}
		else
		{
			DOMDisplayObject.render(this, renderer);
			DOMBitmap.render(this, renderer);
		}

		__renderEvent(renderer);
	}

	@:noCompletion private override function __renderDOMClear(renderer:DOMRenderer):Void
	{
		DOMBitmap.clear(this, renderer);
	}

	@:noCompletion private override function __renderGL(renderer:OpenGLRenderer):Void
	{
		__updateCacheBitmap(renderer, false);

		if (__bitmapData != null && __bitmapData.image != null)
		{
			__imageVersion = __bitmapData.image.version;
		}

		if (__cacheBitmap != null && !__isCacheBitmapRender)
		{
			Context3DBitmap.render(__cacheBitmap, renderer);
		}
		else
		{
			Context3DDisplayObject.render(this, renderer);
			Context3DBitmap.render(this, renderer);
		}

		__renderEvent(renderer);
	}

	@:noCompletion private override function __renderGLMask(renderer:OpenGLRenderer):Void
	{
		Context3DBitmap.renderMask(this, renderer);
	}

	@:noCompletion private override function __updateCacheBitmap(renderer:DisplayObjectRenderer, force:Bool):Bool
	{
		// TODO: Handle filters without an intermediate draw

		#if lime
		if (__bitmapData == null || (__filters == null && renderer.__type == OPENGL && __cacheBitmap == null)) return false;
		return super.__updateCacheBitmap(renderer, __bitmapData.image != null && __bitmapData.image.version != __imageVersion);
		#else
		return false;
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_bitmapData():BitmapData
	{
		return __bitmapData;
	}

	@:noCompletion private function set_bitmapData(value:BitmapData):BitmapData
	{
		__bitmapData = value;
		smoothing = false;

		__setRenderDirty();

		if (__filters != null)
		{
			// __updateFilters = true;
		}

		__imageVersion = -1;

		return __bitmapData;
	}

	@:noCompletion private override function set_height(value:Float):Float
	{
		if (__bitmapData != null)
		{
			scaleY = value / __bitmapData.height; // get_height();
		}
		else
		{
			scaleY = 0;
		}
		return value;
	}

	@:noCompletion private override function set_width(value:Float):Float
	{
		if (__bitmapData != null)
		{
			scaleX = value / __bitmapData.width; // get_width();
		}
		else
		{
			scaleX = 0;
		}
		return value;
	}
}
#else
typedef Bitmap = flash.display.Bitmap;
#end
