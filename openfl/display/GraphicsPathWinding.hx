package openfl.display;


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