package openfl._internal.formats.xfl.symbol;

import openfl._internal.formats.xfl.symbol.Symbol;
import openfl.display.Graphics;
import openfl.display.GraphicsPath;

class ShapeEdge
{
	public var fillStyle:Int;
	public var isQuadratic:Bool;
	public var cx:Float;
	public var cy:Float;
	public var x0:Float;
	public var x1:Float;
	public var y0:Float;
	public var y1:Float;

	public function new() {}

	public function asCommand():GraphicsPathCommand
	{
		if (isQuadratic)
		{
			return function(graphicsPath:GraphicsPath)
			{
				graphicsPath.curveTo(cx, cy, x1, y1);
			}
		}
		else
		{
			return function(graphicsPath:GraphicsPath)
			{
				graphicsPath.lineTo(x1, y1);
			}
		}
	}

	public function connects(next:ShapeEdge)
	{
		return fillStyle == next.fillStyle && Math.abs(x1 - next.x0) < 0.00001 && Math.abs(y1 - next.y0) < 0.00001;
	}

	public static function curve(style:Int, x0:Float, y0:Float, cx:Float, cy:Float, x1:Float, y1:Float):ShapeEdge
	{
		var result = new ShapeEdge();
		result.fillStyle = style;
		result.x0 = x0;
		result.y0 = y0;
		result.cx = cx;
		result.cy = cy;
		result.x1 = x1;
		result.y1 = y1;
		result.isQuadratic = true;
		return result;
	}

	public function dump():Void
	{
		trace(x0 + "," + y0 + " -> " + x1 + "," + y1 + " (" + fillStyle + ")");
	}

	public static function line(style:Int, x0:Float, y0:Float, x1:Float, y1:Float):ShapeEdge
	{
		var result = new ShapeEdge();
		result.fillStyle = style;
		result.x0 = x0;
		result.y0 = y0;
		result.x1 = x1;
		result.y1 = y1;
		result.isQuadratic = false;
		return result;
	}
}
