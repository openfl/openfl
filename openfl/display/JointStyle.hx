package openfl.display; #if !openfl_legacy


@:enum abstract JointStyle(Int) {
	
	public var BEVEL = 0;
	public var MITER = 1;
	public var ROUND = 2;
	
	@:from private static inline function fromString (value:String):JointStyle {
		
		return switch (value) {
			
			case "bevel": BEVEL;
			case "miter": MITER;
			default: return ROUND;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case JointStyle.BEVEL: "bevel";
			case JointStyle.MITER: "miter";
			default: "round";
			
		}
		
	}
	
}


#else
typedef JointStyle = openfl._legacy.display.JointStyle;
#end