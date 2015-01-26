package openfl.display; #if !flash #if !lime_legacy


/**
 * The JointStyle class is an enumeration of constant values that specify the
 * joint style to use in drawing lines. These constants are provided for use
 * as values in the <code>joints</code> parameter of the
 * <code>openfl.display.Graphics.lineStyle()</code> method. The method supports
 * three types of joints: miter, round, and bevel, as the following example
 * shows:
 */
enum JointStyle {
	
	/**
	 * Specifies mitered joints in the <code>joints</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	MITER;
	
	/**
	 * Specifies round joints in the <code>joints</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	ROUND;
	
	/**
	 * Specifies beveled joints in the <code>joints</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	BEVEL;
	
}


#else
typedef JointStyle = openfl._v2.display.JointStyle;
#end
#else
typedef JointStyle = flash.display.JointStyle;
#end