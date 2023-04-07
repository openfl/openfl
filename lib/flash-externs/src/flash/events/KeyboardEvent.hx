package flash.events;

#if flash
import openfl.events.EventType;
import openfl.ui.KeyLocation;

extern class KeyboardEvent extends Event
{
	public static var KEY_DOWN(default, never):EventType<KeyboardEvent>;
	public static var KEY_UP(default, never):EventType<KeyboardEvent>;

	#if (haxe_ver < 4.3)
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
	#else
	@:flash.property var altKey(get, set):Bool;
	@:flash.property var charCode(get, set):UInt;
	@:flash.property var ctrlKey(get, set):Bool;
	@:flash.property var keyCode(get, set):UInt;
	@:flash.property var keyLocation(get, set):KeyLocation;
	@:flash.property var shiftKey(get, set):Bool;

	#if air
	@:flash.property public var commandKey(get, set):Bool;
	#elseif !openfl_doc_gen
	@:flash.property public var commandKey(get, set):Bool;
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
	@:flash.property public var controlKey(get, set):Bool;
	#elseif !openfl_doc_gen
	@:flash.property public var controlKey(get, set):Bool;
	private inline function get_controlKey():Bool
	{
		return false;
	}
	private inline function set_controlKey(value:Bool):Bool
	{
		return value;
	}
	#end
	#end
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, charCodeValue:UInt = 0, keyCodeValue:UInt = 0,
		keyLocationValue:KeyLocation = null, ctrlKeyValue:Bool = false, altKeyValue:Bool = false, shiftKeyValue:Bool = false, controlKeyValue:Bool = false,
		commandKeyValue:Bool = false);
	public override function clone():KeyboardEvent;

	#if (haxe_ver >= 4.3)
	private function get_altKey():Bool;
	private function get_charCode():UInt;
	private function get_ctrlKey():Bool;
	private function get_keyCode():UInt;
	private function get_keyLocation():KeyLocation;
	private function get_shiftKey():Bool;
	#if air
	private function get_commandKey():Bool;
	private function get_controlKey():Bool;
	#end
	private function set_altKey(value:Bool):Bool;
	private function set_charCode(value:UInt):UInt;
	private function set_ctrlKey(value:Bool):Bool;
	private function set_keyCode(value:UInt):UInt;
	private function set_keyLocation(value:KeyLocation):KeyLocation;
	private function set_shiftKey(value:Bool):Bool;
	#if air
	private function set_commandKey(value:Bool):Bool;
	private function set_controlKey(value:Bool):Bool;
	#end
	#end
}
#else
typedef KeyboardEvent = openfl.events.KeyboardEvent;
#end
