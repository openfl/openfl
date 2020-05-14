package openfl.display;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
#if openfl_html5
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
@:noCompletion
class _Bitmap extends _DisplayObject
{
	public var bitmapData(get, set):BitmapData;
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;

	public var __bitmapData:BitmapData;
	#if openfl_html5
	public var __image:ImageElement;
	#end
	public var __imageVersion:Int;

	private var bitmap:Bitmap;

	public function new(bitmap:Bitmap, bitmapData:BitmapData = null, pixelSnapping:PixelSnapping = null, smoothing:Bool = false)
	{
		this.bitmap = bitmap;

		super(bitmap);

		__type = BITMAP;

		__bitmapData = bitmapData;
		this.pixelSnapping = pixelSnapping;
		this.smoothing = smoothing;

		if (pixelSnapping == null)
		{
			this.pixelSnapping = PixelSnapping.AUTO;
		}
	}

	public override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		var bounds = _Rectangle.__pool.get();
		if (__bitmapData != null)
		{
			bounds.setTo(0, 0, __bitmapData.width, __bitmapData.height);
		}
		else
		{
			bounds.setTo(0, 0, 0, 0);
		}

		bounds._.__transform(bounds, matrix);
		rect._.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		_Rectangle.__pool.release(bounds);
	}

	public override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask || __bitmapData == null) return false;
		if (mask != null && !(mask._ : _DisplayObject).__hitTestMask(x, y)) return false;

		__getRenderTransform();

		var px = __renderTransform._.__transformInverseX(x, y);
		var py = __renderTransform._.__transformInverseY(x, y);

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

	public override function __hitTestMask(x:Float, y:Float):Bool
	{
		if (__bitmapData == null) return false;

		__getRenderTransform();

		var px = __renderTransform._.__transformInverseX(x, y);
		var py = __renderTransform._.__transformInverseY(x, y);

		if (px > 0 && py > 0 && px <= __bitmapData.width && py <= __bitmapData.height)
		{
			return true;
		}

		return false;
	}

	// Get & Set Methods

	private function get_bitmapData():BitmapData
	{
		return __bitmapData;
	}

	private function set_bitmapData(value:BitmapData):BitmapData
	{
		__bitmapData = value;
		smoothing = false;

		__localBoundsDirty = true;
		__setRenderDirty();

		if (__filters != null)
		{
			// __updateFilters = true;
		}

		__imageVersion = -1;

		return __bitmapData;
	}

	public override function set_height(value:Float):Float
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

	public override function set_width(value:Float):Float
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
