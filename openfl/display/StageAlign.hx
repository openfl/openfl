package openfl.display; #if !openfl_legacy


@:enum abstract StageAlign(Int) {
	
	public var BOTTOM = 0;
	public var BOTTOM_LEFT = 1;
	public var BOTTOM_RIGHT = 2;
	public var LEFT = 3;
	public var RIGHT = 4;
	public var TOP = 5;
	public var TOP_LEFT = 6;
	public var TOP_RIGHT = 7;
	
	@:from private static inline function fromString (value:String):StageAlign {
		
		return switch (value) {
			
			case "bottom": BOTTOM;
			case "bottomLeft": BOTTOM_LEFT;
			case "bottomRight": BOTTOM_RIGHT;
			case "left": LEFT;
			case "right": RIGHT;
			case "top": TOP;
			case "topRight": TOP_RIGHT;
			default: return TOP_LEFT;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case StageAlign.BOTTOM: "bottom";
			case StageAlign.BOTTOM_LEFT: "bottomLeft";
			case StageAlign.BOTTOM_RIGHT: "bottomRight";
			case StageAlign.LEFT: "left";
			case StageAlign.RIGHT: "right";
			case StageAlign.TOP: "top";
			case StageAlign.TOP_RIGHT: "topRight";
			default: "topLeft";
			
		}
		
	}
	
}


#else
typedef StageAlign = openfl._legacy.display.StageAlign;
#end