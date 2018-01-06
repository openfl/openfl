package flash.display; #if (!display && flash)


import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;


@:final extern class Graphics {
	
	
	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	public function beginFill (color:UInt = 0, alpha:Float = 1):Void;
	public function beginGradientFill (type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, ?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Null<Float> = null):Void;
	
	#if flash
	@:require(flash10) public function beginShaderFill (shader:Shader, matrix:Matrix = null):Void;
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
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float> = null):Void;
	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void;
	@:require(flash10) public function drawTriangles (vertices:Vector<Float>, ?indices:Vector<Int> = null, ?uvtData:Vector<Float> = null, ?culling:TriangleCulling, ?colors:Vector<Int>, blendMode:Int = 0):Void;
	public function endFill ():Void;
	@:require(flash10) public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	public function lineGradientStyle (type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, ?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Null<Float> = null):Void;
	public function lineStyle (thickness:Null<Float> = null, color:Null<UInt> = null, alpha:Null<Float> = null, pixelHinting:Null<Bool> = null, ?scaleMode:LineScaleMode, ?caps:CapsStyle, ?joints:JointStyle, miterLimit:Null<Float> = 3):Void;
	public function lineTo (x:Float, y:Float):Void;
	public function moveTo (x:Float, y:Float):Void;
	@:require(flash11_6) public function readGraphicsData (recurse:Bool = true):Vector<IGraphicsData>;
	
	
}


#else
typedef Graphics = openfl.display.Graphics;
#end