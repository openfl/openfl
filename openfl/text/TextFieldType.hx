package openfl.text;


@:enum abstract TextFieldType(Int) {
	
	public var DYNAMIC = 0;
	public var INPUT = 1;
	
	@:from private static inline function fromString (value:String):TextFieldType {
		
		return switch (value) {
			
			case "input": INPUT;
			default: return DYNAMIC;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case TextFieldType.INPUT: "input";
			default: "dynamic";
			
		}
		
	}
	
}