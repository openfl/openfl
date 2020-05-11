package openfl.events;

import openfl._internal.utils.ObjectPool;
import openfl.display.InteractiveObject;
import openfl.geom.Point;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _TouchEvent extends _Event
{
	public var altKey:Bool;
	public var commandKey:Bool;
	public var controlKey:Bool;
	public var ctrlKey:Bool;
	public var delta:Int;
	public var isPrimaryTouchPoint:Bool;
	public var localX:Float;
	public var localY:Float;
	public var pressure:Float;
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	public var sizeX:Float;
	public var sizeY:Float;
	public var stageX:Float;
	public var stageY:Float;
	public var touchPointID:Int;

	public static var __pool:ObjectPool<TouchEvent> = new ObjectPool<TouchEvent>(function() return new TouchEvent(null), function(event) event._.__init());

	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, touchPointID:Int = 0, isPrimaryTouchPoint:Bool = false, localX:Float = 0,
			localY:Float = 0, sizeX:Float = 0, sizeY:Float = 0, pressure:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false,
			altKey:Bool = false, shiftKey:Bool = false, commandKey:Bool = false, controlKey:Bool = false, timestamp:Float = 0, touchIntent:String = null,
			samples:ByteArray = null, isTouchPointCanceled:Bool = false)
	{
		super(type, bubbles, cancelable);

		this.touchPointID = touchPointID;
		this.isPrimaryTouchPoint = isPrimaryTouchPoint;
		this.localX = localX;
		this.localY = localY;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.pressure = pressure;
		this.relatedObject = relatedObject;
		this.ctrlKey = ctrlKey;
		this.altKey = altKey;
		this.shiftKey = shiftKey;
		this.commandKey = commandKey;
		this.controlKey = controlKey;

		stageX = Math.NaN;
		stageY = Math.NaN;
	}

	public override function clone():TouchEvent
	{
		var event = new TouchEvent(type, bubbles, cancelable, touchPointID, isPrimaryTouchPoint, localX, localY, sizeX, sizeY, pressure, relatedObject,
			ctrlKey, altKey, shiftKey, commandKey, controlKey);
		event._.target = target;
		event._.currentTarget = currentTarget;
		event._.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("TouchEvent", [
			"type", "bubbles", "cancelable", "touchPointID", "isPrimaryTouchPoint", "localX", "localY", "sizeX", "sizeY", "pressure", "relatedObject",
			"ctrlKey", "altKey", "shiftKey", "commandKey", "controlKey"
		]);
	}

	public function updateAfterEvent():Void {}

	public static function __create(type:String, /*event:lime.ui.TouchEvent,*/ touch:Dynamic /*js.html.Touch*/, stageX:Float, stageY:Float, local:Point,
			target:InteractiveObject):TouchEvent
	{
		var evt = new TouchEvent(type, true, false, 0, true, local.x, local.y, 1, 1, 1);
		evt._.stageX = stageX;
		evt._.stageY = stageY;
		evt._.target = target;

		return evt;
	}

	public override function __init():Void
	{
		super._.__init();
		touchPointID = 0;
		isPrimaryTouchPoint = false;
		localX = 0;
		localY = 0;
		sizeX = 0;
		sizeY = 0;
		pressure = 0;
		relatedObject = null;
		ctrlKey = false;
		altKey = false;
		shiftKey = false;
		commandKey = false;
		controlKey = false;

		stageX = Math.NaN;
		stageY = Math.NaN;
	}
}
