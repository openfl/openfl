/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.filters;
#if display


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
extern class BitmapFilter {
	function new() : Void;

	/**
	 * Returns a BitmapFilter object that is an exact copy of the original
	 * BitmapFilter object.
	 * 
	 * @return A BitmapFilter object.
	 */
	function clone() : BitmapFilter;
}


#end
