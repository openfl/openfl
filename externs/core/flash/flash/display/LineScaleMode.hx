package flash.display; #if (!display && flash)


@:enum abstract LineScaleMode(String) from String to String {
	
	public var HORIZONTAL = "horizontal";
	public var NONE = "none";
	public var NORMAL = "normal";
	public var VERTICAL = "vertical";
	
}


#else
typedef LineScaleMode = openfl.display.LineScaleMode;
#end