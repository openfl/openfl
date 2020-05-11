package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.events._Event;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _TextEvent extends _Event
{
	public var text:String;

	public static var __pool:ObjectPool<TextEvent> = new ObjectPool<TextEvent>(function() return new TextEvent(null), function(event) event._.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "")
	{
		super(type, bubbles, cancelable);

		this.text = text;
	}

	public override function clone():TextEvent
	{
		var event = new TextEvent(type, bubbles, cancelable, text);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("TextEvent", ["type", "bubbles", "cancelable", "text"]);
	}

	public override function __init():Void
	{
		super._.__init();
		text = "";
	}
}
