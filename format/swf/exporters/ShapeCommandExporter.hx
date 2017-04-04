package format.swf.exporters;


import flash.display.CapsStyle;
import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.SpreadMethod;
import flash.geom.Matrix;
import format.swf.SWFTimelineContainer;
import format.swf.exporters.core.DefaultShapeExporter;
import openfl._internal.swf.ShapeCommand;
import format.swf.utils.NumberUtils;
import format.swf.utils.StringUtils;


class ShapeCommandExporter extends DefaultShapeExporter {
	
	
	public var commands:Array<ShapeCommand>;
	
	
	public function new (swf:SWFTimelineContainer) {
		
		super (swf);
		
		commands = new Array<ShapeCommand> ();
		
	}
	
	
	override public function beginShape ():Void {
		
		commands = new Array<ShapeCommand> ();
		
	}
	
	
	override public function beginFills ():Void {
		
		commands.push (LineStyle (null, null, null, null, null, null, null, null));
		
	}
	
	
	override public function beginLines ():Void {
		
		
		
	}
	
	
	override public function beginFill (color:Int, alpha:Float = 1.0):Void {
		
		commands.push (BeginFill (color, alpha));
		
	}
	
	override public function beginGradientFill (type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, spreadMethod:SpreadMethod = null, interpolationMethod:InterpolationMethod = null, focalPointRatio:Float = 0):Void {
		
		commands.push (BeginGradientFill (type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio));
		
	}

	override public function beginBitmapFill (bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		
		commands.push (BeginBitmapFill (bitmapId, matrix, repeat, smooth));
		
	}
	
	override public function endFill ():Void {
		
		commands.push (EndFill);
		
	}
	
	override public function lineStyle (thickness:Float = 0, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:LineScaleMode = null, startCaps:CapsStyle = null, endCaps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3):Void {
		
		commands.push (LineStyle (thickness, color, alpha, pixelHinting, scaleMode, startCaps, /*endCaps,*/ joints, miterLimit));
		
	}
	
	
	override public function moveTo (x:Float, y:Float):Void {
		
		commands.push (MoveTo (x, y));
		
	}
	
	override public function lineTo (x:Float, y:Float):Void {
		
		commands.push (LineTo (x, y));
		
	}
	
	override public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		
		commands.push (CurveTo (controlX, controlY, anchorX, anchorY));
		
	}
	
	
}