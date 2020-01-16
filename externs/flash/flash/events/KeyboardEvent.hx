package flash.events;

#if flash
import openfl.events.EventType;
import openfl.ui.KeyLocation;

extern class KeyboardEvent extends Event
{
	public static var KEY_DOWN(default, never):EventType<KeyboardEvent>;
	public static var KEY_UP(default, never):EventType<KeyboardEvent>;
	public var altKey:Bool;
	public var charCode:UInt;
	#if air
	public var commandKey:Bool;
	#elseif !openfl_doc_gen
	public var commandKey(get, set):Bool;
	private inline function get_commandKey():Bool
	{
		return false;
	}
	private inline function set_commandKey(value:Bool):Bool
	{
		return value;
	}
	#end
	#if air
	public var controlKey:Bool;
	#elseif !openfl_doc_gen
	public var controlKey(get, set):Bool;
	private inline function get_controlKey():Bool
	{
		return false;
	}
	private inline function set_controlKey(value:Bool):Bool
	{
		return value;
	}
	#end
	public var ctrlKey:Bool;
	public var keyCode:UInt;
	public var keyLocation:KeyLocation;
	public var shiftKey:Bool;
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, charCodeValue:UInt = 0, keyCodeValue:UInt = 0,
		keyLocationValue:KeyLocation = null, ctrlKeyValue:Bool = false, altKeyValue:Bool = false, shiftKeyValue:Bool = false, controlKeyValue:Bool = false,
		commandKeyValue:Bool = false);
	public override function clone():KeyboardEvent;
}
#else
typedef KeyboardEvent = openfl.events.KeyboardEvent;
#end
