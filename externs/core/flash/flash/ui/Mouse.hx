package flash.ui; #if (!display && flash)


@:final extern class Mouse {
	
	
	@:require(flash10) public static var cursor:String;
	@:require(flash10_1) public static var supportsCursor (default, null):Bool;
	@:require(flash11) public static var supportsNativeCursor (default, null):Bool;
	
	
	public static function hide ():Void;
	
	#if flash
	@:require(flash10_2) public static function registerCursor (name:String, cursor:flash.ui.MouseCursorData):Void;
	#end
	
	public static function show ():Void;
	
	#if flash
	@:require(flash11) public static function unregisterCursor (name:String):Void;
	#end
	
	
}


#else
typedef Mouse = openfl.ui.Mouse;
#end