package flash.display; #if (!display && flash)


import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;


@:final extern class Graphics {
	
	
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
	
	
	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	public function beginFill (color:UInt = 0, alpha:Float = 1):Void;
	public function beginGradientFill (type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, ?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Float = 0.0):Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public function beginShaderFill (shader:Shader, matrix:Matrix = null):Void;
	#end
	
	public function clear ():Void;
	
	@:require(flash10) public function copyFrom (sourceGraphics:Graphics):Void;
	@:require(flash11) public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void;
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void;
	public function drawCircle (x:Float, y:Float, radius:Float):Void;
	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void;
	@:require(flash10) public function drawGraphicsData (graphicsData:Vector<IGraphicsData>):Void;
	@:require(flash10) public function drawPath (commands:Vector<Int>, data:Vector<Float>, ?winding:GraphicsPathWinding):Void;
	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void;
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float = -1):Void;
	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void;
	
	
	@:require(flash10) public function drawTriangles (vertices:Vector<Float>, ?indices:Vector<Int> = null, ?uvtData:Vector<Float> = null, ?culling:TriangleCulling, ?colors:Vector<Int>, blendMode:Int = 0):Void;
	public function endFill ():Void;
	@:require(flash10) public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	public function lineGradientStyle (type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, ?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Float = 0.0):Void;
	public function lineStyle (thickness:Null<Float> = null, color:Null<UInt> = null, alpha:Null<Float> = null, pixelHinting:Null<Bool> = null, ?scaleMode:LineScaleMode, ?caps:CapsStyle, ?joints:JointStyle, miterLimit:Null<Float> = 3):Void;
	public function lineTo (x:Float, y:Float):Void;
	public function moveTo (x:Float, y:Float):Void;
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_6) public function readGraphicsData (recurse:Bool = true):Vector<IGraphicsData>;
	#end
	
	
}


#else
typedef Graphics = openfl.display.Graphics;
#end
