import IGraphicsData from "./IGraphicsData";
import IGraphicsFill from "./IGraphicsFill";


declare namespace openfl.display {
	
	
	/**
	 * Defines a solid fill.
	 *
	 *  Use a GraphicsSolidFill object with the
	 * `Graphics.drawGraphicsData()` method. Drawing a
	 * GraphicsSolidFill object is the equivalent of calling the
	 * `Graphics.beginFill()` method. 
	 */
	/*@:final*/ export class GraphicsSolidFill implements IGraphicsData, IGraphicsFill {
		
		
		/**
		 * Indicates the alpha transparency value of the fill. Valid values are 0
		 * (fully transparent) to 1(fully opaque). The default value is 1. Display
		 * objects with alpha set to 0 are active, even though they are invisible.
		 */
		public alpha:number;
		
		/**
		 * The color of the fill. Valid values are in the hexadecimal format
		 * 0xRRGGBB. The default value is 0xFF0000(or the uint 0).
		 */
		public color:number;
		
		
		/**
		 * Creates a new GraphicsSolidFill object.
		 * 
		 * @param color The color value. Valid values are in the hexadecimal format
		 *              0xRRGGBB.
		 * @param alpha The alpha transparency value. Valid values are 0(fully
		 *              transparent) to 1(fully opaque).
		 */
		public constructor (color?:number, alpha?:number);
		
		
	}
	
	
}


export default openfl.display.GraphicsSolidFill;