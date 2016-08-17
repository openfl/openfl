package flash.ui; #if (!display && flash)


@:enum abstract MouseCursor(String) from String to String {
	
	public var ARROW = "arrow";
	public var AUTO = "auto";
	public var BUTTON = "button";
	public var HAND = "hand";
	public var IBEAM = "ibeam";
	
}


#else
typedef MouseCursor = openfl.ui.MouseCursor;
#end