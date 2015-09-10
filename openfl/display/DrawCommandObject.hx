package openfl.display;
import openfl.Vector;
import openfl.geom.Matrix;

/**
 * ...
 * @author larsiusprime
 */
class DrawCommandObject
{

	public function new(command:DrawCommandType) 
	{
		this.command = command;
	}
	
	public var command:DrawCommandType;
	
	public var bitmap:BitmapData;
	public var matrix:Matrix;
	public var repeat:Bool;
	public var smooth:Bool;
	public var color:Null<Int>;
	public var alpha:Null<Float>;
	public var type:GradientType;
	public var vColors:Vector<Int>;
	public var colors:Array<Dynamic>;
	public var alphas:Array<Dynamic>;
	public var ratios:Array<Dynamic>;
	public var spreadMethod:Null<SpreadMethod>;
	public var interpolationMethod:Null<InterpolationMethod>;
	public var focalPointRatio:Null<Float>;
	public var controlX1:Float;
	public var controlY1:Float;
	public var controlX2:Float;
	public var controlY2:Float;
	public var anchorX:Float;
	public var anchorY:Float;
	public var controlX:Float;
	public var controlY:Float;
	public var x:Float;
	public var y:Float;
	public var radius:Float;
	public var width:Float;
	public var height:Float;
	public var rx:Float;
	public var ry:Float;
	public var sheet:Tilesheet;
	public var tileData:Array<Float>;
	public var flags:Int;
	public var count:Int;
	public var vertices:Vector<Float>;
	public var indices:Vector<Int>;
	public var uvtData:Vector<Float>;
	public var culling:TriangleCulling;
	public var blendMode:Int;
	public var thickness:Null<Float>;
	public var pixelHinting:Null<Bool>;
	public var scaleMode:LineScaleMode;
	public var caps:CapsStyle;
	public var joints:JointStyle;
	public var miterLimit:Null<Float>;
	public var commands:Vector<Int>;
	public var data:Vector<Float>;
	public var winding:GraphicsPathWinding;
	
	public static function BeginBitmapFill(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool):DrawCommandObject
	{
		var c = new DrawCommandObject(BEGIN_BITMAP_FILL);
		c.bitmap = bitmap;
		c.matrix = matrix;
		c.repeat = repeat;
		c.smooth = smooth;
		return c;
	}
	
	public static function BeginFill (color:Int, alpha:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(BEGIN_FILL);
		c.color = color;
		c.alpha = alpha;
		return c;
	}
	
	public static function BeginGradientFill (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix, spreadMethod:Null<SpreadMethod>, interpolationMethod:Null<InterpolationMethod>, focalPointRatio:Null<Float>):DrawCommandObject
	{
		var c = new DrawCommandObject(BEGIN_GRADIENT_FILL);
		c.type = type;
		c.colors = colors;
		c.alphas = alphas;
		c.ratios = ratios;
		c.matrix = matrix;
		c.spreadMethod = spreadMethod;
		c.interpolationMethod = interpolationMethod;
		c.focalPointRatio = focalPointRatio;
		return c;
	}
	
	public static function CubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(CUBIC_CURVE_TO);
		c.controlX1 = controlX1;
		c.controlY1 = controlY1;
		c.controlX2 = controlX2;
		c.controlY2 = controlY2;
		c.anchorX = anchorX;
		c.anchorY = anchorY;
		return c;
	}
	
	public static function CurveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(CURVE_TO);
		c.controlX = controlX;
		c.controlY = controlY;
		c.anchorX = anchorX;
		c.anchorY = anchorY;
		return c;
	}
	
	public static function DrawCircle (x:Float, y:Float, radius:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(DRAW_CIRCLE);
		c.x = x;
		c.y = y;
		c.radius = radius;
		return c;
	}
	
	public static function DrawEllipse (x:Float, y:Float, width:Float, height:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(DRAW_ELLIPSE);
		c.x = x;
		c.y = y;
		c.width = width;
		c.height = height;
		return c;
	}
	
	public static function DrawRect (x:Float, y:Float, width:Float, height:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(DRAW_RECT);
		c.x = x;
		c.y = y;
		c.width = width;
		c.height = height;
		return c;
	}
	
	public static function DrawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(DRAW_ROUND_RECT);
		c.x = x;
		c.y = y;
		c.width = width;
		c.height = height;
		c.rx = rx;
		c.ry = ry;
		return c;
	}
	
	public static function DrawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int):DrawCommandObject
	{
		var c = new DrawCommandObject(DRAW_TILES);
		c.sheet = sheet;
		c.tileData = tileData;
		c.smooth = smooth;
		c.flags = flags;
		c.count = count;
		return c;
	}
	
	public static function DrawTriangles (vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling, colors:Vector<Int>, blendMode:Int):DrawCommandObject
	{
		var c = new DrawCommandObject(DRAW_TRIANGLES);
		c.vertices = vertices;
		c.indices = indices;
		c.uvtData = uvtData;
		c.culling = culling;
		c.vColors = colors;
		c.blendMode = blendMode;
		return c;
	}
	
	public static function EndFill():DrawCommandObject
	{
		return new DrawCommandObject(END_FILL);
	}
	
	public static function LineStyle (thickness:Null<Float>, color:Null<Int>, alpha:Null<Float>, pixelHinting:Null<Bool>, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Null<Float>):DrawCommandObject
	{
		var c = new DrawCommandObject(LINE_STYLE);
		c.thickness = thickness;
		c.color = color;
		c.alpha = alpha;
		c.pixelHinting = pixelHinting;
		c.scaleMode = scaleMode;
		c.caps = caps;
		c.joints = joints;
		c.miterLimit = miterLimit;
		return c;
	}
	
	public static function LineBitmapStyle (bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool):DrawCommandObject
	{
		var c = new DrawCommandObject(LINE_BITMAP_STYLE);
		c.bitmap = bitmap;
		c.matrix = matrix;
		c.repeat = repeat;
		c.smooth = smooth;
		return c;
	}
	
	public static function LineGradientStyle (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix, spreadMethod:Null<SpreadMethod>, interpolationMethod:Null<InterpolationMethod>, focalPointRatio:Null<Float>):DrawCommandObject
	{
		var c = new DrawCommandObject(LINE_GRADIENT_STYLE);
		c.type = type;
		c.colors = colors;
		c.alphas = alphas;
		c.ratios = ratios;
		c.matrix = matrix;
		c.spreadMethod = spreadMethod;
		c.interpolationMethod = interpolationMethod;
		c.focalPointRatio = focalPointRatio;
		return c;
	}
	
	public static function LineTo (x:Float, y:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(LINE_TO);
		c.x = x;
		c.y = y;
		return c;
	}
	
	public static function MoveTo (x:Float, y:Float):DrawCommandObject
	{
		var c = new DrawCommandObject(MOVE_TO);
		c.x = x;
		c.y = y;
		return c;
	}
	
	public static function DrawPathC (commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding):DrawCommandObject
	{
		var c = new DrawCommandObject(DRAW_PATH_C);
		c.commands = commands;
		c.data = data;
		c.winding = winding;
		return c;
	}
	
	public static function OverrideMatrix (matrix:Matrix):DrawCommandObject
	{
		var c = new DrawCommandObject(OVERRIDE_MATRIX);
		c.matrix = matrix;
		return c;
	}
}