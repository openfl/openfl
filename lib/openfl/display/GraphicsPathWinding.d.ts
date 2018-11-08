declare namespace openfl.display {
	
	/**
	 * The GraphicsPathWinding class provides values for the
	 * `openfl.display.GraphicsPath.winding` property and the
	 * `openfl.display.Graphics.drawPath()` method to determine the
	 * direction to draw a path. A clockwise path is positively wound, and a
	 * counter-clockwise path is negatively wound:
	 *
	 *  When paths intersect or overlap, the winding direction determines the
	 * rules for filling the areas created by the intersection or overlap:
	 */
	export enum GraphicsPathWinding {
		
		EVEN_ODD = "evenOdd",
		NON_ZERO = "nonZero"
		
	}
	
}


export default openfl.display.GraphicsPathWinding;