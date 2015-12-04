package openfl.display; #if (!display && !flash)


enum StageAlign {
	
	TOP_RIGHT;
	TOP_LEFT;
	TOP;
	RIGHT;
	LEFT;
	BOTTOM_RIGHT;
	BOTTOM_LEFT;
	BOTTOM;
	
}


#else


/**
 * The StageAlign class provides constant values to use for the
 * <code>Stage.align</code> property.
 */

#if flash
@:native("flash.display.StageAlign")
#end

@:fakeEnum(String) extern enum StageAlign {
	
	
	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	TOP_RIGHT;
	
	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	TOP_LEFT;
	
	/**
	 * Specifies that the Stage is aligned at the top.
	 */
	TOP;
	
	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	RIGHT;
	
	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	LEFT;
	
	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	BOTTOM_RIGHT;
	
	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	BOTTOM_LEFT;
	
	/**
	 * Specifies that the Stage is aligned at the bottom.
	 */
	BOTTOM;
	
}


#end