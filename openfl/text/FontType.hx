package openfl.text; #if !openfl_legacy


@:enum abstract FontType(String) from String to String {
	
	public var DEVICE = "device";
	public var EMBEDDED = "embedded";
	public var EMBEDDED_CFF = "embeddedCFF";
	
}


#else
typedef FontType = openfl._legacy.text.FontType;
#end