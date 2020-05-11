package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _SampleDataEvent extends _Event
{
	public var data:ByteArray;
	public var position:Float;

	public static var __pool:ObjectPool<SampleDataEvent> = new ObjectPool<SampleDataEvent>(function() return new SampleDataEvent(null),
		function(event) event._.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		data = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		position = 0.0;
	}

	public override function clone():SampleDataEvent
	{
		var event = new SampleDataEvent(type, bubbles, cancelable);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("SampleDataEvent", ["type", "bubbles", "cancelable"]);
	}

	public override function __init():Void
	{
		super._.__init();
		data = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		position = 0.0;
	}
}
