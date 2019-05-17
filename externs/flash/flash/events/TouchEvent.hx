package flash.events;

#if flash
import openfl.display.InteractiveObject;
import openfl.events.EventType;
import openfl.utils.ByteArray;

extern class TouchEvent extends Event
{
	#if flash
	public static var PROXIMITY_BEGIN(default, never):EventType<TouchEvent>;
	#end
	#if flash
	public static var PROXIMITY_END(default, never):EventType<TouchEvent>;
	#end
	#if flash
	public static var PROXIMITY_MOVE(default, never):EventType<TouchEvent>;
	#end
	#if flash
	public static var PROXIMITY_OUT(default, never):EventType<TouchEvent>;
	#end
	#if flash
	public static var PROXIMITY_OVER(default, never):EventType<TouchEvent>;
	#end
	#if flash
	public static var PROXIMITY_ROLL_OUT(default, never):EventType<TouchEvent>;
	#end
	#if flash
	public static var PROXIMITY_ROLL_OVER(default, never):EventType<TouchEvent>;
	#end
	public static var TOUCH_BEGIN(default, never):EventType<TouchEvent>;
	public static var TOUCH_END(default, never):EventType<TouchEvent>;
	public static var TOUCH_MOVE(default, never):EventType<TouchEvent>;
	public static var TOUCH_OUT(default, never):EventType<TouchEvent>;
	public static var TOUCH_OVER(default, never):EventType<TouchEvent>;
	public static var TOUCH_ROLL_OUT(default, never):EventType<TouchEvent>;
	public static var TOUCH_ROLL_OVER(default, never):EventType<TouchEvent>;
	public static var TOUCH_TAP(default, never):EventType<TouchEvent>;
	public var altKey:Bool;
	public var commandKey:Bool;
	public var controlKey:Bool;
	public var ctrlKey:Bool;
	public var delta:Int;
	public var isPrimaryTouchPoint:Bool;
	#if flash
	public var isRelatedObjectInaccessible:Bool;
	#end
	#if air
	public var isTouchPointCanceled:Bool;
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
	#if air
	public var timestamp:Float;
	public var touchIntent:TouchEventIntent;
	#end
	public var touchPointID:Int;
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, touchPointID:Int = 0, isPrimaryTouchPoint:Bool = false, localX:Float = 0,
		localY:Float = 0, sizeX:Float = 0, sizeY:Float = 0, pressure:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false,
		altKey:Bool = false, shiftKey:Bool = false, commandKey:Bool = false, controlKey:Bool = false, timestamp:Float = 0, touchIntent:String = null,
		samples:ByteArray = null, isTouchPointCanceled:Bool = false
		#if air, commandKey:Bool = false, controlKey:Bool = false, ?timestamp:Float, ?touchIntent:TouchEventIntent, ?samples:flash.utils.ByteArray,
		isTouchPointCanceled:Bool = false #end);
	public override function clone():TouchEvent;
	#if air
	public function getSamples(buffer:ByteArray, append:Bool = false):Int;
	public function isToolButtonDown(index:Int):Bool;
	#end
	public function updateAfterEvent():Void;
}
#else
typedef TouchEvent = openfl.events.TouchEvent;
#end
