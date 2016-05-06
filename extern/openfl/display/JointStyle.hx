package openfl.display;


/**
 * The JointStyle class is an enumeration of constant values that specify the
 * joint style to use in drawing lines. These constants are provided for use
 * as values in the <code>joints</code> parameter of the
 * <code>openfl.display.Graphics.lineStyle()</code> method. The method supports
 * three types of joints: miter, round, and bevel, as the following example
 * shows:
 */
@:enum abstract JointStyle(String) from String to String {
	
	/**
	 * Specifies mitered joints in the <code>joints</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	public var MITER = "miter";
	
	/**
	 * Specifies round joints in the <code>joints</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	public var ROUND = "round";
	
	/**
	 * Specifies beveled joints in the <code>joints</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	public var BEVEL = "bevel";
	
}