package openfl.display;


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

#if flash
@:native("flash.display.GraphicsPathWinding")
#end

@:enum abstract GraphicsPathWinding(String) from String to String {
	
	public var EVEN_ODD = "evenOdd";
	public var NON_ZERO = "nonZero";
	
}