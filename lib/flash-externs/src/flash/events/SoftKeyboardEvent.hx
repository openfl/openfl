package flash.events;

#if flash
import flash.display.InteractiveObject;
import openfl.events.EventType;

extern class SoftKeyboardEvent extends ErrorEvent
{
	public static var SOFT_KEYBOARD_ACTIVATE(default, never):EventType<SoftKeyboardEvent>;
	public static var SOFT_KEYBOARD_ACTIVATING(default, never):EventType<SoftKeyboardEvent>;
	public static var SOFT_KEYBOARD_DEACTIVATE(default, never):EventType<SoftKeyboardEvent>;
	public function new(type:String, bubbles:Bool, cancelable:Bool, relatedObjectVal:InteractiveObject, triggerTypeVal:SoftKeyboardTrigger);
	public override function clone():SoftKeyboardEvent;
}
#else
typedef SoftKeyboardEvent = openfl.events.SoftKeyboardEvent;
#end
