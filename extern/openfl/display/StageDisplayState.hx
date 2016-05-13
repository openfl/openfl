package openfl.display;


/**
 * The StageDisplayState class provides values for the
 * <code>Stage.displayState</code> property.
 */
@:enum abstract StageDisplayState(String) from String to String {
	
	/**
	 * Specifies that the Stage is in full-screen mode.
	 */
	public var FULL_SCREEN = "fullScreen";
	
	/**
	 * Specifies that the Stage is in full-screen mode with keyboard interactivity enabled.
	 */
	public var FULL_SCREEN_INTERACTIVE = "fullScreenInteractive";
	
	/**
	 * Specifies that the Stage is in normal mode.
	 */
	public var NORMAL = "normal";
	
}