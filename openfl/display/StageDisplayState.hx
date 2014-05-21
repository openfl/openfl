/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


/**
 * The StageDisplayState class provides values for the
 * <code>Stage.displayState</code> property.
 */
@:fakeEnum(String) extern enum StageDisplayState {
	FULL_SCREEN;
	FULL_SCREEN_INTERACTIVE;

	/**
	 * Specifies that the Stage is in normal mode.
	 */
	NORMAL;
}


#end
