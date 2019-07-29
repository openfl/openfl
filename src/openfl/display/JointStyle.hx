package openfl.display;


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
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case JointStyle.BEVEL: "bevel";
			case JointStyle.MITER: "miter";
			case JointStyle.ROUND: "round";
			default: null;
			
		}
		
	}
	
}