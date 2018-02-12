package openfl.display; #if !openfljs


@:enum abstract SpreadMethod(Null<Int>) {
	
	public var PAD = 0;
	public var REFLECT = 1;
	public var REPEAT = 2;
	
	@:from private static function fromString (value:String):SpreadMethod {
		
		return switch (value) {
			
			case "pad": PAD;
			case "reflect": REFLECT;
			case "repeat": REPEAT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case SpreadMethod.PAD: "pad";
			case SpreadMethod.REFLECT: "reflect";
			case SpreadMethod.REPEAT: "repeat";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract SpreadMethod(String) from String to String {
	
	public var PAD = "pad";
	public var REFLECT = "reflect";
	public var REPEAT = "repeat";
	
}


#end