package openfl.filters; #if !flash #if !lime_legacy


import openfl.geom.Point;
import openfl.geom.Rectangle;

#if js
import js.html.ImageData;
#end


/**
 * The BitmapFilter class is the base class for all image filter effects.
 *
 * <p>The BevelFilter, BlurFilter, ColorMatrixFilter, ConvolutionFilter,
 * DisplacementMapFilter, DropShadowFilter, GlowFilter, GradientBevelFilter,
 * and GradientGlowFilter classes all extend the BitmapFilter class. You can
 * apply these filter effects to any display object.</p>
 *
 * <p>You can neither directly instantiate nor extend BitmapFilter.</p>
 */
class BitmapFilter {
	
	
	public function new () {
		
		
		
	}
	
	
	/**
	 * Returns a BitmapFilter object that is an exact copy of the original
	 * BitmapFilter object.
	 * 
	 * @return A BitmapFilter object.
	 */
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	#if js
	@:noCompletion public function __applyFilter (sourceData:ImageData, targetData:ImageData, sourceRect:Rectangle, destPoint:Point):Void {
		
		
		
	}
	#end
	
	
}


#else
typedef BitmapFilter = openfl._v2.filters.BitmapFilter;
#end
#else
typedef BitmapFilter = flash.filters.BitmapFilter;
#end