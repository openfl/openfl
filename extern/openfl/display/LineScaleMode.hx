package openfl.display;


/**
 * The LineScaleMode class provides values for the <code>scaleMode</code>
 * parameter in the <code>Graphics.lineStyle()</code> method.
 */
@:enum abstract LineScaleMode(String) from String to String {
	
	/**
	 * With this setting used as the <code>scaleMode</code> parameter of the
	 * <code>lineStyle()</code> method, the thickness of the line scales
	 * <i>only</i> vertically. For example, consider the following circles, drawn
	 * with a one-pixel line, and each with the <code>scaleMode</code> parameter
	 * set to <code>LineScaleMode.VERTICAL</code>. The circle on the left is
	 * scaled only vertically, and the circle on the right is scaled both
	 * vertically and horizontally.
	 */
	public var HORIZONTAL = "horizontal";
	
	/**
	 * With this setting used as the <code>scaleMode</code> parameter of the
	 * <code>lineStyle()</code> method, the thickness of the line never scales.
	 */
	public var NONE = "none";
	
	/**
	 * With this setting used as the <code>scaleMode</code> parameter of the
	 * <code>lineStyle()</code> method, the thickness of the line always scales
	 * when the object is scaled(the default).
	 */
	public var NORMAL = "normal";
	
	/**
	 * With this setting used as the <code>scaleMode</code> parameter of the
	 * <code>lineStyle()</code> method, the thickness of the line scales
	 * <i>only</i> horizontally. For example, consider the following circles,
	 * drawn with a one-pixel line, and each with the <code>scaleMode</code>
	 * parameter set to <code>LineScaleMode.HORIZONTAL</code>. The circle on the
	 * left is scaled only horizontally, and the circle on the right is scaled
	 * both vertically and horizontally.
	 */
	public var VERTICAL = "vertical";
	
}