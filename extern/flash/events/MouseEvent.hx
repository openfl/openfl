package flash.events; #if (!display && flash)


import openfl.display.InteractiveObject;


extern class MouseEvent extends Event {
	
	
	public static var CLICK (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_2) public static var CONTEXT_MENU (default, never):String;
	#end
	
	public static var DOUBLE_CLICK (default, never):String;
	@:require(flash11_2) public static var MIDDLE_CLICK (default, never):String;
	@:require(flash11_2) public static var MIDDLE_MOUSE_DOWN (default, never):String;
	@:require(flash11_2) public static var MIDDLE_MOUSE_UP (default, never):String;
	public static var MOUSE_DOWN (default, never):String;
	public static var MOUSE_MOVE (default, never):String;
	public static var MOUSE_OUT (default, never):String;
	public static var MOUSE_OVER (default, never):String;
	public static var MOUSE_UP (default, never):String;
	public static var MOUSE_WHEEL (default, never):String;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public static var RELEASE_OUTSIDE (default, never):String;
	#end
	
	@:require(flash11_2) public static var RIGHT_CLICK (default, never):String;
	@:require(flash11_2) public static var RIGHT_MOUSE_DOWN (default, never):String;
	@:require(flash11_2) public static var RIGHT_MOUSE_UP (default, never):String;
	public static var ROLL_OUT (default, never):String;
	public static var ROLL_OVER (default, never):String;
	
	public var altKey:Bool;
	public var buttonDown:Bool;
	public var clickCount:Int;
	public var commandKey:Bool;
	public var ctrlKey:Bool;
	public var delta:Int;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var isRelatedObjectInaccessible:Bool;
	#end
	
	public var localX:Float;
	public var localY:Float;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_2) public var movementX:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_2) public var movementY:Float;
	#end
	
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	public var stageX:Float;
	public var stageY:Float;
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, localX:Float = 0, localY:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, buttonDown:Bool = false, delta:Int = 0, commandKey:Bool = false, clickCount:Int = 0);
	public function updateAfterEvent ():Void;
	
	
}


#else
typedef MouseEvent = openfl.events.MouseEvent;
#end