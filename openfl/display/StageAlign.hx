/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


/**
 * The StageAlign class provides constant values to use for the
 * <code>Stage.align</code> property.
 */
@:fakeEnum(String) extern enum StageAlign {

	/**
	 * Specifies that the Stage is aligned at the bottom.
	 */
	BOTTOM;

	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	BOTTOM_LEFT;

	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	BOTTOM_RIGHT;

	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	LEFT;

	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	RIGHT;

	/**
	 * Specifies that the Stage is aligned at the top.
	 */
	TOP;

	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	TOP_LEFT;

	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	TOP_RIGHT;
}


#end
