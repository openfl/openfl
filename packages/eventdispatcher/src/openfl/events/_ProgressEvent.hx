package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _ProgressEvent extends _Event
{
	private static var __pool:ObjectPool<ProgressEvent> = new ObjectPool<ProgressEvent>(function() return new ProgressEvent(null), function(event)
	{
		(event._ : _Event).__init();
	});

	public var bytesLoaded:Float;
	public var bytesTotal:Float;

	private var progressEvent:ProgressEvent;

	public function new(progressEvent:ProgressEvent, type:String, bubbles:Bool = false, cancelable:Bool = false, bytesLoaded:Float = 0, bytesTotal:Float = 0)
	{
		this.progressEvent = progressEvent;

		super(progressEvent, type, bubbles, cancelable);

		this.bytesLoaded = bytesLoaded;
		this.bytesTotal = bytesTotal;
	}

	public override function clone():ProgressEvent
	{
		var event = new ProgressEvent(type, bubbles, cancelable, bytesLoaded, bytesTotal);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("ProgressEvent", ["type", "bubbles", "cancelable", "bytesLoaded", "bytesTotal"]);
	}

	public override function __init():Void
	{
		super.__init();
		bytesLoaded = 0;
		bytesTotal = 0;
	}
}
