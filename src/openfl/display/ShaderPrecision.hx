package openfl.display;


@:enum abstract ShaderPrecision(Null<Int>) {
	
	public var FAST = 0;
	public var FULL = 1;
	
	@:from private static function fromString (value:String):ShaderPrecision {
		
		return switch (value) {
			
			case "fast": FAST;
			case "full": FULL;
			default: null;
			
		}
		
	}
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case ShaderPrecision.FULL: "full";
			case ShaderPrecision.FAST: "fast";
			default: null;
			
		}
		
	}
	
}