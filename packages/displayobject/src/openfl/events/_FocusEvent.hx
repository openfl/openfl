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

	private static var __pool:ObjectPool<FocusEvent> = new ObjectPool<FocusEvent>(function() return new FocusEvent(null), function(event) event.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, relatedObject:InteractiveObject = null, shiftKey:Bool = false,
			keyCode:Int = 0)
	{
		super(type, bubbles, cancelable);

		this.keyCode = keyCode;
		this.shiftKey = shiftKey;
		this.relatedObject = relatedObject;
	}

	public override function clone():FocusEvent
	{
		var event = new FocusEvent(type, bubbles, cancelable, relatedObject, shiftKey, keyCode);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("FocusEvent", ["type", "bubbles", "cancelable", "relatedObject", "shiftKey", "keyCode"]);
	}

	private override function __init():Void
	{
		super.__init();
		keyCode = 0;
		shiftKey = false;
		relatedObject = null;
	}
}
