package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.ui.KeyLocation;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _KeyboardEvent extends _Event
{
	public var altKey:Bool;
	public var charCode:Int;
	public var commandKey:Bool;
	public var controlKey:Bool;
	public var ctrlKey:Bool;
	public var keyCode:Int;
	public var keyLocation:KeyLocation;
	public var shiftKey:Bool;

	public static var __pool:ObjectPool<KeyboardEvent> = new ObjectPool<KeyboardEvent>(function() return new KeyboardEvent(null),
		function(event) event._.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, charCodeValue:Int = 0, keyCodeValue:Int = 0,
			keyLocationValue:KeyLocation = null, ctrlKeyValue:Bool = false, altKeyValue:Bool = false, shiftKeyValue:Bool = false,
			controlKeyValue:Bool = false, commandKeyValue:Bool = false)
	{
		super(type, bubbles, cancelable);

		charCode = charCodeValue;
		keyCode = keyCodeValue;
		keyLocation = keyLocationValue != null ? keyLocationValue : KeyLocation.STANDARD;
		ctrlKey = ctrlKeyValue;
		altKey = altKeyValue;
		shiftKey = shiftKeyValue;

		#if !openfl_doc_gen
		controlKey = controlKeyValue;
		commandKey = commandKeyValue;
		#end
	}

	public override function clone():KeyboardEvent
	{
		var event = new KeyboardEvent(type, bubbles, cancelable, charCode, keyCode, keyLocation, ctrlKey, altKey, shiftKey
			#if !openfl_doc_gen, controlKey, commandKey #end);

		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("KeyboardEvent", [
			"type",
			"bubbles",
			"cancelable",
			"charCode",
			"keyCode",
			"keyLocation",
			"ctrlKey",
			"altKey",
			"shiftKey"
		]);
	}

	public override function __init():Void
	{
		super._.__init();
		charCode = 0;
		keyCode = 0;
		keyLocation = STANDARD;
		ctrlKey = false;
		altKey = false;
		shiftKey = false;

		#if !openfl_doc_gen
		controlKey = false;
		commandKey = false;
		#end
	}
}
