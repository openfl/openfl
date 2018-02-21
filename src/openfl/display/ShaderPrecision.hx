package openfl.display; #if !openfljs


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
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case ShaderPrecision.FULL: "full";
			case ShaderPrecision.FAST: "fast";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract ShaderPrecision(String) from String to String {
	
	public var FAST = "fast";
	public var FULL = "full";
	
}


#end