package openfl.text; #if !openfljs


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
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case AntiAliasType.ADVANCED: "advanced";
			case AntiAliasType.NORMAL: "normal";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract AntiAliasType(String) from String to String {
	
	public var ADVANCED = "advanced";
	public var NORMAL = "normal";
	
}


#end