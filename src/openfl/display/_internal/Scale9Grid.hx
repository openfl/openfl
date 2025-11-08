package openfl.display._internal;

import openfl.display.DisplayObject;
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
	private static var bounds:Rectangle;
	private static var owner:DisplayObject;
	private static var scale9Grid:Rectangle;

	public static var x(default, null):Float;
	public static var y(default, null):Float;
	public static var width(default, null):Float;
	public static var height(default, null):Float;

	public static var fillBounds(default, null) = new Scale9GridBounds();
	public static var strokeBounds(default, null) = new Scale9GridBounds();
	public static var valid(default, null):Bool = false;

	public static function setTo(graphics:Graphics)
	{
		valid = false;
		if (graphics.__owner.scale9Grid != null && !graphics.__owner.__isMask && graphics.__worldTransform.b == 0 && graphics.__worldTransform.c == 0)
		{
			// TODO: Check if scroll9Grid is smaller than bounds x, if so then validX = false. Same for y.
			valid = true;
			owner = graphics.__owner;
			scale9Grid = graphics.__owner.__scale9Grid;
			x = scale9Grid.x;
			y = scale9Grid.y;
			width = scale9Grid.width;
			height = scale9Grid.height;
			bounds = graphics.__bounds;
			fillBounds.clear();
			strokeBounds.clear();
		}
	}

	public static function toPositionX(pos:Float):Float
	{
		return __toPosition(pos, scale9Grid.x, scale9Grid.width, bounds.width, owner.scaleX);
	}

	public static function toPositionY(pos:Float):Float
	{
		return __toPosition(pos, scale9Grid.y, scale9Grid.height, bounds.height, owner.scaleY);
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

	public static function applyUnscaledX(x:Float):Void
	{
		fillBounds.applyUnscaledX(x);
		strokeBounds.applyUnscaledX(x);
	}

	public static function applyUnscaledY(y:Float):Void
	{
		fillBounds.applyUnscaledY(y);
		strokeBounds.applyUnscaledY(y);
	}

	public static function applyScaledX(x:Float):Void
	{
		fillBounds.applyScaledX(x);
		strokeBounds.applyScaledX(x);
	}

	public static function applyScaledY(y:Float):Void
	{
		fillBounds.applyScaledY(y);
		strokeBounds.applyScaledY(y);
	}
}
#end
