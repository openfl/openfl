import IGraphicsData from "./IGraphicsData";
import IGraphicsFill from "./IGraphicsFill";


declare namespace openfl.display {
	
	
	/**
	 * Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
	 * `Graphics.drawGraphicsData()` method.
	 *
	 *  Drawing a GraphicsEndFill object is the equivalent of calling the
	 * `Graphics.endFill()` method. 
	 */
	/*@:final*/ export class GraphicsEndFill implements IGraphicsData, IGraphicsFill {
		
		
		/**
		 * Creates an object to use with the `Graphics.drawGraphicsData()`
		 * method to end the fill, explicitly.
		 */
		public constructor ();
		
		
	}
	
	
}


export default openfl.display.GraphicsEndFill;