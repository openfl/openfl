package flash.display; #if (!display && flash)


import openfl._internal.renderer.flash.FlashGraphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;


@:final extern class Graphics {
	
	
	@:native("beginBitmapFill") @:noCompletion private function __beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	public inline function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		
		FlashGraphics.lastBitmapFill = bitmap;
		this.__beginBitmapFill (bitmap, matrix, repeat, smooth);
		
	}
	
	@:native("beginFill") @:noCompletion private function __beginFill (color:UInt = 0, alpha:Float = 1):Void;
	public inline function beginFill (color:UInt = 0, alpha:Float = 1):Void {
		
		FlashGraphics.lastBitmapFill = null;
		this.__beginFill (color, alpha);
		
	}
	
	@:native("beginGradientFill") @:noCompletion private function __beginGradientFill (type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, ?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Null<Float> = null):Void;
	public inline function beginGradientFill (type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, ?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Null<Float> = null):Void {
		
		FlashGraphics.lastBitmapFill = null;
		this.__beginGradientFill (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		
	}
	
	#if flash
	@:native("beginShaderFill") @:require(flash10) private function __beginShaderFill (shader:Shader, matrix:Matrix = null):Void;
	@:require(flash10) public inline function beginShaderFill (shader:Shader, matrix:Matrix = null):Void {
		
		FlashGraphics.lastBitmapFill = null;
		this.__beginShaderFill (shader, matrix);
		
	}
	#end
	
	public function clear ():Void;
	
	@:require(flash10) public function copyFrom (sourceGraphics:Graphics):Void;
	@:require(flash11) public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void;
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void;
	public function drawCircle (x:Float, y:Float, radius:Float):Void;
	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void;
	@:require(flash10) public function drawGraphicsData (graphicsData:Vector<IGraphicsData>):Void;
	@:require(flash10) public function drawPath (commands:Vector<Int>, data:Vector<Float>, ?winding:GraphicsPathWinding):Void;
	
	public inline function drawQuads (matrices:Vector<Float>, sourceRects:Vector<Float> = null, rectIndices:Vector<Int> = null):Void {
		
		FlashGraphics.drawQuads (this, matrices, sourceRects, rectIndices);
		
	}
	
	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void;
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Null<Float> = null):Void;
	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void;
	@:require(flash10) public function drawTriangles (vertices:Vector<Float>, ?indices:Vector<Int> = null, ?uvtData:Vector<Float> = null, ?culling:TriangleCulling):Void;
	
	@:native("endFill") @:noCompletion private function __endFill ():Void;
	public inline function endFill ():Void {
		
		FlashGraphics.lastBitmapFill = null;
		this.__endFill ();
		
	}

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