package com.codeazur.hxswf.exporters.core
{
	import com.codeazur.hxswf.SWF;
	import com.codeazur.hxswf.utils.NumberUtils;
	
	import flash.display.InterpolationMethod;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	class DefaultSVGShapeExporter extends DefaultShapeExporter
	{
		private static inline var DRAW_COMMAND_L:String = "L";
		private static inline var DRAW_COMMAND_Q:String = "Q";

		private var currentDrawCommand:String = "";
		private var pathData:String;
		
		public function DefaultSVGShapeExporter(swf:SWF) {
			super(swf);
		}
		
		override public function beginFill(color:Int, alpha:Float = 1.0):Void {
			finalizePath();
		}
		
		override public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			finalizePath();
		}

		override public function beginBitmapFill(bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
			finalizePath();
		}
		
		override public function endFill():Void {
			finalizePath();
		}

		override public function lineStyle(thickness:Float = NaN, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:String = LineScaleMode.NORMAL, startCaps:String = null, endCaps:String = null, joints:String = null, miterLimit:Float = 3):Void {
			finalizePath();
		}
		
		override public function moveTo(x:Float, y:Float):Void {
			currentDrawCommand = "";
			pathData += "M" +
				NumberUtils.roundPixels20(x) + " " + 
				NumberUtils.roundPixels20(y) + " ";
		}
		
		override public function lineTo(x:Float, y:Float):Void {
			if(currentDrawCommand != DRAW_COMMAND_L) {
				currentDrawCommand = DRAW_COMMAND_L;
				pathData += "L";
			}
			pathData += 
				NumberUtils.roundPixels20(x) + " " + 
				NumberUtils.roundPixels20(y) + " ";
		}
		
		override public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
			if(currentDrawCommand != DRAW_COMMAND_Q) {
				currentDrawCommand = DRAW_COMMAND_Q;
				pathData += "Q";
			}
			pathData += 
				NumberUtils.roundPixels20(controlX) + " " + 
				NumberUtils.roundPixels20(controlY) + " " + 
				NumberUtils.roundPixels20(anchorX) + " " + 
				NumberUtils.roundPixels20(anchorY) + " ";
		}
		
		override public function endLines():Void {
			finalizePath();
		}

		
		private function finalizePath():Void {
			pathData = "";
			currentDrawCommand = "";
		}
	}
}
