package openfl.display; #if (display || !flash)


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
@:enum abstract GraphicsPathWinding(Null<Int>) {
	
	public var EVEN_ODD = 0;
	public var NON_ZERO = 1;
	
	@:from private static function fromString (value:String):GraphicsPathWinding {
		
		return switch (value) {
			
			case "evenOdd": EVEN_ODD;
			case "nonZero": NON_ZERO;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case GraphicsPathWinding.EVEN_ODD: "evenOdd";
			case GraphicsPathWinding.NON_ZERO: "nonZero";
			default: null;
			
		}
		
	}
	
}


#else
typedef GraphicsPathWinding = flash.display.GraphicsPathWinding;
#end