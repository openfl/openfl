package openfl.events;

import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _FullScreenEvent extends _ActivityEvent
{
	public static var __pool:ObjectPool<FullScreenEvent> = new ObjectPool<FullScreenEvent>(function() return new FullScreenEvent(null), function(event)
	{
		(event._ : _Event).__init();
	});

	public var fullScreen:Bool;
	public var interactive:Bool;

	private var fullScreenEvent:FullScreenEvent;

	public function new(fullScreenEvent:FullScreenEvent, type:String, bubbles:Bool = false, cancelable:Bool = false, fullScreen:Bool = false,
			interactive:Bool = false)
	{
		this.fullScreenEvent = fullScreenEvent;

		// TODO: What is the "activating" value supposed to be?

		super(fullScreenEvent, type, bubbles, cancelable);

		this.fullScreen = fullScreen;
		this.interactive = interactive;
	}

	public override function clone():FullScreenEvent
	{
		var event = new FullScreenEvent(type, bubbles, cancelable, fullScreen, interactive);
		(event._ : _Event).target = target;
		(event._ : _Event).currentTarget = currentTarget;
		(event._ : _Event).eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("FullscreenEvent", ["type", "bubbles", "cancelable", "fullscreen", "interactive"]);
	}

	public override function __init():Void
	{
		super.__init();
		fullScreen = false;
		interactive = false;
	}
}
