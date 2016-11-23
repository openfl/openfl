package format.swf.factories;

//import format.swf.data.filters.*;
import format.swf.data.filters.IFilter;
import format.swf.data.filters.FilterDropShadow;
import format.swf.data.filters.FilterBlur;
import format.swf.data.filters.FilterGlow;
import format.swf.data.filters.FilterBevel;
import format.swf.data.filters.FilterGradientBevel;
import format.swf.data.filters.FilterGradientGlow;
import format.swf.data.filters.FilterConvolution;
import format.swf.data.filters.FilterColorMatrix;
import flash.errors.Error;

class SWFFilterFactory
{
	public static function create(id:Int):IFilter
	{
		switch(id)
		{
			case 0: return new FilterDropShadow(id);
			case 1: return new FilterBlur(id);
			case 2: return new FilterGlow(id);
			case 3: return new FilterBevel(id);
			case 4: return new FilterGradientGlow(id);
			case 5: return new FilterConvolution(id);
			case 6: return new FilterColorMatrix(id);
			case 7: return new FilterGradientBevel(id);
			default: throw(new Error("Unknown filter ID: " + id));
		}
	}
}