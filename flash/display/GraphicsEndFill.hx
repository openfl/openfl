package flash.display;
#if (flash || display)


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
