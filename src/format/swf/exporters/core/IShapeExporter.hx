package format.swf.exporters.core;

import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.SpreadMethod;
import flash.geom.Matrix;

interface IShapeExporter
{
	function beginShape():Void;
	function endShape():Void;
	
	function beginFills():Void;
	function endFills():Void;
	
	function beginLines():Void;
	function endLines():Void;
	
	function beginFill(color:Int, alpha:Float = 1.0):Void;
	function beginGradientFill(type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = "pad", interpolationMethod:InterpolationMethod = "rgb", focalPointRatio:Float = 0):Void;
	function beginBitmapFill(bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	function endFill():Void;

	function lineStyle(thickness:Float = Math.NaN, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:LineScaleMode = "normal", startCaps:CapsStyle = null, endCaps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3):Void;
	function lineGradientStyle(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = "pad", interpolationMethod:InterpolationMethod = "rgb", focalPointRatio:Float = 0):Void;

	function moveTo(x:Float, y:Float):Void;
	function lineTo(x:Float, y:Float):Void;
	function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void;
}