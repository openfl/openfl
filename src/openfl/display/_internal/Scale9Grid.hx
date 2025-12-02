package openfl.display._internal;

import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
class Scale9Grid
{
	public static var graphics(default, set):Graphics;

	private static var __owner:DisplayObject;
	private static var __scale9Grid:Rectangle;

	public static var x(default, null):Float;
	public static var y(default, null):Float;
	public static var width(default, null):Float;
	public static var height(default, null):Float;

	public static var fillBounds(default, null) = new Scale9GridBounds();
	public static var strokeBounds(default, null) = new Scale9GridBounds();
	public static var valid(default, null):Bool = false;

	public static function set_graphics(graphics:Graphics):Graphics
	{
		if (graphics.__owner.__scale9Grid != null
			&& !graphics.__owner.__isMask
			&& graphics.__worldTransform.b == 0
			&& graphics.__worldTransform.c == 0)
		{
			// TODO: Check if scroll9Grid is smaller than bounds x, if so then validX = false. Same for y.
			valid = true;
			__owner = graphics.__owner;
			__scale9Grid = graphics.__owner.__scale9Grid;

			x = __scale9Grid.x;
			y = __scale9Grid.y;
			width = __scale9Grid.width;
			height = __scale9Grid.height;
			fillBounds.clear();
			strokeBounds.clear();
		}
		else
		{
			valid = false;
			__owner = null;
			__scale9Grid = null;
		}
		return Scale9Grid.graphics = graphics;
	}

	public static function toPositionX(pos:Float):Float
	{
		return __toPosition(pos, __scale9Grid.x, __scale9Grid.width, graphics.__bounds.width, __owner.scaleX);
	}

	public static function toPositionY(pos:Float):Float
	{
		return __toPosition(pos, __scale9Grid.y, __scale9Grid.height, graphics.__bounds.height, __owner.scaleY);
	}

	private static inline function __toPosition(pos:Float, scale9Start:Float, scale9Center:Float, unscaledSize:Float, scale:Float):Float
	{
		if (scale <= 0.0)
		{
			// doesn't render if scaled with negative value
			return 0.0;
		}
		var scale9End = unscaledSize - scale9Center - scale9Start;
		var size = unscaledSize * scale;
		var center = size - scale9Start - scale9End;
		if (pos <= scale9Start)
		{
			// start region
			if (center < 0.0)
			{
				return pos * (scale9Start + scale9End + center) / (scale9Start + scale9End);
			}
			return pos;
		}
		if (pos >= (scale9Start + scale9Center))
		{
			// end region
			if (center < 0.0)
			{
				return (scale9Start + (pos - scale9Start - scale9Center)) * (scale9Start + scale9End + center) / (scale9Start + scale9End);
			}
			return scale9Start + center + (pos - scale9Start - scale9Center);
		}
		// center region
		if (center < 0.0)
		{
			return scale9Start * (scale9Start + scale9End + center) / (scale9Start + scale9End);
		}
		return scale9Start + center * (pos - scale9Start) / scale9Center;
	}

	public static function applyUnscaled(x:Float, y:Float):Void
	{
		fillBounds.applyUnscaled(x, y);
		strokeBounds.applyUnscaled(x, y);
	}

	public static function applyScaled(x:Float, y:Float):Void
	{
		fillBounds.applyScaled(x, y);
		strokeBounds.applyScaled(x, y);
	}
}
#end
