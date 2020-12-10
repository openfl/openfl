package openfl.events;

#if !flash
// import openfl._internal.utils.ObjectPool;
import openfl.display.InteractiveObject;
import openfl.geom.Point;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class TouchEvent extends Event
{
	// @:noCompletion @:dox(hide) public static var PROXIMITY_BEGIN:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_END:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_MOVE:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_OUT:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_OVER:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_ROLL_OUT:String;
	// @:noCompletion @:dox(hide) public static var PROXIMITY_ROLL_OVER:String;
	public static inline var TOUCH_BEGIN:EventType<TouchEvent> = "touchBegin";
	public static inline var TOUCH_END:EventType<TouchEvent> = "touchEnd";
	public static inline var TOUCH_MOVE:EventType<TouchEvent> = "touchMove";
	public static inline var TOUCH_OUT:EventType<TouchEvent> = "touchOut";
	public static inline var TOUCH_OVER:EventType<TouchEvent> = "touchOver";
	public static inline var TOUCH_ROLL_OUT:EventType<TouchEvent> = "touchRollOut";
	public static inline var TOUCH_ROLL_OVER:EventType<TouchEvent> = "touchRollOver";
	public static inline var TOUCH_TAP:EventType<TouchEvent> = "touchTap";

	public var altKey:Bool;
	public var commandKey:Bool;
	public var controlKey:Bool;
	public var ctrlKey:Bool;
	@SuppressWarnings("checkstyle:FieldDocComment") @:noCompletion @:dox(hide) public var delta:Int;
	public var isPrimaryTouchPoint:Bool;
	#if false
	// @:noCompletion @:dox(hide) public var isRelatedObjectInaccessible:Bool;
	#end
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

	// @:noCompletion private static var __pool:ObjectPool<TouchEvent> = new ObjectPool<TouchEvent>(function() return new TouchEvent(null),
	// function(event) event.__init());

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
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
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

	@:noCompletion private static function __create(type:String, /*event:lime.ui.TouchEvent,*/ touch:Dynamic /*js.html.Touch*/, stageX:Float, stageY:Float,
			local:Point, target:InteractiveObject):TouchEvent
	{
		var evt = new TouchEvent(type, true, false, 0, true, local.x, local.y, 1, 1, 1);
		evt.stageX = stageX;
		evt.stageY = stageY;
		evt.target = target;

		return evt;
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
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
#else
typedef TouchEvent = flash.events.TouchEvent;
#end
