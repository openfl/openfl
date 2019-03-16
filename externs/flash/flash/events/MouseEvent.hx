package flash.events;

#if flash
import openfl.display.InteractiveObject;
import openfl.events.EventType;

extern class MouseEvent extends Event
{
	public static var CLICK(default, never):EventType<MouseEvent>;
	#if flash
	@:require(flash11_2) public static var CONTEXT_MENU(default, never):EventType<MouseEvent>;
	#end
	public static var DOUBLE_CLICK(default, never):EventType<MouseEvent>;
	@:require(flash11_2) public static var MIDDLE_CLICK(default, never):EventType<MouseEvent>;
	@:require(flash11_2) public static var MIDDLE_MOUSE_DOWN(default, never):EventType<MouseEvent>;
	@:require(flash11_2) public static var MIDDLE_MOUSE_UP(default, never):EventType<MouseEvent>;
	public static var MOUSE_DOWN(default, never):EventType<MouseEvent>;
	public static var MOUSE_MOVE(default, never):EventType<MouseEvent>;
	public static var MOUSE_OUT(default, never):EventType<MouseEvent>;
	public static var MOUSE_OVER(default, never):EventType<MouseEvent>;
	public static var MOUSE_UP(default, never):EventType<MouseEvent>;
	public static var MOUSE_WHEEL(default, never):EventType<MouseEvent>;
	@:require(flash11_3) public static var RELEASE_OUTSIDE(default, never):EventType<MouseEvent>;
	@:require(flash11_2) public static var RIGHT_CLICK(default, never):EventType<MouseEvent>;
	@:require(flash11_2) public static var RIGHT_MOUSE_DOWN(default, never):EventType<MouseEvent>;
	@:require(flash11_2) public static var RIGHT_MOUSE_UP(default, never):EventType<MouseEvent>;
	public static var ROLL_OUT(default, never):EventType<MouseEvent>;
	public static var ROLL_OVER(default, never):EventType<MouseEvent>;
	public var altKey:Bool;
	public var buttonDown:Bool;
	public var clickCount:Int;
	public var commandKey:Bool;
	public var ctrlKey:Bool;
	public var delta:Int;
	@:require(flash10) public var isRelatedObjectInaccessible:Bool;
	public var localX:Float;
	public var localY:Float;
	#if flash
	@:require(flash11_2) public var movementX:Float;
	#end
	#if flash
	@:require(flash11_2) public var movementY:Float;
	#end
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	public var stageX:Float;
	public var stageY:Float;
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, localX:Float = 0, localY:Float = 0, relatedObject:InteractiveObject = null,
		ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, buttonDown:Bool = false, delta:Int = 0, commandKey:Bool = false, clickCount:Int = 0);
	public override function clone():MouseEvent;
	public function updateAfterEvent():Void;
}
#else
typedef MouseEvent = openfl.events.MouseEvent;
#end
