namespace openfl.display
{
	/**
		The GraphicsPathWinding class provides values for the
		`openfl.display.GraphicsPath.winding` property and the
		`openfl.display.Graphics.drawPath()` method to determine the
		direction to draw a path. A clockwise path is positively wound, and a
		counter-clockwise path is negatively wound:
	
		![positive and negative winding directions](/images/winding_positive_negative.gif)
	
		When paths intersect or overlap, the winding direction determines the
		rules for filling the areas created by the intersection or overlap:
	
		![a comparison of even-odd and non-zero winding rules](/images/winding_rules_evenodd_nonzero.gif)
	**/
	export enum GraphicsPathWinding
	{
		/**
			Establishes the even-odd winding type. The even-odd winding type is the rule
			used by all of the original drawing API and is the default type for the
			`openfl.display.Graphics.drawPath()` method. Any overlapping paths will
			alternate between open and closed fills. If two squares drawn with the same
			fill intersect, the area of the intersection is not filled. Adjacent areas are not
			the same (neither both filled nor both unfilled).
		**/
		EVEN_ODD = "evenOdd",

		/**
			Establishes the non-zero winding type. The non-zero winding type determines that
			when paths of opposite winding intersect, the intersection area is unfilled
			(as with the even-odd winding type). For paths of the same winding, the
			intersection area is filled.
		**/
		NON_ZERO = "nonZero"
	}
}

export default openfl.display.GraphicsPathWinding;
