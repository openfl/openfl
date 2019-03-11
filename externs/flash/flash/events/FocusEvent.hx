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
	#if air
	public var direction:flash.display.FocusDirection;
	#end
	#if flash
	@:require(flash10) public var isRelatedObjectInaccessible:Bool;
	#end
	public var keyCode:Int;
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, relatedObject:InteractiveObject = null, shiftKey:Bool = false,
		keyCode:Int = 0);
	public override function clone():FocusEvent;
}
#else
typedef FocusEvent = openfl.events.FocusEvent;
#end
