package openfl.display; #if !openfl_legacy


@:enum abstract CapsStyle(String) from String to String {
	
	public var NONE = "none";
	public var ROUND = "round";
	public var SQUARE = "square";
	
}


#else
typedef CapsStyle = openfl._legacy.display.CapsStyle;
#end