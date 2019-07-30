package openfl.text;


@:enum abstract AntiAliasType(Null<Int>) {
	
	public var ADVANCED = 0;
	public var NORMAL = 1;
	
	@:from private static function fromString (value:String):AntiAliasType {
		
		return switch (value) {
			
			case "advanced": ADVANCED;
			case "normal": NORMAL;
			default: null;
			
		}
		
	}
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case AntiAliasType.ADVANCED: "advanced";
			case AntiAliasType.NORMAL: "normal";
			default: null;
			
		}
		
	}
	
}