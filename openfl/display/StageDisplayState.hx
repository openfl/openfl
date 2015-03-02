package openfl.display; #if !flash


/**
 * The StageDisplayState class provides values for the
 * <code>Stage.displayState</code> property.
 */
enum StageDisplayState {
	
	/**
	 * Specifies that the Stage is in normal mode.
	 */
	NORMAL;
	
	/**
	 * Specifies that the Stage is in full-screen mode.
	 */
	FULL_SCREEN;
	
	/**
	 * Specifies that the Stage is in full-screen mode with keyboard interactivity enabled.
	 */
	FULL_SCREEN_INTERACTIVE;
	
}


#else
typedef StageDisplayState = flash.display.StageDisplayState;
#end