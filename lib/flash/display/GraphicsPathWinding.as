package flash.display {
	
	
	/**
	 * @externs
	 * The GraphicsPathWinding class provides values for the
	 * `flash.display.GraphicsPath.winding` property and the
	 * `flash.display.Graphics.drawPath()` method to determine the
	 * direction to draw a path. A clockwise path is positively wound, and a
	 * counter-clockwise path is negatively wound:
	 *
	 *  When paths intersect or overlap, the winding direction determines the
	 * rules for filling the areas created by the intersection or overlap:
	 */
	public class GraphicsPathWinding {
		
		public static const EVEN_ODD:String = "evenOdd";
		public static const NON_ZERO:String = "nonZero";
		
	}
	
	
}