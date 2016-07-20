package flash.ui; #if (!display && flash)


@:final extern class Mouse {
	
	
	#if flash
	@:require(flash10) public static var cursor:Dynamic;
	#end
	
	#if flash
	@:require(flash10_1) public static var supportsCursor (default, null):Bool;
	#end
	
	#if flash
	@:require(flash11) public static var supportsNativeCursor (default, null):Bool;
	#end
	
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