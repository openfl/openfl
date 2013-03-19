package flash.display;
#if (flash || display)


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
