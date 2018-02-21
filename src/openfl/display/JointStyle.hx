package openfl.display; #if !openfljs


@:enum abstract JointStyle(Null<Int>) {
	
	public var BEVEL = 0;
	public var MITER = 1;
	public var ROUND = 2;
	
	@:from private static function fromString (value:String):JointStyle {
		
		return switch (value) {
			
			case "bevel": BEVEL;
			case "miter": MITER;
			case "round": ROUND;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case JointStyle.BEVEL: "bevel";
			case JointStyle.MITER: "miter";
			case JointStyle.ROUND: "round";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract JointStyle(String) from String to String {
	
	public var BEVEL = "bevel";
	public var MITER = "miter";
	public var ROUND = "round";
	
}


#end