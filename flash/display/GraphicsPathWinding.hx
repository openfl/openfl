package flash.display;
#if (flash || display)


/**
 * The GraphicsPathWinding class provides values for the
 * <code>flash.display.GraphicsPath.winding</code> property and the
 * <code>flash.display.Graphics.drawPath()</code> method to determine the
 * direction to draw a path. A clockwise path is positively wound, and a
 * counter-clockwise path is negatively wound:
 *
 * <p> When paths intersect or overlap, the winding direction determines the
 * rules for filling the areas created by the intersection or overlap:</p>
 */
@:fakeEnum(String) extern enum GraphicsPathWinding {
	EVEN_ODD;
	NON_ZERO;
}


#end
