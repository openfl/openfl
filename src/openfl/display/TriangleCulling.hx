package openfl.display; #if !openfljs


@:enum abstract TriangleCulling(Null<Int>) {
	
	public var NEGATIVE = 0;
	public var NONE = 1;
	public var POSITIVE = 2;
	
	@:from private static function fromString (value:String):TriangleCulling {
		
		return switch (value) {
			
			case "negative": NEGATIVE;
			case "none": NONE;
			case "positive": POSITIVE;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case TriangleCulling.NEGATIVE: "negative";
			case TriangleCulling.NONE: "none";
			case TriangleCulling.POSITIVE: "positive";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract TriangleCulling(String) from String to String {
	
	public var NEGATIVE = "negative";
	public var NONE = "none";
	public var POSITIVE = "positive";
	
}


#end