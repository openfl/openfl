package openfl.display; #if !openfl_legacy


import lime.graphics.Image;
import lime.graphics.GLRenderContext;
import format.swf.exporters.core.ShapeCommand;
import format.swf.lite.symbols.ShapeSymbol;
import format.swf.lite.symbols.SWFSymbol;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.DrawCommandBuffer;
import openfl._internal.renderer.opengl.utils.RenderTexture;
import openfl.display.Shader;
import openfl.errors.ArgumentError;
import openfl.display.GraphicsPathCommand;
import openfl.display.GraphicsBitmapFill;
import openfl.display.GraphicsEndFill;
import openfl.display.GraphicsGradientFill;
import openfl.display.GraphicsPath;
import openfl.display.GraphicsSolidFill;
import openfl.display.GraphicsStroke;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
#end

@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


@:final class Graphics implements hxbit.Serializable {


	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	public static inline var TILE_TRANS_2x2 = 0x0010;
	public static inline var TILE_RECT = 0x0020;
	public static inline var TILE_ORIGIN = 0x0040;

	public static inline var TILE_BLEND_NORMAL = 0x00000000;
	public static inline var TILE_BLEND_ADD = 0x00010000;
	public static inline var TILE_BLEND_MULTIPLY = 0x00020000;
	public static inline var TILE_BLEND_SCREEN = 0x00040000;
	public static inline var TILE_BLEND_SUBTRACT = 0x00080000;
	public static inline var TILE_BLEND_DARKEN = 0x00100000;
	public static inline var TILE_BLEND_LIGHTEN = 0x00200000;
	public static inline var TILE_BLEND_OVERLAY = 0x00400000;
	public static inline var TILE_BLEND_HARDLIGHT = 0x00800000;
	public static inline var TILE_BLEND_DIFFERENCE = 0x01000000;
	public static inline var TILE_BLEND_INVERT = 0x02000000;

	public var readOnly:Bool;
	public var snapCoordinates (get, never):Bool;
	public var dirty (get, set):Bool;

	@:s private var __bounds:Rectangle;
	@:s private var __commands:DrawCommandBuffer;
	@:s private var __positionX:Float;
	@:s private var __positionY:Float;
	@:s private var __strokePadding:Float;
	@:s private var __visible:Bool;
	private var __dirty:Bool = true;
	private var __owner:DisplayObject;

	#if (js && html5)
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	#end

    public var keepBitmapData = false;
	private var __bitmap(default, set):BitmapData;
	@:s private var __symbol:SWFSymbol;

	private function new (?initCommands = true) {

		__commands = initCommands ? new DrawCommandBuffer () : null;
		__strokePadding = 0;
		__positionX = 0;
		__positionY = 0;

		#if (js && html5)
		if(__commands != null) {
			moveTo (0, 0);
		}
		#end

	}

	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {

		if ( readOnly ) {
			throw "don't fill readonly!";
		}
		__commands.beginBitmapFill(bitmap, matrix != null ? matrix.clone () : null, repeat, smooth);

		__visible = true;

	}

	public function beginBitmapFillWithId (bitmapID:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {

		__commands.beginBitmapFillWithId (bitmapID, matrix, repeat, smooth);
		__visible = true;
	}

	public function drawImageWithId (bitmapID:Int, matrix:Matrix, smooth:Bool) {

		var p = Point.pool.get ();

		__inflateBounds (matrix.tx, matrix.ty);

		inline function inflateTransformedCorner(x:Float, y:Float) {

			p.x = x;
			p.y = y;
			matrix.__transformPoint(p);
			__inflateBounds (p.x, p.y);

		}

		inflateTransformedCorner (0.0, 1.0);
		inflateTransformedCorner (1.0, 0.0);
		inflateTransformedCorner (1.0, 1.0);

		__commands.drawImageWithId (bitmapID, matrix, smooth);
		__visible = true;

		Point.pool.put (p);

	}


	public function beginFill (color:Int = 0, alpha:Float = 1):Void {

		if ( readOnly ) {
			throw "don't fill readonly!";
		}
		__commands.beginFill (color & 0xFFFFFF, alpha);

		__visible = true;

	}


	public function beginGradientFill (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = SpreadMethod.PAD, interpolationMethod:InterpolationMethod = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {

		if ( readOnly ) {
			throw "don't fill readonly!";
		}
		__commands.beginGradientFill (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);

		for (alpha in alphas) {

			if (alpha > 0) {

				__visible = true;
				break;

			}

		}

	}


	public function clear ():Void {

		if ( readOnly ) {
			__commands = new DrawCommandBuffer();
			readOnly = false;
		} else {
			__commands.clear();
		}
		__strokePadding = 0;

		if (__bounds != null) {

			dirty = true;
			__bounds = null;

		}

		__visible = false;

		#if (js && html5)
		moveTo (0, 0);
		#end

	}


	public function copyFrom (sourceGraphics:Graphics, shallowCopy:Bool = false):Void {

		if (shallowCopy) {

			__bounds = sourceGraphics.__bounds;
			__commands = sourceGraphics.__commands;

		} else {

			__bounds = sourceGraphics.__bounds != null ? sourceGraphics.__bounds.clone () : null;
			__commands = sourceGraphics.__commands.copy ();

		}
		dirty = true;
		__strokePadding = sourceGraphics.__strokePadding;
		__positionX = sourceGraphics.__positionX;
		__positionY = sourceGraphics.__positionY;
		__visible = sourceGraphics.__visible;
		__symbol = sourceGraphics.__symbol;

	}


	public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {

		__inflateBounds (__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds (__positionX + __strokePadding, __positionY + __strokePadding);

		var ix1, iy1, ix2, iy2;

		ix1 = anchorX;
		ix2 = anchorX;

		if (!(((controlX1 < anchorX && controlX1 > __positionX) || (controlX1 > anchorX && controlX1 < __positionX)) && ((controlX2 < anchorX && controlX2 > __positionX) || (controlX2 > anchorX && controlX2 < __positionX)))) {

			var u = (2 * __positionX - 4 * controlX1 + 2 * controlX2);
			var v = (controlX1 - __positionX);
			var w = (-__positionX + 3 * controlX1 + anchorX - 3 * controlX2);

			var t1 = (-u + Math.sqrt (u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt (u * u - 4 * v * w)) / (2 * w);

			if (t1 > 0 && t1 < 1) {

				ix1 = __calculateBezierCubicPoint (t1, __positionX, controlX1, controlX2, anchorX);

			}

			if (t2 > 0 && t2 < 1) {

				ix2 = __calculateBezierCubicPoint (t2, __positionX, controlX1, controlX2, anchorX);

			}

		}

		iy1 = anchorY;
		iy2 = anchorY;

		if (!(((controlY1 < anchorY && controlY1 > __positionX) || (controlY1 > anchorY && controlY1 < __positionX)) && ((controlY2 < anchorY && controlY2 > __positionX) || (controlY2 > anchorY && controlY2 < __positionX)))) {

			var u = (2 * __positionX - 4 * controlY1 + 2 * controlY2);
			var v = (controlY1 - __positionX);
			var w = (-__positionX + 3 * controlY1 + anchorY - 3 * controlY2);

			var t1 = (-u + Math.sqrt (u * u - 4 * v * w)) / (2 * w);
			var t2 = (-u - Math.sqrt (u * u - 4 * v * w)) / (2 * w);

			if (t1 > 0 && t1 < 1) {

				iy1 = __calculateBezierCubicPoint (t1, __positionX, controlY1, controlY2, anchorY);

			}

			if (t2 > 0 && t2 < 1) {

				iy2 = __calculateBezierCubicPoint (t2, __positionX, controlY1, controlY2, anchorY);

			}

		}

		__inflateBounds (ix1 - __strokePadding, iy1 - __strokePadding);
		__inflateBounds (ix1 + __strokePadding, iy1 + __strokePadding);
		__inflateBounds (ix2 - __strokePadding, iy2 - __strokePadding);
		__inflateBounds (ix2 + __strokePadding, iy2 + __strokePadding);

		__positionX = anchorX;
		__positionY = anchorY;

		__commands.cubicCurveTo (controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);

		dirty = true;

	}


	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {

		__inflateBounds (__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds (__positionX + __strokePadding, __positionY + __strokePadding);

		var ix, iy;

		if ((controlX < anchorX && controlX > __positionX) || (controlX > anchorX && controlX < __positionX)) {

			ix = anchorX;

		} else {

			var tx = ((__positionX - controlX) / (__positionX - 2 * controlX + anchorX));
			ix = __calculateBezierQuadPoint (tx, __positionX, controlX, anchorX);

		}

		if ((controlY < anchorY && controlY > __positionY) || (controlY > anchorY && controlY < __positionY)) {

			iy = anchorY;

		} else {

			var ty = ((__positionY - controlY) / (__positionY - (2 * controlY) + anchorY));
			iy = __calculateBezierQuadPoint (ty, __positionY, controlY, anchorY);

		}

		__inflateBounds (ix - __strokePadding, iy - __strokePadding);
		__inflateBounds (ix + __strokePadding, iy + __strokePadding);

		__positionX = anchorX;
		__positionY = anchorY;

		__commands.curveTo (controlX, controlY, anchorX, anchorY);

		dirty = true;

	}


	public function drawCircle (x:Float, y:Float, radius:Float):Void {

		if (radius <= 0) return;

		__inflateBounds (x - radius - __strokePadding, y - radius - __strokePadding);
		__inflateBounds (x + radius + __strokePadding, y + radius + __strokePadding);

		__commands.drawCircle (x, y, radius);

		dirty = true;

	}


	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void {

		if (width <= 0 || height <= 0) return;

		__inflateBounds (x - __strokePadding, y - __strokePadding);
		__inflateBounds (x + width + __strokePadding, y + height + __strokePadding);

		__commands.drawEllipse (x, y, width, height);

		dirty = true;

	}


	public function drawGraphicsData (graphicsData:Vector<IGraphicsData>):Void {

		var fill:GraphicsSolidFill;
		var bitmapFill:GraphicsBitmapFill;
		var gradientFill:GraphicsGradientFill;
		var stroke:GraphicsStroke;
		var path:GraphicsPath;

		for (graphics in graphicsData) {

			if (Std.is (graphics, GraphicsSolidFill)) {

				fill = cast graphics;
				beginFill (fill.color, fill.alpha);

			} else if (Std.is (graphics, GraphicsBitmapFill)) {

				bitmapFill = cast graphics;
				beginBitmapFill (bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);

			} else if (Std.is (graphics, GraphicsGradientFill)) {

				gradientFill = cast graphics;
				beginGradientFill (gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix, gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);

			} else if (Std.is (graphics, GraphicsStroke)) {

				stroke = cast graphics;

				if (Std.is (stroke.fill, GraphicsSolidFill)) {

					fill = cast stroke.fill;
					lineStyle (stroke.thickness, fill.color, fill.alpha, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);

				} else {

					lineStyle (stroke.thickness, 0, 1, stroke.pixelHinting, stroke.scaleMode, stroke.caps, stroke.joints, stroke.miterLimit);

					if (Std.is (stroke.fill, GraphicsBitmapFill)) {

						bitmapFill = cast stroke.fill;
						lineBitmapStyle (bitmapFill.bitmapData, bitmapFill.matrix, bitmapFill.repeat, bitmapFill.smooth);

					} else if (Std.is (stroke.fill, GraphicsGradientFill)) {

						gradientFill = cast stroke.fill;
						lineGradientStyle (gradientFill.type, gradientFill.colors, gradientFill.alphas, gradientFill.ratios, gradientFill.matrix, gradientFill.spreadMethod, gradientFill.interpolationMethod, gradientFill.focalPointRatio);

					}

				}

			} else if (Std.is (graphics, GraphicsPath)) {

				path = cast graphics;
				drawPath (path.commands, path.data, path.winding);

			} else if (Std.is (graphics, GraphicsEndFill)) {

				endFill ();

			}

		}

	}


	public function drawPath (commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding = GraphicsPathWinding.EVEN_ODD):Void {

		var dataIndex = 0;

		for (command in commands) {

			switch (command) {

				case GraphicsPathCommand.MOVE_TO:

					moveTo (data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;

				case GraphicsPathCommand.LINE_TO:

					lineTo (data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;

				case GraphicsPathCommand.WIDE_MOVE_TO:

					moveTo(data[dataIndex + 2], data[dataIndex + 3]); break;
					dataIndex += 4;

				case GraphicsPathCommand.WIDE_LINE_TO:

					lineTo(data[dataIndex + 2], data[dataIndex + 3]); break;
					dataIndex += 4;

				case GraphicsPathCommand.CURVE_TO:

					curveTo (data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3]);
					dataIndex += 4;

				case GraphicsPathCommand.CUBIC_CURVE_TO:

					cubicCurveTo (data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3], data[dataIndex + 4], data[dataIndex + 5]);
					dataIndex += 6;

				default:

			}

		}

	}


	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void {

		if (width <= 0 || height <= 0) return;

		__inflateBounds (x - __strokePadding, y - __strokePadding);
		__inflateBounds (x + width + __strokePadding, y + height + __strokePadding);

		__commands.drawRect (x, y, width, height);

		dirty = true;

	}


	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float> = null):Void {

		if (width <= 0 || height <= 0) return;

		__inflateBounds (x - __strokePadding, y - __strokePadding);
		__inflateBounds (x + width + __strokePadding, y + height + __strokePadding);

		__commands.drawRoundRect (x, y, width, height, ellipseWidth, ellipseHeight);

		dirty = true;

	}


	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void {

		openfl.Lib.notImplemented ("Graphics.drawRoundRectComplex");

	}


	public function drawTriangles (vertices:Vector<Float>, indices:Vector<Int> = null, uvtData:Vector<Float> = null, culling:TriangleCulling = TriangleCulling.NONE):Void {

		var vlen = Std.int (vertices.length / 2);

		if (culling == null) {

			culling = NONE;

		}

		if (indices == null) {

			if (vlen % 3 != 0) {

				throw new ArgumentError ("Not enough vertices to close a triangle.");

			}

			indices = new Vector<Int> ();

			for (i in 0...vlen) {

				indices.push (i);

			}

		}

		__inflateBounds (0, 0);

		var tmpx = Math.NEGATIVE_INFINITY;
		var tmpy = Math.NEGATIVE_INFINITY;
		var maxX = Math.NEGATIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;

		for (i in 0...vlen) {

			tmpx = vertices[i * 2];
			tmpy = vertices[i * 2 + 1];
			if (maxX < tmpx) maxX = tmpx;
			if (maxY < tmpy) maxY = tmpy;

		}

		__inflateBounds (maxX, maxY);
		__commands.drawTriangles (vertices, indices, uvtData, culling);

		dirty = true;
		__visible = true;

	}


	public function endFill ():Void {

		__commands.endFill();

	}


	public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {

		__commands.lineBitmapStyle (bitmap, matrix != null ? matrix.clone () : null, repeat, smooth);

	}


	public function lineGradientStyle (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = SpreadMethod.PAD, interpolationMethod:InterpolationMethod = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {

		__commands.lineGradientStyle (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);

	}


	public function lineStyle (thickness:Null<Float> = null, color:Int = 0, alpha:Float = 1, pixelHinting:Bool = false, scaleMode:LineScaleMode = LineScaleMode.NORMAL, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3):Void {

		if (thickness != null) {

			if (joints == JointStyle.MITER) {

				if (thickness > __strokePadding) __strokePadding = thickness;

			} else {

				if (thickness / 2 > __strokePadding) __strokePadding = thickness / 2;

			}

		}

		__commands.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);

		if (thickness != null) __visible = true;

	}


	public function lineTo (x:Float, y:Float):Void {

		// TODO: Should we consider the origin instead, instead of inflating in all directions?

		__inflateBounds (__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds (__positionX + __strokePadding, __positionY + __strokePadding);

		__positionX = x;
		__positionY = y;

		__inflateBounds (__positionX - __strokePadding, __positionY - __strokePadding);
		__inflateBounds (__positionX + __strokePadding * 2, __positionY + __strokePadding);

		__commands.lineTo (x, y);

		dirty = true;

	}


	public function moveTo (x:Float, y:Float):Void {

		__positionX = x;
		__positionY = y;

		__commands.moveTo (x, y);

	}


	public function createTextures(gl:GLRenderContext):Void {
		var bitmapDatas = @:privateAccess __commands.bd;
		for(bitmapData in bitmapDatas) {
			bitmapData.getTexture(gl);
		}
	}


	private function __calculateBezierCubicPoint (t:Float, p1:Float, p2:Float, p3:Float, p4:Float):Float {

		var iT = 1 - t;
		return p1 * (iT * iT * iT) + 3 * p2 * t * (iT * iT) + 3 * p3 * iT * (t * t) + p4 * (t * t * t);

	}


	private function __calculateBezierQuadPoint (t:Float, p1:Float, p2:Float, p3:Float):Float {

		var iT = 1 - t;
		return iT * iT * p1 + 2 * iT * t * p2 + t * t * p3;

	}


	private function __getBounds (rect:Rectangle):Void {

		if (__bounds == null) return;

		rect.copyFrom (__bounds);
	}


	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, matrix:Matrix):Bool {

		if (__bounds == null) return false;

		var px = matrix.__transformInverseX (x, y);
		var py = matrix.__transformInverseY (x, y);

		if (__bounds.contains (px, py)) {

			if (shapeFlag) {

				#if (js && html5)
				return CanvasGraphics.hitTest (this, px, py);
				#end

			}

			return true;

		}

		return false;

	}

	private function __inflateBounds (x:Float, y:Float):Void {

		if (__bounds == null) {

			__bounds = new Rectangle (x, y, 0, 0);
			return;

		}

		if (x < __bounds.x) {

			__bounds.width += __bounds.x - x;
			__bounds.x = x;

		}

		if (y < __bounds.y) {

			__bounds.height += __bounds.y - y;
			__bounds.y = y;

		}

		if (x > __bounds.x + __bounds.width) {

			__bounds.width = x - __bounds.x;

		}

		if (y > __bounds.y + __bounds.height) {

			__bounds.height = y - __bounds.y;

		}

	}

	public function dispose ():Void {
		__disposeBitmap();
		dirty = true;
	}

	private inline function __disposeBitmap():Void {
		__bitmap = null;
		__dirty = true;
	}


	// Get & Set Methods




	private function set_dirty (value:Bool):Bool {

		if (value && __owner != null) {

			@:privateAccess __owner.__setRenderDirty();

		}

		return __dirty = value;

	}

	private function get_dirty():Bool {
		return __dirty;
	}

	private function set___bitmap (value:BitmapData):BitmapData {

		if (__bitmap != null && !keepBitmapData && (__symbol == null || !Std.is(__symbol, ShapeSymbol) || !cast(__symbol, ShapeSymbol).useBitmapCache)) {

			__bitmap.dispose ();

		}

		return __bitmap = value;

	}

	public inline function get_snapCoordinates ():Bool {

		return __symbol != null && Std.is(__symbol, ShapeSymbol) && cast(__symbol, ShapeSymbol).snapCoordinates;

	}

}


#else
typedef Graphics = openfl._legacy.display.Graphics;
#end
