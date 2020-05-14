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

	public static var __pool:ObjectPool<TextEvent> = new ObjectPool<TextEvent>(function() return new TextEvent(null), function(event)
	{
		(event._ : _Event).__init();
	});

	private var textEvent:TextEvent;

	public function new(textEvent:TextEvent, type:String, bubbles:Bool = false, cancelable:Bool = false, text:String = "")
	{
		this.textEvent = textEvent;

		super(textEvent, type, bubbles, cancelable);

		this.text = text;
	}

	public override function clone():TextEvent
	{
		var event = new TextEvent(type, bubbles, cancelable, text);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("TextEvent", ["type", "bubbles", "cancelable", "text"]);
	}

	public override function __init():Void
	{
		super.__init();
		text = "";
	}
}
