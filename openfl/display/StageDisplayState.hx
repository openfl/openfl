package openfl.display; #if (!display && !flash)


enum StageDisplayState {
	
	NORMAL;
	FULL_SCREEN;
	FULL_SCREEN_INTERACTIVE;
	
}


#else


/**
 * The StageDisplayState class provides values for the
 * <code>Stage.displayState</code> property.
 */

#if flash
@:native("flash.display.StageDisplayState")
#end

@:fakeEnum(String) extern enum StageDisplayState {
	
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


#end