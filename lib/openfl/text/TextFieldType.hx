package openfl.text; #if (display || !flash)


/**
 * The TextFieldType class is an enumeration of constant values used in
 * setting the `type` property of the TextField class.
 */
@:enum abstract TextFieldType(Null<Int>) {
	
	/**
	 * Used to specify a `dynamic` TextField.
	 */
	public var DYNAMIC = 0;
	
	/**
	 * Used to specify an `input` TextField.
	 */
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
typedef TextFieldType = flash.text.TextFieldType;
#end