package openfl.text;


@:enum abstract AntiAliasType(Int) {
	
	public var ADVANCED = 0;
	public var NORMAL = 1;
	
	@:from private static inline function fromString (value:String):AntiAliasType {
		
		return switch (value) {
			
			case "advanced": ADVANCED;
			default: return NORMAL;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case AntiAliasType.ADVANCED: "advanced";
			default: "normal";
			
		}
		
	}
	
}