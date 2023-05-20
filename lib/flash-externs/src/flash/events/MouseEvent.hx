package flash.events;

#if flash
import openfl.display.InteractiveObject;
import openfl.events.EventType;

extern class MouseEvent extends Event
{
	public static var CLICK(default, never):EventType<MouseEvent>;
	@:require(flash11_2) public static var CONTEXT_MENU(default, never):EventType<MouseEvent>;
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

	#if (haxe_ver < 4.3)
	public var altKey:Bool;
	public var buttonDown:Bool;
	public var clickCount(default, never):Int;
	public var commandKey:Bool;
	public var controlKey:Bool;
	public var ctrlKey:Bool;
	public var delta:Int;
	@:require(flash10) public var isRelatedObjectInaccessible:Bool;
	public var localX:Float;
	public var localY:Float;
	@:require(flash11_2) public var movementX:Float;
	@:require(flash11_2) public var movementY:Float;
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	public var stageX:Float;
	public var stageY:Float;
	#else
	@:flash.property var altKey(get, set):Bool;
	@:flash.property var buttonDown(get, set):Bool;
	@:flash.property var clickCount(get, never):Int;
	@:flash.property var commandKey(get, set):Bool;
	@:flash.property var controlKey(get, set):Bool;
	@:flash.property var ctrlKey(get, set):Bool;
	@:flash.property var delta(get, set):Int;
	@:flash.property @:require(flash10) var isRelatedObjectInaccessible(get, set):Bool;
	@:flash.property var localX(get, set):Float;
	@:flash.property var localY(get, set):Float;
	@:flash.property @:require(flash11_2) var movementX(get, set):Float;
	@:flash.property @:require(flash11_2) var movementY(get, set):Float;
	@:flash.property var relatedObject(get, set):InteractiveObject;
	@:flash.property var shiftKey(get, set):Bool;
	@:flash.property var stageX(get, set):Float;
	@:flash.property var stageY(get, set):Float;
	#end

	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, localX:Float = 0, localY:Float = 0, relatedObject:InteractiveObject = null,
		ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, buttonDown:Bool = false, delta:Int = 0, commandKey:Bool = false, clickCount:Int = 0);
	public override function clone():MouseEvent;
	public function updateAfterEvent():Void;

	#if (haxe_ver >= 4.3)
	private function get_altKey():Bool;
	private function get_buttonDown():Bool;
	private function get_clickCount():Int;
	private function get_commandKey():Bool;
	private function get_controlKey():Bool;
	private function get_ctrlKey():Bool;
	private function get_delta():Int;
	private function get_isRelatedObjectInaccessible():Bool;
	private function get_localX():Float;
	private function get_localY():Float;
	private function get_movementX():Float;
	private function get_movementY():Float;
	private function get_relatedObject():InteractiveObject;
	private function get_shiftKey():Bool;
	private function get_stageX():Float;
	private function get_stageY():Float;
	private function set_altKey(value:Bool):Bool;
	private function set_buttonDown(value:Bool):Bool;
	private function set_commandKey(value:Bool):Bool;
	private function set_controlKey(value:Bool):Bool;
	private function set_ctrlKey(value:Bool):Bool;
	private function set_delta(value:Int):Int;
	private function set_isRelatedObjectInaccessible(value:Bool):Bool;
	private function set_localX(value:Float):Float;
	private function set_localY(value:Float):Float;
	private function set_movementX(value:Float):Float;
	private function set_movementY(value:Float):Float;
	private function set_relatedObject(value:InteractiveObject):InteractiveObject;
	private function set_shiftKey(value:Bool):Bool;
	private function set_stageX(value:Float):Float;
	private function set_stageY(value:Float):Float;
	#end
}
#else
typedef MouseEvent = openfl.events.MouseEvent;
#end
