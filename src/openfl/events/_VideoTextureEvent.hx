package openfl.events;

// import openfl._internal.utils.ObjectPool;
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _VideoTextureEvent extends _Event
{
	@:isVar public var colorSpace:String;
	@:isVar public var status:String;

	// public static var __pool:ObjectPool<VideoTextureEvent> = new ObjectPool<VideoTextureEvent>(function() return new VideoTextureEvent(null),
	// 	function(event) event._.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, status:String = null, colorSpace:String = null)
	{
		super(type, bubbles, cancelable);
		this.status = status;
		this.colorSpace = colorSpace;
	}

	public override function clone():VideoTextureEvent
	{
		var event = new VideoTextureEvent(type, bubbles, cancelable, status, colorSpace);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("VideoTextureEvent", ["type", "bubbles", "cancelable", "status", "colorSpace"]);
	}

	public override function __init():Void
	{
		super.__init();
		status = null;
		colorSpace = null;
	}
}
