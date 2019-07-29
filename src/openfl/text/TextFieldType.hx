package openfl.text;


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
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case TextFieldType.DYNAMIC: "dynamic";
			case TextFieldType.INPUT: "input";
			default: null;
			
		}
		
	}
	
}