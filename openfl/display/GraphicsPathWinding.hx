package openfl.display; #if !flash


/**
 * The GraphicsPathWinding class provides values for the
 * <code>openfl.display.GraphicsPath.winding</code> property and the
 * <code>openfl.display.Graphics.drawPath()</code> method to determine the
 * direction to draw a path. A clockwise path is positively wound, and a
 * counter-clockwise path is negatively wound:
 *
 * <p> When paths intersect or overlap, the winding direction determines the
 * rules for filling the areas created by the intersection or overlap:</p>
 */
@:fakeEnum(String) enum GraphicsPathWinding {
	
	EVEN_ODD;
	NON_ZERO;
	
}


#else
typedef GraphicsPathWinding = flash.display.GraphicsPathWinding;
#end