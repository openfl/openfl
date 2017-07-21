package format.swf.data.filters;

import format.swf.utils.ColorUtils;

import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterType;
#if flash
import flash.filters.GradientBevelFilter; // Not supported on native yet
#end

class FilterGradientBevel extends FilterGradientGlow implements IFilter
{
	public function new (id:Int) {
		super(id);
	}
	
	override private function get_filter():BitmapFilter {
		var gradientGlowColors:Array<Int> = [];
		var gradientGlowAlphas:Array<Float> = [];
		var gradientGlowRatios:Array<Float> = [];
		for (i in 0...numColors) {
			gradientGlowColors.push(ColorUtils.rgb(gradientColors[i]));
			gradientGlowAlphas.push(ColorUtils.alpha(gradientColors[i]));
			gradientGlowRatios.push(gradientRatios[i]);
		}
		#if flash
		var filterType:BitmapFilterType;
		#else
		var filterType:String;
		#end
		if(onTop) {
			filterType = BitmapFilterType.FULL;
		} else {
			filterType = (innerShadow) ? BitmapFilterType.INNER : BitmapFilterType.OUTER;
		}
		#if flash
		return new GradientBevelFilter(
			distance,
			angle,
			gradientGlowColors,
			gradientGlowAlphas,
			gradientGlowRatios,
			blurX,
			blurY,
			strength,
			passes,
			Std.string (filterType),
			knockout
		);
		#else
		#if ((cpp || neko) && openfl_legacy)
		return new BitmapFilter ("");
		#else
		return new BitmapFilter ();
		#end
		#end
	}
	
	override public function clone():IFilter {
		var filter:FilterGradientBevel = new FilterGradientBevel(id);
		filter.numColors = numColors;
		var i:Int;
		for (i in 0...numColors) {
			filter.gradientColors.push(gradientColors[i]);
		}
		for (i in 0...numColors) {
			filter.gradientRatios.push(gradientRatios[i]);
		}
		filter.blurX = blurX;
		filter.blurY = blurY;
		filter.angle = angle;
		filter.distance = distance;
		filter.strength = strength;
		filter.passes = passes;
		filter.innerShadow = innerShadow;
		filter.knockout = knockout;
		filter.compositeSource = compositeSource;
		filter.onTop = onTop;
		return filter;
	}
	
	override private function get_filterName():String { return "GradientBevelFilter"; }
}