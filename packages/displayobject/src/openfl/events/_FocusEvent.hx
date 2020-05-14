package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.display.InteractiveObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _FocusEvent extends _Event
{
	public var keyCode:Int;
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;

	private static var __pool:ObjectPool<FocusEvent> = new ObjectPool<FocusEvent>(function() return new FocusEvent(null), function(event)
	{
		(event._ : _Event).__init();
	});

	private var focusEvent:FocusEvent;

	public function new(focusEvent:FocusEvent, type:String, bubbles:Bool = false, cancelable:Bool = false, relatedObject:InteractiveObject = null,
			shiftKey:Bool = false, keyCode:Int = 0)
	{
		this.focusEvent = focusEvent;

		super(focusEvent, type, bubbles, cancelable);

		this.keyCode = keyCode;
		this.shiftKey = shiftKey;
		this.relatedObject = relatedObject;
	}

	public override function clone():FocusEvent
	{
		var event = new FocusEvent(type, bubbles, cancelable, relatedObject, shiftKey, keyCode);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("FocusEvent", ["type", "bubbles", "cancelable", "relatedObject", "shiftKey", "keyCode"]);
	}

	public override function __init():Void
	{
		super.__init();
		keyCode = 0;
		shiftKey = false;
		relatedObject = null;
	}
}
