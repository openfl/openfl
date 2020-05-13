package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.display.DisplayObjectRenderer;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.ColorTransform)
@:noCompletion
@:beta class _RenderEvent extends _Event
{
	public var allowSmoothing:Bool;
	public var objectColorTransform:ColorTransform;
	public var objectMatrix:Matrix;
	public var renderer(default, null):DisplayObjectRenderer;

	public static var __pool:ObjectPool<RenderEvent> = new ObjectPool<RenderEvent>(function() return new RenderEvent(null), function(event) event.__init());

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, objectMatrix:Matrix = null, objectColorTransform:ColorTransform = null,
			allowSmoothing:Bool = true):Void
	{
		super(type, bubbles, cancelable);

		this.objectMatrix = objectMatrix;
		this.objectColorTransform = objectColorTransform;
		this.allowSmoothing = allowSmoothing;
	}

	public override function clone():RenderEvent
	{
		var event = new RenderEvent(type, bubbles, cancelable, objectMatrix.clone(), #if flash null #else objectColorTransform.__clone() #end, allowSmoothing);
		#if !flash
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		#end
		return event;
	}

	public override function toString():String
	{
		return __formatToString("RenderEvent", ["type", "bubbles", "cancelable"]);
	}

	public override function __init():Void
	{
		super.__init();
		objectMatrix = null;
		objectColorTransform = null;
		allowSmoothing = false;
		renderer = null;
	}
}
