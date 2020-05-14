package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.net.URLRequestHeader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _HTTPStatusEvent extends _Event
{
	@:noCompletion private static var __pool:ObjectPool<HTTPStatusEvent> = new ObjectPool<HTTPStatusEvent>(function() return new HTTPStatusEvent(null),
		function(event)
		{
			(event._ : _Event).__init();
		});

	public var redirected:Bool;
	public var responseHeaders:Array<URLRequestHeader>;
	public var responseURL:String;
	public var status(default, null):Int;

	private var httpStatusEvent:HTTPStatusEvent;

	public function new(httpStatusEvent:HTTPStatusEvent, type:String, bubbles:Bool = false, cancelable:Bool = false, status:Int = 0,
			redirected:Bool = false):Void
	{
		this.httpStatusEvent = httpStatusEvent;

		this.status = status;
		this.redirected = redirected;

		super(httpStatusEvent, type, bubbles, cancelable);
	}

	public override function clone():HTTPStatusEvent
	{
		var event = new HTTPStatusEvent(type, bubbles, cancelable, status, redirected);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("HTTPStatusEvent", ["type", "bubbles", "cancelable", "status", "redirected"]);
	}

	public override function __init():Void
	{
		super.__init();
		status = 0;
		redirected = false;
	}
}
