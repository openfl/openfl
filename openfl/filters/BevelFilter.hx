package openfl.filters; #if !openfl_legacy

import openfl.filters.commands.*;

@:final class BevelFilter extends GradientBevelFilter {

	public var highlightAlpha:Float;
	public var highlightColor: Int;
	public var shadowAlpha:Float;
	public var shadowColor: Int;

	public function new (distance:Float = 4, angle:Float = 45, highlightColor:Int = 0xFFFFFF, highlightAlpha:Float = 1, shadowColor: Int = 0x000000, shadowAlpha: Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, type: BitmapFilterType = BitmapFilterType.INNER, knockout:Bool = false) {

		this.highlightColor = highlightColor;
		this.highlightAlpha = highlightAlpha;
		this.shadowColor = shadowColor;
		this.shadowAlpha = shadowAlpha;

		var colors:Array<Int> = [shadowColor, shadowColor, highlightColor, highlightColor];
		var alphas:Array<Float> = [shadowAlpha, 0., 0., highlightAlpha];
		var ratios:Array<Float> = [0, 127, 128, 255];

		super (distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
	}


	public override function clone ():BitmapFilter {

		return new BevelFilter (distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);

	}

}

#else
typedef BevelFilter = openfl._legacy.filters.BevelFilter;
#end
