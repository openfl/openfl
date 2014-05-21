/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.display;
#if display


/**
 * Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
 * <code>Graphics.drawGraphicsData()</code> method.
 *
 * <p> Drawing a GraphicsEndFill object is the equivalent of calling the
 * <code>Graphics.endFill()</code> method. </p>
 */
extern class GraphicsEndFill implements IGraphicsData/*  implements IGraphicsFill*/ {

	/**
	 * Creates an object to use with the <code>Graphics.drawGraphicsData()</code>
	 * method to end the fill, explicitly.
	 */
	function new() : Void;
}


#end
