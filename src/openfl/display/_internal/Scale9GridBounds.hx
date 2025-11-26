package openfl.display._internal;

import openfl.geom.Matrix;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Scale9GridBounds
{
	public var scale9MinX(default, null):Null<Float> = null;
	public var scale9MinY(default, null):Null<Float> = null;

	private var scale9MaxX:Null<Float> = null;
	private var scale9MaxY:Null<Float> = null;

	public var unscaledMinX(default, null):Null<Float> = null;
	public var unscaledMinY(default, null):Null<Float> = null;

	private var unscaledMaxX:Null<Float> = null;
	private var unscaledMaxY:Null<Float> = null;

	public function new() {}

	public function getScaleX():Float
	{
		if (scale9MaxX == null || unscaledMaxX == null)
		{
			return 1.0;
		}
		var unscaledWidth = unscaledMaxX - unscaledMinX;
		if (unscaledWidth == 0.0)
		{
			return 1.0;
		}
		return (scale9MaxX - scale9MinX) / unscaledWidth;
	}

	public function getScaleY():Float
	{
		if (scale9MaxY == null || unscaledMaxY == null)
		{
			return 1.0;
		}
		var unscaledHeight = unscaledMaxY - unscaledMinY;
		if (unscaledHeight == 0.0)
		{
			return 1.0;
		}
		return (scale9MaxY - scale9MinY) / unscaledHeight;
	}

	private function calculateTranslateX(width:Float):Float
	{
		var scaleX = getScaleX();
		if (scaleX > 0.0)
		{
			var remX = unscaledMinX % width;
			var adjustedRemX = (scale9MinX % (width * scaleX)) / scaleX;
			return adjustedRemX - remX;
		}
		return 0;
	}

	private function calculateTranslateY(height:Float):Float
	{
		var scaleY = getScaleY();
		if (scaleY > 0.0)
		{
			var remY = unscaledMinY % height;
			var adjustedRemY = (scale9MinY % (height * scaleY)) / scaleY;
			return adjustedRemY - remY;
		}
		return 0;
	}

	public function clear():Void
	{
		unscaledMinX = null;
		unscaledMaxX = null;
		unscaledMinY = null;
		unscaledMaxY = null;
		scale9MinX = null;
		scale9MaxX = null;
		scale9MinY = null;
		scale9MaxY = null;
	}

	public function applyUnscaledX(value:Float):Void
	{
		if (unscaledMinX == null || unscaledMinX > value)
		{
			unscaledMinX = value;
		}
		if (unscaledMaxX == null || unscaledMaxX < value)
		{
			unscaledMaxX = value;
		}
	}

	public function applyUnscaledY(value:Float):Void
	{
		if (unscaledMinY == null || unscaledMinY > value)
		{
			unscaledMinY = value;
		}
		if (unscaledMaxY == null || unscaledMaxY < value)
		{
			unscaledMaxY = value;
		}
	}

	public function applyScaledX(value:Float):Void
	{
		if (scale9MinX == null || scale9MinX > value)
		{
			scale9MinX = value;
		}
		if (scale9MaxX == null || scale9MaxX < value)
		{
			scale9MaxX = value;
		}
	}

	public function applyScaledY(value:Float):Void
	{
		if (scale9MinY == null || scale9MinY > value)
		{
			scale9MinY = value;
		}
		if (scale9MaxY == null || scale9MaxY < value)
		{
			scale9MaxY = value;
		}
	}

	public function calculateBitmapMatrix(bitmapWidth:Float, bitmapHeight:Float, bitmapMatrix:Matrix, outputMatrix:Matrix):Matrix
	{
		outputMatrix.setTo(getScaleX(), 0, 0, getScaleY(), calculateTranslateX(bitmapWidth), calculateTranslateY(bitmapHeight));
		if (bitmapMatrix != null)
		{
			outputMatrix.concat(bitmapMatrix);
		}
		return outputMatrix;
	}
}
#end
