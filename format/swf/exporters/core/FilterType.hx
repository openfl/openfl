package format.swf.exporters.core;

import openfl.utils.Float32ArrayContainer;

enum FilterType {

	BlurFilter (blurX:Float, blurY:Float, quality:Int);
	ColorMatrixFilter (multipliers:Float32ArrayContainer, offsets:Float32ArrayContainer);
	DropShadowFilter (distance:Float, angle:Float, color:Int, alpha:Float, blurX:Float, blurY:Float, strength:Float, quality:Int, inner:Bool, knockout:Bool, hideObject:Bool);
	GlowFilter (color:Int, alpha:Float, blurX:Float, blurY:Float, strength:Float, quality:Int, inner:Bool, knockout:Bool);
	GradientGlowFilter (distance:Float, angle:Float, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Float>, blurX:Float, blurY:Float, strength:Float, quality:Int, type:openfl.filters.BitmapFilterType, knockout:Bool);
	BevelFilter(distance:Float, angle:Float, highlightColor:Int, highlightAlpha:Float, shadowColor: Int, shadowAlpha: Float, blurX:Float, blurY:Float, strength:Float, quality:Int, type: openfl.filters.BitmapFilterType, knockout:Bool);
	GradientBevelFilter(distance:Float, angle:Float, colors:Array<Int>, alphas:Array<Float>, radios:Array<Float>, blurX:Float, blurY:Float, strength:Float, quality:Int, type: openfl.filters.BitmapFilterType, knockout:Bool);
}
