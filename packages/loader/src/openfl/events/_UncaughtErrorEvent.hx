package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _UncaughtErrorEvent extends _ErrorEvent
{
	public static var __pool:ObjectPool<UncaughtErrorEvent> = new ObjectPool<UncaughtErrorEvent>(function() return new UncaughtErrorEvent(null),
		function(event)(event._:_Event).__init());

	public var error:Dynamic;

	private var uncaughtErrorEvent:UncaughtErrorEvent;

	public function new(uncaughtErrorEvent:UncaughtErrorEvent, type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null)
	{
		this.uncaughtErrorEvent = uncaughtErrorEvent;

		super(uncaughtErrorEvent, type, bubbles, cancelable);

		this.error = error;
	}

	public override function clone():UncaughtErrorEvent
	{
		var event = new UncaughtErrorEvent(type, bubbles, cancelable, error);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("UncaughtErrorEvent", ["type", "bubbles", "cancelable", "error"]);
	}

	public override function __init():Void
	{
		super.__init();
		error = null;
	}
}
