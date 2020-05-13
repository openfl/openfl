package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _NetStatusEvent extends _Event
{
	public var info:Dynamic;

	public static var __pool:ObjectPool<NetStatusEvent> = new ObjectPool<NetStatusEvent>(function() return new NetStatusEvent(null), function(event)
	{
		(event._ : _NetStatusEvent).__init();
	});

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, info:Dynamic = null):Void
	{
		this.info = info;

		super(type, bubbles, cancelable);
	}

	public override function clone():NetStatusEvent
	{
		var event = new NetStatusEvent(type, bubbles, cancelable, info);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("NetStatusEvent", ["type", "bubbles", "cancelable", "info"]);
	}

	public override function __init():Void
	{
		super.__init();
		info = null;
	}
}
