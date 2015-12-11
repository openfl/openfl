package openfl.display; #if (display || !flash)


/**
 * Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
 * <code>Graphics.drawGraphicsData()</code> method.
 *
 * <p> Drawing a GraphicsEndFill object is the equivalent of calling the
 * <code>Graphics.endFill()</code> method. </p>
 */
@:final extern class GraphicsEndFill implements IGraphicsData implements IGraphicsFill {
	
	
	/**
	 * Creates an object to use with the <code>Graphics.drawGraphicsData()</code>
	 * method to end the fill, explicitly.
	 */
	public function new ();
	
	
}


#else
typedef GraphicsEndFill = flash.display.GraphicsEndFill;
#end