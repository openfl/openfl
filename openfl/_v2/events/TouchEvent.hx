package openfl._v2.events; #if lime_legacy


import openfl.display.InteractiveObject;
import openfl.geom.Point;


class TouchEvent extends MouseEvent {
	
	
	public static var TOUCH_BEGIN:String = "touchBegin";
	public static var TOUCH_END:String = "touchEnd";
	public static var TOUCH_MOVE:String = "touchMove";
	public static var TOUCH_OUT:String = "touchOut";
	public static var TOUCH_OVER:String = "touchOver";
	public static var TOUCH_ROLL_OUT:String = "touchRollOut";
	public static var TOUCH_ROLL_OVER:String = "touchRollOver";
	public static var TOUCH_TAP:String = "touchTap";
	
	public var isPrimaryTouchPoint:Bool;
	public var pressure:Float;
	public var sizeX:Float;
	public var sizeY:Float;
	public var touchPointID:Int;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, localX:Float = 0, localY:Float = 0, sizeX:Float = 1, sizeY:Float = 1, relatedObject:InteractiveObject = null, ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, buttonDown:Bool = false, delta:Int = 0, commandKey:Bool = false, clickCount:Int = 0) {
		
		super (type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, clickCount);
		
		pressure = 1;
		touchPointID = 0;
		isPrimaryTouchPoint = true;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		
	}
	
	
	@:noCompletion public static function __create (type:String, event:Dynamic, local:Point, target:InteractiveObject, sizeX:Float, sizeY:Float):TouchEvent {
		
		var flags:Int = event.flags;
		var touchEvent = new TouchEvent (type, true, false, local.x, local.y, sizeX, sizeY, null, (flags & MouseEvent.efCtrlDown) != 0, (flags & MouseEvent.efAltDown) != 0, (flags & MouseEvent.efShiftDown) != 0, (flags & MouseEvent.efLeftDown) != 0, 0, 0);
		touchEvent.stageX = event.x;
		touchEvent.stageY = event.y;
		touchEvent.target = target;
		return touchEvent;
		
	}
	
	
	@:noCompletion override public function __createSimilar (type:String, related:InteractiveObject = null, target:InteractiveObject = null):MouseEvent {
		
		var touchEvent = new TouchEvent (type, bubbles, cancelable, localX, localY, sizeX, sizeY, related == null ? relatedObject : related, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, clickCount);
		
		touchEvent.touchPointID = touchPointID;
		touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
		
		if (target != null) {
			
			touchEvent.target = target;
			
		}
		
		return touchEvent;
		
	}
	
	
}


#end