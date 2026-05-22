package openfl.display._internal;

#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.GraphicsPathWinding;
import openfl.display.InterpolationMethod;
import openfl.display.MovieClip;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Graphics)
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:access(openfl.display._internal.DrawCommandReader)
class GraphicsTessellator
{
	private static inline var COLLINEAR_EPSILON = 1e-4;
	private static inline var CONTOUR_EPSILON = 1e-3;
	private static inline var FLATTEN_TOLERANCE = 0.35;
	private static inline var FLATTEN_TOLERANCE_SQ = FLATTEN_TOLERANCE * FLATTEN_TOLERANCE;
	private static inline var MAX_FLATTEN_DEPTH = 8;

	public static function commandsContainGradient(graphics:Graphics):Bool
	{
		if (graphics.__commands == null) return false;

		for (type in graphics.__commands.types)
		{
			switch (type)
			{
				case BEGIN_GRADIENT_FILL, LINE_GRADIENT_STYLE:
					return true;
				default:
			}
		}

		return false;
	}

	public static function prepare(graphics:Graphics):Bool
	{
		// Gradient fills are not tessellated; use Cairo for correct rendering.
		if (commandsContainGradient(graphics))
		{
			graphics.__tessellatedFillParts = null;
			return false;
		}

		if (!graphics.__hardwareDirty && graphics.__tessellatedFillParts != null)
		{
			return graphics.__tessellatedFillParts.length > 0;
		}

		graphics.__tessellatedFillParts = null;

		if (graphics.__commands == null || graphics.__commands.length == 0)
		{
			return false;
		}

		var data = new DrawCommandReader(graphics.__commands);
		var parts = new Array<GraphicsTessellatedFillPart>();
		var currentFill:Null<Int> = null;
		var currentBitmap:BitmapData = null;
		var currentBitmapMatrix:Matrix = null;
		var currentBitmapSmooth = true;
		var currentBitmapRepeat = false;
		var currentContours = new Array<Vector<Float>>();
		var currentContour = new Vector<Float>();
		var winding = GraphicsPathWinding.EVEN_ODD;
		var skipStrokePaths = false;
		var positionX = 0.0;
		var positionY = 0.0;

		inline function reject(reason:String):Bool
		{
			data.destroy();
			return false;
		}

		inline function resetContour():Void
		{
			currentContour = new Vector<Float>();
		}

		function finalizeContour():Bool
		{
			var contour = normalizeContour(currentContour);
			resetContour();

			if (contour == null)
			{
				return true;
			}

			if (hasSelfIntersection(contour))
			{
				return false;
			}

			currentContours.push(contour);
			return true;
		}

		function finalizeFill():Bool
		{
			if (!finalizeContour())
			{
				return false;
			}

			if (currentFill == null && currentBitmap == null)
			{
				currentContours = [];
				return true;
			}

			if (currentContours.length == 0)
			{
				currentFill = null;
				currentBitmap = null;
				currentBitmapMatrix = null;
				currentContours = [];
				return true;
			}

			if (hasNestedContours(currentContours))
			{
				return false;
			}

			var partVertices = new Vector<Float>();
			var partIndices = new Vector<Int>();

			for (contour in currentContours)
			{
				if (!appendTriangulatedContour(contour, partVertices, partIndices))
				{
					return false;
				}
			}

			if (partIndices.length > 0)
			{
				if (currentBitmap != null)
				{
					var uvtData = new Vector<Float>();
					populateBitmapUvt(partVertices, currentBitmap, currentBitmapMatrix, uvtData);
					parts.push(new GraphicsTessellatedFillPart(partVertices, partIndices, null, currentBitmap, currentBitmapMatrix,
						currentBitmapSmooth, currentBitmapRepeat, uvtData));
				}
				else
				{
					parts.push(new GraphicsTessellatedFillPart(partVertices, partIndices, currentFill));
				}
			}

			currentFill = null;
			currentBitmap = null;
			currentBitmapMatrix = null;
			currentContours = [];
			return true;
		}

		for (type in graphics.__commands.types)
		{
			switch (type)
			{
				case BEGIN_GRADIENT_FILL, LINE_GRADIENT_STYLE:
					return reject("gradientFill");

				case BEGIN_BITMAP_FILL:
					if (!finalizeFill())
					{
						return reject("finalizeFill");
					}

					skipStrokePaths = false;

					var bitmapCommand = data.readBeginBitmapFill();
					if (bitmapCommand.bitmap == null)
					{
						return reject("bitmapNull");
					}

					if (bitmapCommand.matrix != null)
					{
						var m = bitmapCommand.matrix;
						if (m.a * m.d - m.b * m.c == 0)
						{
							return reject("bitmapMatrixSingular");
						}
					}

					currentBitmap = bitmapCommand.bitmap;
					currentBitmapMatrix = bitmapCommand.matrix;
					currentBitmapSmooth = bitmapCommand.smooth;
					currentBitmapRepeat = bitmapCommand.repeat;
					currentFill = null;
					winding = GraphicsPathWinding.EVEN_ODD;

				case BEGIN_FILL:
					if (!finalizeFill())
					{
						return reject("finalizeFill");
					}

					skipStrokePaths = false;

					var c = data.readBeginFill();
					var color = Std.int(c.color);
					var alpha = Std.int(c.alpha * 0xFF);
					currentFill = (color & 0xFFFFFF) | (alpha << 24);
					currentBitmap = null;
					currentBitmapMatrix = null;
					winding = GraphicsPathWinding.EVEN_ODD;

				case END_FILL:
					data.readEndFill();
					if (skipStrokePaths)
					{
						skipStrokePaths = false;
						currentContours = [];
						resetContour();
					}
					else if (!finalizeFill())
					{
						return reject("endFill");
					}

				case MOVE_TO:
					var moveCommand = data.readMoveTo();
					positionX = moveCommand.x;
					positionY = moveCommand.y;

					if (skipStrokePaths)
					{
						resetContour();
					}
					else
					{
						if (currentFill == null && currentBitmap == null)
						{
							return reject("moveWithoutFill");
						}

						if (!finalizeContour())
						{
							return reject("contourFinalizeOnMove");
						}

						currentContour.push(positionX);
						currentContour.push(positionY);
					}

				case LINE_TO:
					var lineCommand = data.readLineTo();
					positionX = lineCommand.x;
					positionY = lineCommand.y;

					if (skipStrokePaths)
					{
					}
					else
					{
						if ((currentFill == null && currentBitmap == null) || currentContour.length == 0)
						{
							return reject("lineWithoutContour");
						}

						currentContour.push(positionX);
						currentContour.push(positionY);
					}

				case CURVE_TO:
					var curveCommand = data.readCurveTo();

					if (skipStrokePaths)
					{
						positionX = curveCommand.anchorX;
						positionY = curveCommand.anchorY;
					}
					else
					{
						if ((currentFill == null && currentBitmap == null) || currentContour.length == 0)
						{
							return reject("curveWithoutContour");
						}

						appendQuadraticCurve(currentContour, positionX, positionY, curveCommand.controlX, curveCommand.controlY, curveCommand.anchorX,
							curveCommand.anchorY, 0);
						positionX = curveCommand.anchorX;
						positionY = curveCommand.anchorY;
					}

				case CUBIC_CURVE_TO:
					var cubicCommand = data.readCubicCurveTo();

					if (skipStrokePaths)
					{
						positionX = cubicCommand.anchorX;
						positionY = cubicCommand.anchorY;
					}
					else
					{
						if ((currentFill == null && currentBitmap == null) || currentContour.length == 0)
						{
							return reject("cubicWithoutContour");
						}

						appendCubicCurve(currentContour, positionX, positionY, cubicCommand.controlX1, cubicCommand.controlY1, cubicCommand.controlX2,
							cubicCommand.controlY2, cubicCommand.anchorX, cubicCommand.anchorY, 0);
						positionX = cubicCommand.anchorX;
						positionY = cubicCommand.anchorY;
					}

				case LINE_STYLE:
					var c = data.readLineStyle();
					if (c.thickness != null)
					{
						return reject("lineStyle");
					}

				case WINDING_EVEN_ODD:
					data.readWindingEvenOdd();
					winding = GraphicsPathWinding.EVEN_ODD;

				case WINDING_NON_ZERO:
					data.readWindingNonZero();
					winding = GraphicsPathWinding.NON_ZERO;

				case OVERRIDE_BLEND_MODE, OVERRIDE_MATRIX:
					return reject(Type.enumConstructor(type));

				default:
					if (skipStrokePaths)
					{
						data.skip(type);
					}
					else
					{
						return reject(Type.enumConstructor(type));
					}
			}
		}

		if (!finalizeFill())
		{
			return reject("finalizeEnd");
		}

		data.destroy();

		if (winding == GraphicsPathWinding.NON_ZERO && parts.length > 1)
		{
			return false;
		}

		if (parts.length == 0)
		{
			return false;
		}

		graphics.__tessellatedFillParts = parts;
		return true;
	}

	private static function appendCubicCurve(contour:Vector<Float>, x0:Float, y0:Float, x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float,
			depth:Int):Void
	{
		if (depth >= MAX_FLATTEN_DEPTH || cubicFlatnessSq(x0, y0, x1, y1, x2, y2, x3, y3) <= FLATTEN_TOLERANCE_SQ)
		{
			pushPoint(contour, x3, y3);
			return;
		}

		var x01 = (x0 + x1) * 0.5;
		var y01 = (y0 + y1) * 0.5;
		var x12 = (x1 + x2) * 0.5;
		var y12 = (y1 + y2) * 0.5;
		var x23 = (x2 + x3) * 0.5;
		var y23 = (y2 + y3) * 0.5;
		var x012 = (x01 + x12) * 0.5;
		var y012 = (y01 + y12) * 0.5;
		var x123 = (x12 + x23) * 0.5;
		var y123 = (y12 + y23) * 0.5;
		var x0123 = (x012 + x123) * 0.5;
		var y0123 = (y012 + y123) * 0.5;

		appendCubicCurve(contour, x0, y0, x01, y01, x012, y012, x0123, y0123, depth + 1);
		appendCubicCurve(contour, x0123, y0123, x123, y123, x23, y23, x3, y3, depth + 1);
	}

	private static function appendQuadraticCurve(contour:Vector<Float>, x0:Float, y0:Float, x1:Float, y1:Float, x2:Float, y2:Float, depth:Int):Void
	{
		if (depth >= MAX_FLATTEN_DEPTH || quadraticFlatnessSq(x0, y0, x1, y1, x2, y2) <= FLATTEN_TOLERANCE_SQ)
		{
			pushPoint(contour, x2, y2);
			return;
		}

		var x01 = (x0 + x1) * 0.5;
		var y01 = (y0 + y1) * 0.5;
		var x12 = (x1 + x2) * 0.5;
		var y12 = (y1 + y2) * 0.5;
		var x012 = (x01 + x12) * 0.5;
		var y012 = (y01 + y12) * 0.5;

		appendQuadraticCurve(contour, x0, y0, x01, y01, x012, y012, depth + 1);
		appendQuadraticCurve(contour, x012, y012, x12, y12, x2, y2, depth + 1);
	}

	private static function appendTriangulatedContour(contour:Vector<Float>, outVertices:Vector<Float>, outIndices:Vector<Int>):Bool
	{
		var polygon = copyContour(contour);
		if (signedArea(polygon) < 0)
		{
			reverseContour(polygon);
		}

		var numVertices = polygon.length >> 1;
		if (numVertices < 3)
		{
			return false;
		}

		var vertexOffset = outVertices.length >> 1;
		for (i in 0...polygon.length)
		{
			outVertices.push(polygon[i]);
		}

		var available = [];
		for (i in 0...numVertices)
		{
			available.push(i);
		}

		var guard = numVertices * numVertices;
		while (available.length > 3 && guard-- > 0)
		{
			var earFound = false;

			for (i in 0...available.length)
			{
				var prevIndex = available[(i + available.length - 1) % available.length];
				var currIndex = available[i];
				var nextIndex = available[(i + 1) % available.length];

				if (!isEar(polygon, available, prevIndex, currIndex, nextIndex))
				{
					continue;
				}

				outIndices.push(vertexOffset + prevIndex);
				outIndices.push(vertexOffset + currIndex);
				outIndices.push(vertexOffset + nextIndex);
				available.splice(i, 1);
				earFound = true;
				break;
			}

			if (!earFound)
			{
				return false;
			}
		}

		if (available.length != 3)
		{
			return false;
		}

		outIndices.push(vertexOffset + available[0]);
		outIndices.push(vertexOffset + available[1]);
		outIndices.push(vertexOffset + available[2]);
		return true;
	}

	private static function copyContour(contour:Vector<Float>):Vector<Float>
	{
		var copy = new Vector<Float>();
		for (i in 0...contour.length)
		{
			copy.push(contour[i]);
		}
		return copy;
	}

	private static function cubicFlatnessSq(x0:Float, y0:Float, x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Float
	{
		return Math.max(distanceToSegmentSq(x1, y1, x0, y0, x3, y3), distanceToSegmentSq(x2, y2, x0, y0, x3, y3));
	}

	private static function distanceToSegmentSq(px:Float, py:Float, ax:Float, ay:Float, bx:Float, by:Float):Float
	{
		var dx = bx - ax;
		var dy = by - ay;
		var lengthSq = dx * dx + dy * dy;

		if (lengthSq <= COLLINEAR_EPSILON)
		{
			var sx = px - ax;
			var sy = py - ay;
			return sx * sx + sy * sy;
		}

		var t = ((px - ax) * dx + (py - ay) * dy) / lengthSq;
		t = t < 0 ? 0 : (t > 1 ? 1 : t);
		var cx = ax + dx * t;
		var cy = ay + dy * t;
		dx = px - cx;
		dy = py - cy;
		return dx * dx + dy * dy;
	}

	private static function hasNestedContours(contours:Array<Vector<Float>>):Bool
	{
		for (i in 0...contours.length)
		{
			for (j in i + 1...contours.length)
			{
				if (contourContainsPoint(contours[i], contours[j][0], contours[j][1]) || contourContainsPoint(contours[j], contours[i][0], contours[i][1]))
				{
					return true;
				}
			}
		}

		return false;
	}

	private static function hasSelfIntersection(contour:Vector<Float>):Bool
	{
		var count = contour.length >> 1;
		for (i in 0...count)
		{
			var ax = contour[i * 2];
			var ay = contour[i * 2 + 1];
			var bx = contour[((i + 1) % count) * 2];
			var by = contour[((i + 1) % count) * 2 + 1];

			for (j in i + 1...count)
			{
				if (j == i || j == (i + 1) % count || (j + 1) % count == i)
				{
					continue;
				}

				var cx = contour[j * 2];
				var cy = contour[j * 2 + 1];
				var dx = contour[((j + 1) % count) * 2];
				var dy = contour[((j + 1) % count) * 2 + 1];

				if (segmentsIntersect(ax, ay, bx, by, cx, cy, dx, dy))
				{
					return true;
				}
			}
		}

		return false;
	}

	private static function isEar(polygon:Vector<Float>, available:Array<Int>, prevIndex:Int, currIndex:Int, nextIndex:Int):Bool
	{
		var ax = polygon[prevIndex * 2];
		var ay = polygon[prevIndex * 2 + 1];
		var bx = polygon[currIndex * 2];
		var by = polygon[currIndex * 2 + 1];
		var cx = polygon[nextIndex * 2];
		var cy = polygon[nextIndex * 2 + 1];

		if (cross(ax, ay, bx, by, cx, cy) <= COLLINEAR_EPSILON)
		{
			return false;
		}

		for (index in available)
		{
			if (index == prevIndex || index == currIndex || index == nextIndex)
			{
				continue;
			}

			if (pointInTriangle(polygon[index * 2], polygon[index * 2 + 1], ax, ay, bx, by, cx, cy))
			{
				return false;
			}
		}

		return true;
	}

	private static function normalizeContour(source:Vector<Float>):Vector<Float>
	{
		if (source == null || source.length < 6)
		{
			return null;
		}

		var contour = new Vector<Float>();
		for (i in 0...Std.int(source.length / 2))
		{
			pushPoint(contour, source[i * 2], source[i * 2 + 1]);
		}

		var count = contour.length >> 1;
		if (count >= 2)
		{
			var lastX = contour[(count - 1) * 2];
			var lastY = contour[(count - 1) * 2 + 1];
			var firstX = contour[0];
			var firstY = contour[1];
			if (almostEqual(lastX, firstX) && almostEqual(lastY, firstY))
			{
				contour.pop();
				contour.pop();
			}
		}

		removeCollinearPoints(contour);
		return contour.length >= 6 ? contour : null;
	}

	private static function pointInTriangle(px:Float, py:Float, ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float):Bool
	{
		var ab = cross(ax, ay, bx, by, px, py);
		var bc = cross(bx, by, cx, cy, px, py);
		var ca = cross(cx, cy, ax, ay, px, py);
		return ab >= -COLLINEAR_EPSILON && bc >= -COLLINEAR_EPSILON && ca >= -COLLINEAR_EPSILON;
	}

	private static function contourContainsPoint(contour:Vector<Float>, px:Float, py:Float):Bool
	{
		var inside = false;
		var count = contour.length >> 1;
		var j = count - 1;

		for (i in 0...count)
		{
			var ix = contour[i * 2];
			var iy = contour[i * 2 + 1];
			var jx = contour[j * 2];
			var jy = contour[j * 2 + 1];

			if (((iy > py) != (jy > py)) && (px < (jx - ix) * (py - iy) / (jy - iy) + ix))
			{
				inside = !inside;
			}

			j = i;
		}

		return inside;
	}

	private static function populateBitmapUvt(vertices:Vector<Float>, bitmap:BitmapData, bitmapMatrix:Matrix, result:Vector<Float>):Void
	{
		if (bitmapMatrix == null)
		{
			result.length = vertices.length;
			var minX = vertices[0];
			var maxX = minX;
			var minY = vertices[1];
			var maxY = minY;
			var i = 2;
			var length = vertices.length;
			while (i < length)
			{
				var x = vertices[i];
				if (minX > x) minX = x;
				else if (maxX < x) maxX = x;
				var y = vertices[i + 1];
				if (minY > y) minY = y;
				else if (maxY < y) maxY = y;
				i += 2;
			}
			var trianglesWidth = maxX - minX;
			var trianglesHeight = maxY - minY;
			i = 0;
			while (i < length)
			{
				result[i] = trianglesWidth * (vertices[i] / trianglesWidth) / bitmap.width;
				result[i + 1] = trianglesHeight * (vertices[i + 1] / trianglesHeight) / bitmap.height;
				i += 2;
			}
			return;
		}

		var inverse = bitmapMatrix.clone();
		inverse.invert();
		result.length = vertices.length;

		var i = 0;
		var length = vertices.length;
		while (i < length)
		{
			var tx = inverse.a * vertices[i] + inverse.c * vertices[i + 1] + inverse.tx;
			var ty = inverse.b * vertices[i] + inverse.d * vertices[i + 1] + inverse.ty;
			result[i] = tx / bitmap.width;
			result[i + 1] = ty / bitmap.height;
			i += 2;
		}
	}

	private static function pushPoint(contour:Vector<Float>, x:Float, y:Float):Void
	{
		var length = contour.length;
		if (length >= 2 && almostEqual(contour[length - 2], x) && almostEqual(contour[length - 1], y))
		{
			return;
		}

		contour.push(x);
		contour.push(y);
	}

	private static function quadraticFlatnessSq(x0:Float, y0:Float, x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		return distanceToSegmentSq(x1, y1, x0, y0, x2, y2);
	}

	private static function removeCollinearPoints(contour:Vector<Float>):Void
	{
		var changed = true;
		while (changed && contour.length >= 6)
		{
			changed = false;
			var count = contour.length >> 1;

			for (i in 0...count)
			{
				var prev = (i + count - 1) % count;
				var next = (i + 1) % count;
				var ax = contour[prev * 2];
				var ay = contour[prev * 2 + 1];
				var bx = contour[i * 2];
				var by = contour[i * 2 + 1];
				var cx = contour[next * 2];
				var cy = contour[next * 2 + 1];

				if (Math.abs(cross(ax, ay, bx, by, cx, cy)) <= COLLINEAR_EPSILON
					&& isPointOnSegment(bx, by, ax, ay, cx, cy))
				{
					contour.splice(i * 2, 2);
					changed = true;
					break;
				}
			}
		}
	}

	private static function reverseContour(contour:Vector<Float>):Void
	{
		var reversed = new Vector<Float>();
		var count = contour.length >> 1;
		for (i in 0...count)
		{
			var index = count - 1 - i;
			reversed.push(contour[index * 2]);
			reversed.push(contour[index * 2 + 1]);
		}

		contour.length = 0;
		for (i in 0...reversed.length)
		{
			contour.push(reversed[i]);
		}
	}

	private static function segmentsIntersect(ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float, dx:Float, dy:Float):Bool
	{
		var ab1 = cross(ax, ay, bx, by, cx, cy);
		var ab2 = cross(ax, ay, bx, by, dx, dy);
		var cd1 = cross(cx, cy, dx, dy, ax, ay);
		var cd2 = cross(cx, cy, dx, dy, bx, by);

		if (((ab1 > 0 && ab2 < 0) || (ab1 < 0 && ab2 > 0)) && ((cd1 > 0 && cd2 < 0) || (cd1 < 0 && cd2 > 0)))
		{
			return true;
		}

		return (Math.abs(ab1) <= COLLINEAR_EPSILON && isPointOnSegment(cx, cy, ax, ay, bx, by))
			|| (Math.abs(ab2) <= COLLINEAR_EPSILON && isPointOnSegment(dx, dy, ax, ay, bx, by))
			|| (Math.abs(cd1) <= COLLINEAR_EPSILON && isPointOnSegment(ax, ay, cx, cy, dx, dy))
			|| (Math.abs(cd2) <= COLLINEAR_EPSILON && isPointOnSegment(bx, by, cx, cy, dx, dy));
	}

	private static function signedArea(contour:Vector<Float>):Float
	{
		var area = 0.0;
		var count = contour.length >> 1;
		for (i in 0...count)
		{
			var next = (i + 1) % count;
			area += contour[i * 2] * contour[next * 2 + 1] - contour[next * 2] * contour[i * 2 + 1];
		}
		return area * 0.5;
	}

	private static inline function almostEqual(a:Float, b:Float):Bool
	{
		return Math.abs(a - b) <= CONTOUR_EPSILON;
	}

	private static inline function cross(ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float):Float
	{
		return (bx - ax) * (cy - ay) - (by - ay) * (cx - ax);
	}

	private static inline function isPointOnSegment(px:Float, py:Float, ax:Float, ay:Float, bx:Float, by:Float):Bool
	{
		return px >= Math.min(ax, bx) - CONTOUR_EPSILON
			&& px <= Math.max(ax, bx) + CONTOUR_EPSILON
			&& py >= Math.min(ay, by) - CONTOUR_EPSILON
			&& py <= Math.max(ay, by) + CONTOUR_EPSILON;
	}

}

class GraphicsTessellatedFillPart
{
	public var fill(default, null):Null<Int>;
	public var bitmap(default, null):Null<BitmapData>;
	public var bitmapMatrix(default, null):Null<Matrix>;
	public var smooth(default, null):Bool;
	public var repeat(default, null):Bool;
	public var uvtData(default, null):Null<Vector<Float>>;
	public var indices(default, null):Vector<Int>;
	public var vertices(default, null):Vector<Float>;

	public function new(vertices:Vector<Float>, indices:Vector<Int>, fill:Null<Int> = null, ?bitmap:BitmapData,
			?bitmapMatrix:Matrix, ?smooth:Bool, ?repeat:Bool, ?uvtData:Vector<Float>)
	{
		this.vertices = vertices;
		this.indices = indices;
		this.fill = fill;
		this.bitmap = bitmap;
		this.bitmapMatrix = bitmapMatrix;
		this.smooth = smooth;
		this.repeat = repeat;
		this.uvtData = uvtData;
	}
}
#end
