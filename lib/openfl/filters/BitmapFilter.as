package openfl.filters {
	
	
	/**
	 * @externs
	 * The BitmapFilter class is the base class for all image filter effects.
	 *
	 * The BevelFilter, BlurFilter, ColorMatrixFilter, ConvolutionFilter,
	 * DisplacementMapFilter, DropShadowFilter, GlowFilter, GradientBevelFilter,
	 * and GradientGlowFilter classes all extend the BitmapFilter class. You can
	 * apply these filter effects to any display object.
	 *
	 * You can neither directly instantiate nor extend BitmapFilter.
	 */
	public class BitmapFilter {
		
		
		public function BitmapFilter () {}
		
		/**
		 * Returns a BitmapFilter object that is an exact copy of the original
		 * BitmapFilter object.
		 * 
		 * @return A BitmapFilter object.
		 */
		public function clone ():BitmapFilter { return null; }
		
		
	}
	
	
}