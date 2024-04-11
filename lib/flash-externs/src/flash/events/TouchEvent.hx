package flash.events;

#if flash
import openfl.display.InteractiveObject;
import openfl.events.EventType;
import openfl.utils.ByteArray;

extern class TouchEvent extends Event
{
	public static var PROXIMITY_BEGIN(default, never):EventType<TouchEvent>;
	public static var PROXIMITY_END(default, never):EventType<TouchEvent>;
	public static var PROXIMITY_MOVE(default, never):EventType<TouchEvent>;
	public static var PROXIMITY_OUT(default, never):EventType<TouchEvent>;
	public static var PROXIMITY_OVER(default, never):EventType<TouchEvent>;
	public static var PROXIMITY_ROLL_OUT(default, never):EventType<TouchEvent>;
	public static var PROXIMITY_ROLL_OVER(default, never):EventType<TouchEvent>;
	public static var TOUCH_BEGIN(default, never):EventType<TouchEvent>;
	public static var TOUCH_END(default, never):EventType<TouchEvent>;
	public static var TOUCH_MOVE(default, never):EventType<TouchEvent>;
	public static var TOUCH_OUT(default, never):EventType<TouchEvent>;
	public static var TOUCH_OVER(default, never):EventType<TouchEvent>;
	public static var TOUCH_ROLL_OUT(default, never):EventType<TouchEvent>;
	public static var TOUCH_ROLL_OVER(default, never):EventType<TouchEvent>;
	public static var TOUCH_TAP(default, never):EventType<TouchEvent>;

	#if (haxe_ver < 4.3)
	public var altKey:Bool;
	public var commandKey:Bool;
	public var controlKey:Bool;
	public var ctrlKey:Bool;
	public var isPrimaryTouchPoint:Bool;
	public var isRelatedObjectInaccessible:Bool;
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
	#if air
	public var isTouchPointCanceled:Bool;
	public var timestamp:Float;
	public var touchIntent:TouchEventIntent;
	#end
	#else
	@:flash.property var altKey(get, set):Bool;
	@:flash.property var commandKey(get, set):Bool;
	@:flash.property var controlKey(get, set):Bool;
	@:flash.property var ctrlKey(get, set):Bool;
	@:flash.property var isPrimaryTouchPoint(get, set):Bool;
	@:flash.property var isRelatedObjectInaccessible(get, set):Bool;
	@:flash.property var localX(get, set):Float;
	@:flash.property var localY(get, set):Float;
	@:flash.property var pressure(get, set):Float;
	@:flash.property var relatedObject(get, set):InteractiveObject;
	@:flash.property var shiftKey(get, set):Bool;
	@:flash.property var sizeX(get, set):Float;
	@:flash.property var sizeY(get, set):Float;
	@:flash.property var stageX(get, set):Float;
	@:flash.property var stageY(get, set):Float;
	@:flash.property var touchPointID(get, set):Int;
	#if air
	@:flash.property public var isTouchPointCanceled(get, set):Bool;
	@:flash.property public var timestamp(get, set):Float;
	@:flash.property public var touchIntent(get, set):TouchEventIntent;
	#end
	#end
	public function new(type:String, bubbles:Bool = true, cancelable:Bool = false, touchPointID:Int = 0, isPrimaryTouchPoint:Bool = false, localX:Float = 0,
		localY:Float = 0, sizeX:Float = 0, sizeY:Float = 0, pressure:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false,
		altKey:Bool = false, shiftKey:Bool = false, commandKey:Bool = false, controlKey:Bool = false, timestamp:Float = 0, touchIntent:String = null,
		samples:ByteArray = null, isTouchPointCanceled:Bool = false
		#if air, commandKey:Bool = false, controlKey:Bool = false, ?timestamp:Float, ?touchIntent:TouchEventIntent, ?samples:ByteArray,
		isTouchPointCanceled:Bool = false #end);
	public override function clone():TouchEvent;
	#if air
	public function getSamples(buffer:ByteArray, append:Bool = false):Int;
	public function isToolButtonDown(index:Int):Bool;
	#end
	public function updateAfterEvent():Void;

	#if (haxe_ver >= 4.3)
	private function get_altKey():Bool;
	private function get_commandKey():Bool;
	private function get_controlKey():Bool;
	private function get_ctrlKey():Bool;
	private function get_isPrimaryTouchPoint():Bool;
	private function get_isRelatedObjectInaccessible():Bool;
	private function get_localX():Float;
	private function get_localY():Float;
	private function get_pressure():Float;
	private function get_relatedObject():InteractiveObject;
	private function get_shiftKey():Bool;
	private function get_sizeX():Float;
	private function get_sizeY():Float;
	private function get_stageX():Float;
	private function get_stageY():Float;
	private function get_touchPointID():Int;
	private function set_altKey(value:Bool):Bool;
	private function set_commandKey(value:Bool):Bool;
	private function set_controlKey(value:Bool):Bool;
	private function set_ctrlKey(value:Bool):Bool;
	private function set_isPrimaryTouchPoint(value:Bool):Bool;
	private function set_isRelatedObjectInaccessible(value:Bool):Bool;
	private function set_localX(value:Float):Float;
	private function set_localY(value:Float):Float;
	private function set_pressure(value:Float):Float;
	private function set_relatedObject(value:InteractiveObject):InteractiveObject;
	private function set_shiftKey(value:Bool):Bool;
	private function set_sizeX(value:Float):Float;
	private function set_sizeY(value:Float):Float;
	private function set_stageX(value:Float):Float;
	private function set_stageY(value:Float):Float;
	private function set_touchPointID(value:Int):Int;
	#if air
	private function get_isTouchPointCanceled():Bool;
	private function get_timestamp():Float;
	private function get_touchIntent():TouchEventIntent;
	private function set_isTouchPointCanceled(value:Bool):Bool;
	private function set_timestamp(value:Float):Float;
	private function set_touchIntent(value:TouchEventIntent):TouchEventIntent;
	#end
	#end
}
#else
typedef TouchEvent = openfl.events.TouchEvent;
#end
