package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _UncaughtErrorEvent extends _ErrorEvent
{
	public var error:Dynamic;

	public static var __pool:ObjectPool<UncaughtErrorEvent> = new ObjectPool<UncaughtErrorEvent>(function() return new UncaughtErrorEvent(null),
		function(event) event._.__init());

	public function new(type:String, bubbles:Bool = true, cancelable:Bool = true, error:Dynamic = null)
	{
		super(type, bubbles, cancelable);

		this.error = error;
	}

	public override function clone():UncaughtErrorEvent
	{
		var event = new UncaughtErrorEvent(type, bubbles, cancelable, error);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("UncaughtErrorEvent", ["type", "bubbles", "cancelable", "error"]);
	}

	public override function __init():Void
	{
		super._.__init();
		error = null;
	}
}
