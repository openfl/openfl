package openfl.events;


import openfl.display.InteractiveObject;
import openfl.geom.Point;
import openfl.utils.ByteArray;


class TouchEvent extends Event {
	
	
	public static inline var TOUCH_BEGIN = "touchBegin";
	public static inline var TOUCH_END = "touchEnd";
	public static inline var TOUCH_MOVE = "touchMove";
	public static inline var TOUCH_OUT = "touchOut";
	public static inline var TOUCH_OVER = "touchOver";
	public static inline var TOUCH_ROLL_OUT = "touchRollOut";
	public static inline var TOUCH_ROLL_OVER = "touchRollOver";
	public static inline var TOUCH_TAP = "touchTap";
	
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
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, touchPointID:Int = 0, isPrimaryTouchPoint:Bool = false, localX:Float = 0, localY:Float = 0, sizeX:Float = 0, sizeY:Float = 0, pressure:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, commandKey:Bool = false, controlKey:Bool = false, timestamp:Float = 0, touchIntent:String = null, samples:ByteArray = null, isTouchPointCanceled:Bool = false) {
		
		super (type, bubbles, cancelable);
		
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
	
	
	public override function clone ():Event {
		
		var event = new TouchEvent (type, bubbles, cancelable, touchPointID, isPrimaryTouchPoint, localX, localY, sizeX, sizeY, pressure, relatedObject, ctrlKey, altKey, shiftKey, commandKey, controlKey);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("TouchEvent",  [ "type", "bubbles", "cancelable", "touchPointID", "isPrimaryTouchPoint", "localX", "localY", "sizeX", "sizeY", "pressure", "relatedObject", "ctrlKey", "altKey", "shiftKey", "commandKey", "controlKey" ]);
		
	}
	
	
	public function updateAfterEvent ():Void {
		
		
		
	}
	
	
	public static function __create (type:String, /*event:lime.ui.TouchEvent,*/ touch:Dynamic /*js.html.Touch*/, stageX:Float, stageY:Float, local:Point, target:InteractiveObject):TouchEvent {
		
		var evt = new TouchEvent (type, true, false, 0, true, local.x, local.y, 1, 1, 1);
		evt.stageX = stageX;
		evt.stageY = stageY;
		evt.target = target;
		
		return evt;
		
	}
	
	
}