package flash.display; #if (!display && flash)


@:enum abstract CapsStyle(String) from String to String {
	
	public var NONE = "none";
	public var ROUND = "round";
	public var SQUARE = "square";
	
}


#else
typedef CapsStyle = openfl.display.CapsStyle;
#end