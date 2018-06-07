package openfl.text; #if !openfljs


@:enum abstract TextFieldType(Null<Int>) {
	
	public var DYNAMIC = 0;
	public var INPUT = 1;
	
	@:from private static function fromString (value:String):TextFieldType {
		
		return switch (value) {
			
			case "dynamic": DYNAMIC;
			case "input": INPUT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case TextFieldType.DYNAMIC: "dynamic";
			case TextFieldType.INPUT: "input";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract TextFieldType(String) from String to String {
	
	public var DYNAMIC = "dynamic";
	public var INPUT = "input";
	
}


#end