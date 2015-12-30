package openfl.display; #if !openfl_legacy


@:enum abstract LineScaleMode(String) from String to String {
	
	public var HORIZONTAL = "horizontal";
	public var NONE = "none";
	public var NORMAL = "normal";
	public var VERTICAL = "vertical";
	
}


#else
typedef LineScaleMode = openfl._legacy.display.LineScaleMode;
#end