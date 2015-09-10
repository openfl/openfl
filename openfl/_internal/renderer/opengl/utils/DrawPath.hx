package openfl._internal.renderer.opengl.utils;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer.GLStack;
import openfl.display.Graphics;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CapsStyle;
import openfl.display.DisplayObject;
import openfl.display.DrawCommandType;
import openfl.display.Graphics;
import openfl.display.GraphicsPathCommand;
import openfl.display.GraphicsPathWinding;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.TriangleCulling;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.Vector;

class DrawPath {


	public var line:LineStyle;
	public var fill:FillType;
	public var fillIndex:Int = 0;
	public var isRemovable:Bool = true;
	public var winding:WindingRule = WindingRule.EVEN_ODD;

	public var points:Array<Float> = null;

	public var type:GraphicType = Polygon;

	public function new(makeArray:Bool=true) {
		line = new LineStyle();
		fill = None;
		if (makeArray)
		{
			points = [];
		}
	}

	public function update(line:LineStyle, fill:FillType, fillIndex:Int, winding:WindingRule):Void {
		updateLine(line);
		this.fill = fill;
		this.fillIndex = fillIndex;
		this.winding = winding;
	}

	public function updateLine(line:LineStyle):Void {
		this.line.width = line.width;
		this.line.color = line.color;
		this.line.alpha = line.alpha == null ? 1 : line.alpha;
		this.line.scaleMode = line.scaleMode == null ? LineScaleMode.NORMAL : line.scaleMode;
		this.line.caps = line.caps == null ? CapsStyle.ROUND : line.caps;
		this.line.joints = line.joints == null ? JointStyle.ROUND : line.joints;
		this.line.miterLimit = line.miterLimit;
	}

	public static function getStack(graphics:Graphics, gl:GLRenderContext):GLStack {
		return PathBuiler.build(graphics, gl);
	}

}

@:access(openfl._internal.renderer.opengl.utils.GraphicsRenderer)
@:access(openfl.display.Graphics)
class PathBuiler {

	private static var __currentPath:DrawPath;
	private static var __currentWinding:WindingRule = WindingRule.EVEN_ODD;
	private static var __drawPaths:Array<DrawPath>;
	private static var __line:LineStyle;
	private static var __fill:FillType;
	private static var __fillIndex:Int = 0;

	private static function closePath():Void {
		var l = __currentPath.points == null ? 0 : __currentPath.points.length;
		if (l <= 0) return;
		// the paths are only closed when the type is a polygon and there is a fill
		if (__currentPath.type == Polygon && __currentPath.fill != None) {
			var sx = __currentPath.points[0];
			var sy = __currentPath.points[1];
			var ex = __currentPath.points[l - 2];
			var ey = __currentPath.points[l - 1];
			
			if (!(sx == ex && sy == ey)) {
				lineTo(sx, sy);
			}
		}
	}

	private static function endFill ():Void {
		
		__fill = None;
		__fillIndex++;
		
	}

	private static inline function moveTo (x:Float, y:Float) {
		
		graphicDataPop ();
		__currentPath = new DrawPath ();
		__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
		__currentPath.type = Polygon;
		__currentPath.points.push (x);
		__currentPath.points.push (y);
		
		__drawPaths.push (__currentPath);
		
	}
	
	private static inline function lineTo (x:Float, y:Float) {
		var points = __currentPath.points;
		var push_point:Bool = true;

		// Skip duplicate point.
		if (points.length > 1) {
			var lastX = points[points.length-2];
			var lastY = points[points.length-1];
			if (lastX == x && lastY == y) {
				push_point = false;
			}
		}

		if (push_point == true) {
			__currentPath.points.push (x);
			__currentPath.points.push (y);
		}
	}
	
	private static inline function curveTo (cx:Float, cy:Float, x:Float, y:Float) {

		if (__currentPath.points == null || __currentPath.points.length == 0) {
			moveTo (0, 0);
		}
		
		GraphicsPaths.curveTo (__currentPath.points, cx, cy, x, y);

	}
	
	private static inline function cubicCurveTo(cx:Float, cy:Float, cx2:Float, cy2:Float, x:Float, y:Float) {

		if (__currentPath.points == null || __currentPath.points.length == 0) {
			moveTo (0, 0);
		}

		GraphicsPaths.cubicCurveTo (__currentPath.points, cx, cy, cx2, cy2, x, y);
		
	}

	private inline static function graphicDataPop ():Void {
		
		if (__currentPath.isRemovable && ( __currentPath.points == null || __currentPath.points.length == 0)) {
			__drawPaths.pop ();
		} else {
			closePath();
		}
		
	}

	public static function build(graphics:Graphics, gl:GLRenderContext):GLStack {
		
		var glStack:GLStack = null;
		var bounds = graphics.__bounds;
		
		__drawPaths = new Array<DrawPath> ();
		__currentPath = new DrawPath ();
		__line = new LineStyle();
		__fill = None;
		__fillIndex = 0;
		
		glStack = graphics.__glStack[GLRenderer.glContextId];
			
		if (glStack == null) {
			
			glStack = graphics.__glStack[GLRenderer.glContextId] = new GLStack (gl);
			
		}
		
		if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0) {
			
			//glStack = graphics.__glStack[GLRenderer.glContextId] = new GLStack (gl);
			
		} else {
			
			for (c in graphics.__commands) {
				
				switch (c.command) {
					
					case BEGIN_BITMAP_FILL:
						
						endFill();
						__fill = c.bitmap != null ? Texture(c.bitmap, c.matrix, c.repeat, c.smooth) : None;
						
						if (__currentPath.points == null || __currentPath.points.length == 0) {
							graphicDataPop();
							__currentPath = new DrawPath();
							__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
							__currentPath.points = [];
							__currentPath.type = Polygon;
							__drawPaths.push(__currentPath);
						}
					
					case BEGIN_FILL:

						endFill();
						__fill = c.alpha > 0 ? Color(c.color & 0xFFFFFF, c.alpha) : None;

						if (__currentPath.points == null || __currentPath.points.length == 0) {
							graphicDataPop();
							__currentPath = new DrawPath();
							__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
							__currentPath.points = [];
							__currentPath.type = Polygon;
							__drawPaths.push(__currentPath);
						}
					
					case CUBIC_CURVE_TO:
					
						cubicCurveTo (c.controlX1, c.controlY1, c.controlX2, c.controlY2, c.x, c.y);
					
					case CURVE_TO:
					
						curveTo (c.controlX, c.controlY, c.x, c.y);
					
					//case DrawCircle (x, y, radius):
					case DRAW_CIRCLE:
						
						graphicDataPop ();
						
						__currentPath = new DrawPath ();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = Circle;
						__currentPath.points = [ c.x, c.y, c.radius ];
						
						__drawPaths.push (__currentPath);
					
					//case DrawEllipse (x, y, width, height):
					case DRAW_ELLIPSE:
						
						graphicDataPop ();
						
						__currentPath = new DrawPath ();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = Ellipse;
						__currentPath.points = [ c.x, c.y, c.width, c.height ];
						
						__drawPaths.push (__currentPath);
					
					//case DrawRect (x, y, width, height):
					case DRAW_RECT:
						
						graphicDataPop();
						
						__currentPath = new DrawPath ();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = Rectangle (false);
						__currentPath.points = [ c.x, c.y, c.width, c.height ];
						
						__drawPaths.push (__currentPath);
					
					//case DrawRoundRect (x, y, width, height, rx, ry):
					case DRAW_ROUND_RECT:
						
						if (c.ry == -1) c.ry = c.rx;
						
						c.rx *= 0.5;
						c.ry *= 0.5;
						
						if (c.rx > c.width / 2) c.rx = c.width / 2;
						if (c.ry > c.height / 2) c.ry = c.height / 2;
						
						graphicDataPop ();
						
						__currentPath = new DrawPath ();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = Rectangle (true);
						__currentPath.points = [ c.x, c.y, c.width, c.height, c.rx, c.ry ];
						
						__drawPaths.push (__currentPath);
					
					//case EndFill:
					case END_FILL:
						
						endFill ();
					
					//case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
					case LINE_STYLE:
						
						__line = new LineStyle();
						
						if (c.thickness == null || Math.isNaN(c.thickness) || c.thickness < 0) {
							
							__line.width = 0;
							
						} else if (c.thickness == 0) {
							
							__line.width = 1;
							
						} else {
							
							__line.width = c.thickness;
							
						}
						
						graphicDataPop ();
						
						__line.color = c.color == null ? 0 : c.color;
						__line.alpha = c.alpha == null ? 1 : c.alpha;
						__line.scaleMode = c.scaleMode;
						__line.caps = c.caps;
						__line.joints = c.joints;
						__line.miterLimit = c.miterLimit;
						
						__currentPath = new DrawPath ();
						__currentPath.update(__line, __fill, __fillIndex, __currentWinding);
						__currentPath.points = [];
						__currentPath.type = GraphicType.Polygon;
						
						__drawPaths.push (__currentPath);
					
					//case LineTo (x, y):
					case LINE_TO:
						
						lineTo (c.x, c.y);
					
					//case MoveTo (x, y):
					case MOVE_TO:
						
						moveTo(c.x, c.y);
						
					//case DrawTriangles (vertices, indices, uvtData, culling, colors, blendMode):
					case DRAW_TRIANGLES:
						
						var isColor = switch(__fill) { case Color(_, _): true; case _: false; };
						if (isColor && c.uvtData != null) {
								// Flash doesn't draw anything if the fill isn't a bitmap and there are uvt values
								continue;
						}
						
						graphicDataPop ();
						
						__currentPath = new DrawPath ();
						__currentPath.update (__line, __fill, __fillIndex, __currentWinding);
						if (c.uvtData == null) {
							c.uvtData = new Vector<Float>();
							switch(__fill) {
								case Texture(b, _):
									for (i in 0...Std.int(c.vertices.length / 2)) {
										c.uvtData.push(c.vertices[i * 2] / b.width);
										c.uvtData.push(c.vertices[i * 2 + 1] / b.height);
									}
								case _:
							}
						}
						__currentPath.type = GraphicType.DrawTriangles (c.vertices, c.indices, c.uvtData, c.culling, c.vColors, c.blendMode);
						__currentPath.isRemovable = false;
						__drawPaths.push (__currentPath);
					
					//case DrawTiles (sheet, tileData, smooth, flags, count):
					case DRAW_TILES:
						graphicDataPop ();
						
						__fillIndex++;
						__currentPath = new DrawPath (false);
						__currentPath.update (__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = GraphicType.DrawTiles(c.sheet, c.tileData, c.smooth, c.flags, c.count);
						__currentPath.isRemovable = false;
						__drawPaths.push (__currentPath);
							
						
					//case DrawPathC (commands, data, winding):
					case DRAW_PATH_C:
						graphicDataPop ();
						
						switch(c.winding) {
							case GraphicsPathWinding.EVEN_ODD:
								__currentWinding = EVEN_ODD;
							case GraphicsPathWinding.NON_ZERO:
								__currentWinding = NON_ZERO;
							default:
								__currentWinding = EVEN_ODD;
						}
						
						var command:Int;
						var cx:Float, cy:Float;
						var cx2:Float, cy2:Float;
						var ax:Float, ay:Float;
						var idx = 0;
						for (i in 0...c.commands.length) {
							command = c.commands[i];
							switch(command) {
								case GraphicsPathCommand.MOVE_TO:
									ax = c.data[idx + 0];
									ay = c.data[idx + 1];
									idx += 2;
									moveTo(ax, ay);
								case GraphicsPathCommand.WIDE_MOVE_TO:
									ax = c.data[idx + 2];
									ay = c.data[idx + 3];
									idx += 4;
									moveTo(ax, ay);
								case GraphicsPathCommand.LINE_TO:
									ax = c.data[idx + 0];
									ay = c.data[idx + 1];
									idx += 2;
									lineTo(ax, ay);
								case GraphicsPathCommand.WIDE_LINE_TO:
									ax = c.data[idx + 2];
									ay = c.data[idx + 3];
									idx += 4;
									lineTo(ax, ay);
								case GraphicsPathCommand.CURVE_TO:
									cx = c.data[idx + 0];
									cy = c.data[idx + 1];
									ax = c.data[idx + 2];
									ay = c.data[idx + 3];
									idx += 4;
									curveTo(cx, cy, ax, ay);
								case GraphicsPathCommand.CUBIC_CURVE_TO:
									cx  = c.data[idx + 0];
									cy  = c.data[idx + 1];
									cx2 = c.data[idx + 2];
									cy2 = c.data[idx + 3];
									ax  = c.data[idx + 4];
									ay  = c.data[idx + 5];
									idx += 6;
									cubicCurveTo(cx, cy, cx2, cy2, ax, ay);
									
								default:
							}
						}
						
						__currentWinding = EVEN_ODD;
						
					//case OverrideMatrix(m):
					case OVERRIDE_MATRIX:
						graphicDataPop ();
						
						__currentPath = new DrawPath ();
						__currentPath.update (__line, __fill, __fillIndex, __currentWinding);
						__currentPath.type = GraphicType.OverrideMatrix(c.matrix);
						__currentPath.isRemovable = false;
						__drawPaths.push (__currentPath);
					default:
						
				}
				
			}
			
			closePath();
			
		}
		
		graphics.__drawPaths = __drawPaths;
		
		return glStack;
	}

}

class LineStyle {

	public var width:Float;
	public var color:Int;
	public var alpha:Null<Float>;

	public var scaleMode:LineScaleMode;
	public var caps:CapsStyle;
	public var joints:JointStyle;
	public var miterLimit:Float;
	
	public function new() {
		width = 0;
		color = 0;
		alpha = 1;
		scaleMode = LineScaleMode.NORMAL;
		caps = CapsStyle.ROUND;
		joints = JointStyle.ROUND;
		miterLimit = 3;
	}

}

@:enum abstract WindingRule(Int) {
	var EVEN_ODD = 0;
	var NON_ZERO = 1;
}

enum FillType {
	None;
	Color(color:Int, alpha:Float);
	Texture(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool);
	Gradient;
}
