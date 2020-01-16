package openfl._internal.renderer.opengl.utils;

import openfl.display3D.Context3D;
import openfl.display.Graphics;
import openfl.display.HWGraphics;

@:access(openfl._internal.renderer.opengl.utils.GraphicsRenderer)
@:access(openfl.display.Graphics)
@:access(openfl.display.HWGraphics)
@SuppressWarnings("checkstyle:FieldDocComment")
class PathBuilder
{
	private static var __currentPath:DrawPath;
	private static var __currentWinding:WindingRule = WindingRule.EVEN_ODD;
	private static var __drawPaths:Array<DrawPath>;
	private static var __line:LineStyle;
	private static var __fill:FillType;
	private static var __fillIndex:Int = 0;

	private static function closePath():Void
	{
		var l = __currentPath.points.length;
		if (l <= 0) return;
		// the paths are only closed when the type is a polygon and there is a fill
		if (__currentPath.type == Polygon && __currentPath.fill != None)
		{
			var sx = __currentPath.points[0];
			var sy = __currentPath.points[1];
			var ex = __currentPath.points[l - 2];
			var ey = __currentPath.points[l - 1];

			if (!(sx == ex && sy == ey))
			{
				__currentPath.points.push(sx);
				__currentPath.points.push(sy);
			}
		}
	}

	private static function endFill():Void
	{
		__fill = None;
		__fillIndex++;
	}

	private static inline function moveTo(x:Float, y:Float):Void
	{
		graphicDataPop();
		__currentPath = new DrawPath();
		__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
		__currentPath.type = Polygon;
		__currentPath.points.push(x);
		__currentPath.points.push(y);

		__drawPaths.push(__currentPath);
	}

	private static inline function lineTo(x:Float, y:Float):Void
	{
		__currentPath.points.push(x);
		__currentPath.points.push(y);
	}

	private static inline function curveTo(cx:Float, cy:Float, x:Float, y:Float):Void
	{
		if (__currentPath.points.length == 0)
		{
			moveTo(0, 0);
		}

		var xa:Float = 0;
		var ya:Float = 0;
		var n = 20;

		var points = __currentPath.points;
		var fromX = points[points.length - 2];
		var fromY = points[points.length - 1];

		var px:Float = 0;
		var py:Float = 0;

		var tmp:Float = 0;

		for (i in 1...(n + 1))
		{
			tmp = i / n;

			xa = fromX + ((cx - fromX) * tmp);
			ya = fromY + ((cy - fromY) * tmp);

			px = xa + (((cx + (x - cx) * tmp)) - xa) * tmp;
			py = ya + (((cy + (y - cy) * tmp)) - ya) * tmp;

			points.push(px);
			points.push(py);
		}
	}

	private static inline function cubicCurveTo(cx:Float, cy:Float, cx2:Float, cy2:Float, x:Float, y:Float):Void
	{
		if (__currentPath.points.length == 0)
		{
			moveTo(0, 0);
		}

		var n = 20;
		var dt:Float = 0;
		var dt2:Float = 0;
		var dt3:Float = 0;
		var t2:Float = 0;
		var t3:Float = 0;

		var points = __currentPath.points;
		var fromX = points[points.length - 2];
		var fromY = points[points.length - 1];

		var px:Float = 0;
		var py:Float = 0;

		var tmp:Float = 0;

		for (i in 1...(n + 1))
		{
			tmp = i / n;

			dt = 1 - tmp;
			dt2 = dt * dt;
			dt3 = dt2 * dt;

			t2 = tmp * tmp;
			t3 = t2 * tmp;

			px = dt3 * fromX + 3 * dt2 * tmp * cx + 3 * dt * t2 * cx2 + t3 * x;
			py = dt3 * fromY + 3 * dt2 * tmp * cy + 3 * dt * t2 * cy2 + t3 * y;

			points.push(px);
			points.push(py);
		}
	}

	private inline static function graphicDataPop():Void
	{
		if (__currentPath.isRemovable && __currentPath.points.length == 0)
		{
			__drawPaths.pop();
		}
		else
		{
			closePath();
		}
	}

	public static function build(graphics:Graphics, context3D:Context3D):GLStack
	{
		var glStack:GLStack = null;
		var bounds = graphics.__bounds;

		__drawPaths = new Array();
		__currentPath = new DrawPath();
		__line = new LineStyle();
		__fill = None;
		__fillIndex = 0;

		glStack = graphics.__glStack[0 /*GLRenderer.glContextId*/];

		if (glStack == null)
		{
			glStack = graphics.__glStack[0 /*GLRenderer.glContextId*/] = new GLStack(context3D);
		}

		if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0)
		{
			// glStack = graphics.__glStack[GLRenderer.glContextId] = new GLStack (gl);
		}
		else
		{
			var data = new DrawCommandReader(graphics.__commands);

			for (type in graphics.__commands.types)
			{
				switch (type)
				{
					case BEGIN_BITMAP_FILL:
						var c = data.readBeginBitmapFill();
						var bitmap = c.bitmap;
						var repeat = c.repeat;
						var smooth = c.smooth;
						var matrix = c.matrix;

						endFill();
						__fill = bitmap != null ? Texture(bitmap, matrix, repeat, smooth) : None;

						if (__currentPath.points.length == 0)
						{
							graphicDataPop();
							__currentPath = new DrawPath();
							__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
							__currentPath.points = [];
							__currentPath.type = Polygon;
							__drawPaths.push(__currentPath);
						}

					case BEGIN_FILL:
						var c = data.readBeginFill();
						var rgb = c.color;
						var alpha = c.alpha;

						endFill();
						__fill = alpha > 0 ? Color(rgb & 0xFFFFFF, alpha) : None;

						if (__currentPath.points.length == 0)
						{
							graphicDataPop();
							__currentPath = new DrawPath();
							__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
							__currentPath.points = [];
							__currentPath.type = Polygon;
							__drawPaths.push(__currentPath);
						}

					case CUBIC_CURVE_TO:
						var c = data.readCubicCurveTo();
						var cx = c.controlX1;
						var cy = c.controlY1;
						var cx2 = c.controlX2;
						var cy2 = c.controlY2;
						var x = c.anchorX;
						var y = c.anchorY;

						cubicCurveTo(cx, cy, cx2, cy2, x, y);

					case CURVE_TO:
						var c = data.readCurveTo();
						var cx = c.controlX;
						var cy = c.controlY;
						var x = c.anchorX;
						var y = c.anchorY;

						curveTo(cx, cy, x, y);

					case DRAW_CIRCLE:
						var c = data.readDrawCircle();
						var x = c.x;
						var y = c.y;
						var radius = c.radius;

						graphicDataPop();

						__currentPath = new DrawPath();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = Circle;
						__currentPath.points = [x, y, radius];

						__drawPaths.push(__currentPath);

					case DRAW_ELLIPSE:
						var c = data.readDrawEllipse();
						var x = c.x;
						var y = c.y;
						var width = c.width;
						var height = c.height;

						graphicDataPop();

						__currentPath = new DrawPath();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = Ellipse;
						__currentPath.points = [x, y, width, height];

						__drawPaths.push(__currentPath);

					case DRAW_RECT:
						var c = data.readDrawRect();
						var x = c.x;
						var y = c.y;
						var width = c.width;
						var height = c.height;

						graphicDataPop();

						__currentPath = new DrawPath();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = Rectangle(false);
						__currentPath.points = [x, y, width, height];

						__drawPaths.push(__currentPath);

					case DRAW_ROUND_RECT:
						var c = data.readDrawRoundRect();
						var x = c.x;
						var y = c.y;
						var width = c.width;
						var height = c.height;
						var rx = c.ellipseWidth;
						var ry = c.ellipseHeight;

						if (ry == -1) ry = rx;

						rx *= 0.5;
						ry *= 0.5;

						if (rx > width / 2) rx = width / 2;
						if (ry > height / 2) ry = height / 2;

						graphicDataPop();

						__currentPath = new DrawPath();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = Rectangle(true);
						__currentPath.points = [x, y, width, height, rx, ry];

						__drawPaths.push(__currentPath);

					case END_FILL:
						endFill();

					case LINE_STYLE:
						var c = data.readLineStyle();
						var thickness = c.thickness;
						var color = c.color;
						var alpha = c.alpha;
						var pixelHinting = c.pixelHinting;
						var scaleMode = c.scaleMode;
						var caps = c.caps;
						var joints = c.joints;
						var miterLimit = c.miterLimit;

						__line = new LineStyle();

						if (thickness == null || Math.isNaN(thickness) || thickness < 0)
						{
							__line.width = 0;
						}
						else if (thickness == 0)
						{
							__line.width = 1;
						}
						else
						{
							__line.width = thickness;
						}

						graphicDataPop();

						__line.color = color == null ? 0 : color;
						__line.alpha = alpha == null ? 1 : alpha;
						__line.scaleMode = scaleMode;
						__line.caps = caps;
						__line.joints = joints;
						__line.miterLimit = miterLimit;

						__currentPath = new DrawPath();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.points = [];
						__currentPath.type = GraphicType.Polygon;

						__drawPaths.push(__currentPath);

					case LINE_TO:
						var c = data.readLineTo();
						var x = c.x;
						var y = c.y;

						lineTo(x, y);

					case MOVE_TO:
						var c = data.readMoveTo();
						var x = c.x;
						var y = c.y;

						moveTo(x, y);

					// case DrawTriangles(vertices, indices, uvtData, culling, colors, blendMode):
					// 	var isColor = switch (__fill)
					// 	{
					// 		case Color(_, _): true;
					// 		case _: false;
					// 	};
					// 	if (isColor && uvtData != null)
					// 	{
					// 		// Flash doesn't draw anything if the fill isn't a bitmap and there are uvt values
					// 		continue;
					// 	}

					// 	graphicDataPop();

					// 	__currentPath = new DrawPath();
					// 	__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
					// 	if (uvtData == null)
					// 	{
					// 		uvtData = new Vector<Float>();
					// 		switch (__fill)
					// 		{
					// 			case Texture(b, _):
					// 				for (i in 0...Std.int(vertices.length / 2))
					// 				{
					// 					uvtData.push(vertices[i * 2] / b.width);
					// 					uvtData.push(vertices[i * 2 + 1] / b.height);
					// 				}
					// 			case _:
					// 		}
					// 	}
					// 	__currentPath.type = GraphicType.DrawTriangles(vertices, indices, uvtData, culling, colors, blendMode);
					// 	__currentPath.isRemovable = false;
					// 	__drawPaths.push(__currentPath);

					// case DrawTiles(sheet, tileData, smooth, flags, count):
					// 	graphicDataPop();

					// 	__fillIndex++;
					// 	__currentPath = new DrawPath();
					// 	__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
					// 	__currentPath.type = GraphicType.DrawTiles(sheet, tileData, smooth, flags, count);
					// 	__currentPath.isRemovable = false;
					// 	__drawPaths.push(__currentPath);

					// case DrawPathC(commands, data, winding):
					// 	graphicDataPop();

					// 	switch (winding)
					// 	{
					// 		case GraphicsPathWinding.EVEN_ODD:
					// 			__currentWinding = EVEN_ODD;
					// 		case GraphicsPathWinding.NON_ZERO:
					// 			__currentWinding = NON_ZERO;
					// 		default:
					// 			__currentWinding = EVEN_ODD;
					// 	}

					// 	var command:Int;
					// 	var cx:Float, cy:Float;
					// 	var cx2:Float, cy2:Float;
					// 	var ax:Float, ay:Float;
					// 	var idx = 0;
					// 	for (i in 0...commands.length)
					// 	{
					// 		command = commands[i];
					// 		switch (command)
					// 		{
					// 			case GraphicsPathCommand.MOVE_TO:
					// 				ax = data[idx + 0];
					// 				ay = data[idx + 1];
					// 				idx += 2;
					// 				moveTo(ax, ay);
					// 			case GraphicsPathCommand.WIDE_MOVE_TO:
					// 				ax = data[idx + 2];
					// 				ay = data[idx + 3];
					// 				idx += 4;
					// 				moveTo(ax, ay);
					// 			case GraphicsPathCommand.LINE_TO:
					// 				ax = data[idx + 0];
					// 				ay = data[idx + 1];
					// 				idx += 2;
					// 				lineTo(ax, ay);
					// 			case GraphicsPathCommand.WIDE_LINE_TO:
					// 				ax = data[idx + 2];
					// 				ay = data[idx + 3];
					// 				idx += 4;
					// 				lineTo(ax, ay);
					// 			case GraphicsPathCommand.CURVE_TO:
					// 				cx = data[idx + 0];
					// 				cy = data[idx + 1];
					// 				ax = data[idx + 2];
					// 				ay = data[idx + 3];
					// 				idx += 4;
					// 				curveTo(cx, cy, ax, ay);
					// 			case GraphicsPathCommand.CUBIC_CURVE_TO:
					// 				cx = data[idx + 0];
					// 				cy = data[idx + 1];
					// 				cx2 = data[idx + 2];
					// 				cy2 = data[idx + 3];
					// 				ax = data[idx + 4];
					// 				ay = data[idx + 5];
					// 				idx += 6;
					// 				cubicCurveTo(cx, cy, cx2, cy2, ax, ay);

					// 			default:
					// 		}
					// 	}

					// 	__currentWinding = EVEN_ODD;

					// case OverrideMatrix(m):
					// 	graphicDataPop();

					// 	__currentPath = new DrawPath();
					// 	__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
					// 	__currentPath.type = GraphicType.OverrideMatrix(m);
					// 	__currentPath.isRemovable = false;
					// 	__drawPaths.push(__currentPath);
					default:
						data.skip(type);
				}
			}

			closePath();
		}

		graphics.__drawPaths = __drawPaths;

		return glStack;
	}
}
