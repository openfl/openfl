package flash.events;

#if flash
import openfl.display.InteractiveObject;
import openfl.events.EventType;

extern class FocusEvent extends Event
{
	public static var FOCUS_IN(default, never):EventType<FocusEvent>;
	public static var FOCUS_OUT(default, never):EventType<FocusEvent>;
	public static var KEY_FOCUS_CHANGE(default, never):EventType<FocusEvent>;
	public static var MOUSE_FOCUS_CHANGE(default, never):EventType<FocusEvent>;

	#if (haxe_ver < 4.3)
	#if air
	public var direction:flash.display.FocusDirection;
	#end
	@:require(flash10) public var isRelatedObjectInaccessible:Bool;
	public var keyCode:Int;
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	#else
	#if air
	@:flash.property public var direction(get, set):flash.display.FocusDirection;
	#end
	@:flash.property @:require(flash10) var isRelatedObjectInaccessible(get, set):Bool;
	@:flash.property var keyCode(get, set):UInt;
	@:flash.property var relatedObject(get, set):InteractiveObject;
	@:flash.property var shiftKey(get, set):Bool;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, relatedObject:InteractiveObject = null, shiftKey:Bool = false,
		keyCode:Int = 0);
	public override function clone():FocusEvent;

	#if (haxe_ver >= 4.3)
	#if air
	private function get_direction():flash.display.FocusDirection;
	#end
	private function get_isRelatedObjectInaccessible():Bool;
	private function get_keyCode():UInt;
	private function get_relatedObject():InteractiveObject;
	private function get_shiftKey():Bool;
	#if air
	private function set_direction(value:flash.display.FocusDirection):flash.display.FocusDirection;
	#end
	private function set_isRelatedObjectInaccessible(value:Bool):Bool;
	private function set_keyCode(value:UInt):UInt;
	private function set_relatedObject(value:InteractiveObject):InteractiveObject;
	private function set_shiftKey(value:Bool):Bool;
	#end
}
#else
typedef FocusEvent = openfl.events.FocusEvent;
#end
