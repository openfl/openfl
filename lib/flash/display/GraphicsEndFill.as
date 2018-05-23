package flash.display {
	
	
	/**
	 * @externs
	 * Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
	 * `Graphics.drawGraphicsData()` method.
	 *
	 *  Drawing a GraphicsEndFill object is the equivalent of calling the
	 * `Graphics.endFill()` method. 
	 */
	final public class GraphicsEndFill implements IGraphicsData, IGraphicsFill {
		
		
		/**
		 * Creates an object to use with the `Graphics.drawGraphicsData()`
		 * method to end the fill, explicitly.
		 */
		public function GraphicsEndFill () {}
		
		
	}
	
	
}