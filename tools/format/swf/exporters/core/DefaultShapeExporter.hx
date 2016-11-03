package format.swf.exporters.core;

import format.swf.SWFTimelineContainer;
import flash.display.CapsStyle;
import flash.display.GradientType;
import flash.display.JointStyle;

import flash.display.InterpolationMethod;
import flash.display.LineScaleMode;
import flash.display.SpreadMethod;
import flash.geom.Matrix;

class DefaultShapeExporter implements IShapeExporter
{
	private var swf:SWFTimelineContainer;
	
	public function new(swf:SWFTimelineContainer) {
		this.swf = swf;
	}
	
	public function beginShape():Void {}
	public function endShape():Void {}

	public function beginFills():Void {}
	public function endFills():Void {}

	public function beginLines():Void {}
	public function endLines():Void {}
	
	public function beginFill(color:Int, alpha:Float = 1.0):Void {}
	public function beginGradientFill(type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = null/*SpreadMethod.PAD*/, interpolationMethod:InterpolationMethod = null/*InterpolationMethod.RGB*/, focalPointRatio:Float = 0):Void {}
	public function beginBitmapFill(bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {}
	public function endFill():Void {}
	
	public function lineStyle(thickness:Float = 0/*Math.NaN*/, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:LineScaleMode = null/*LineScaleMode.NORMAL*/, startCaps:CapsStyle = null, endCaps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3):Void {}
	public function lineGradientStyle(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = null/*SpreadMethod.PAD*/, interpolationMethod:InterpolationMethod = null/*InterpolationMethod.RGB*/, focalPointRatio:Float = 0):Void {}

	public function moveTo(x:Float, y:Float):Void {}
	public function lineTo(x:Float, y:Float):Void {}
	public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {}
}