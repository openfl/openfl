package openfl.text; #if !openfl_legacy


@:enum abstract TextFormatAlign(String) from String to String {
	
	public var CENTER = "center";
	public var JUSTIFY = "justify";
	public var LEFT = "left";
	public var RIGHT = "right";
	
}


#else
typedef TextFormatAlign = openfl._legacy.text.TextFormatAlign;
#end