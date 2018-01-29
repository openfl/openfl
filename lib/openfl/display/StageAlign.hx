package openfl.display; #if (display || !flash)


/**
 * The StageAlign class provides constant values to use for the
 * `Stage.align` property.
 */
@:enum abstract StageAlign(Null<Int>) {
	
	/**
	 * Specifies that the Stage is aligned at the bottom.
	 */
	public var BOTTOM = 0;
	
	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	public var BOTTOM_LEFT = 1;
	
	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	public var BOTTOM_RIGHT = 2;
	
	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	public var LEFT = 3;
	
	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	public var RIGHT = 4;
	
	/**
	 * Specifies that the Stage is aligned at the top.
	 */
	public var TOP = 5;
	
	/**
	 * Specifies that the Stage is aligned on the left.
	 */
	public var TOP_LEFT = 6;
	
	/**
	 * Specifies that the Stage is aligned to the right.
	 */
	public var TOP_RIGHT = 7;
	
	@:from private static function fromString (value:String):StageAlign {
		
		return switch (value) {
			
			case "bottom": BOTTOM;
			case "bottomLeft": BOTTOM_LEFT;
			case "bottomRight": BOTTOM_RIGHT;
			case "left": LEFT;
			case "right": RIGHT;
			case "top": TOP;
			case "topLeft": TOP_LEFT;
			case "topRight": TOP_RIGHT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case StageAlign.BOTTOM: "bottom";
			case StageAlign.BOTTOM_LEFT: "bottomLeft";
			case StageAlign.BOTTOM_RIGHT: "bottomRight";
			case StageAlign.LEFT: "left";
			case StageAlign.RIGHT: "right";
			case StageAlign.TOP: "top";
			case StageAlign.TOP_LEFT: "topLeft";
			case StageAlign.TOP_RIGHT: "topRight";
			default: null;
			
		}
		
	}
	
}


#else
typedef StageAlign = flash.display.StageAlign;
#end