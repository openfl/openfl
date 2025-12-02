package openfl.display._internal;

import openfl.geom.Matrix;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Scale9GridBounds
{
	private var scaledMinX:Null<Float> = null;
	private var scaledMinY:Null<Float> = null;
	private var scaledMaxX:Null<Float> = null;
	private var scaledMaxY:Null<Float> = null;

	private var unscaledMinX:Null<Float> = null;
	private var unscaledMinY:Null<Float> = null;
	private var unscaledMaxX:Null<Float> = null;
	private var unscaledMaxY:Null<Float> = null;

	public function new() {}

	public function getScaleX():Float
	{
		if (scaledMaxX == null || unscaledMaxX == null)
		{
			return 1.0;
		}
		var unscaledWidth = unscaledMaxX - unscaledMinX;
		if (unscaledWidth == 0.0)
		{
			return 1.0;
		}
		return (scaledMaxX - scaledMinX) / unscaledWidth;
	}

	public function getScaleY():Float
	{
		if (scaledMaxY == null || unscaledMaxY == null)
		{
			return 1.0;
		}
		var unscaledHeight = unscaledMaxY - unscaledMinY;
		if (unscaledHeight == 0.0)
		{
			return 1.0;
		}
		return (scaledMaxY - scaledMinY) / unscaledHeight;
	}

	private function calculateTranslateX(width:Float):Float
	{
		var scaleX = getScaleX();
		if (scaleX > 0.0)
		{
			var remX = unscaledMinX % width;
			var adjustedRemX = (scaledMinX % (width * scaleX)) / scaleX;
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
			var adjustedRemY = (scaledMinY % (height * scaleY)) / scaleY;
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

		scaledMinX = null;
		scaledMaxX = null;
		scaledMinY = null;
		scaledMaxY = null;
	}

	public function applyUnscaled(x:Float, y:Float):Void
	{
		if (unscaledMinX == null || unscaledMinX > x)
		{
			unscaledMinX = x;
		}
		if (unscaledMaxX == null || unscaledMaxX < x)
		{
			unscaledMaxX = x;
		}
		if (unscaledMinY == null || unscaledMinY > y)
		{
			unscaledMinY = y;
		}
		if (unscaledMaxY == null || unscaledMaxY < y)
		{
			unscaledMaxY = y;
		}
	}

	public function applyScaled(x:Float, y:Float):Void
	{
		if (scaledMinX == null || scaledMinX > x)
		{
			scaledMinX = x;
		}
		if (scaledMaxX == null || scaledMaxX < x)
		{
			scaledMaxX = x;
		}
		if (scaledMinY == null || scaledMinY > y)
		{
			scaledMinY = y;
		}
		if (scaledMaxY == null || scaledMaxY < y)
		{
			scaledMaxY = y;
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
