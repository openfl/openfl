package openfl.events; #if !flash #if (display || openfl_next || js)


import openfl.display.InteractiveObject;
import openfl.geom.Point;


class TouchEvent extends Event {
	
	
	public static inline var TOUCH_BEGIN:String = "touchBegin";
	public static inline var TOUCH_END:String = "touchEnd";
	public static inline var TOUCH_MOVE:String = "touchMove";
	public static inline var TOUCH_OUT:String = "touchOut";
	public static inline var TOUCH_OVER:String = "touchOver";
	public static inline var TOUCH_ROLL_OUT:String = "touchRollOut";
	public static inline var TOUCH_ROLL_OVER:String = "touchRollOver";
	public static inline var TOUCH_TAP:String = "touchTap";
	
	public var altKey:Bool;
	public var buttonDown:Bool;
	public var commandKey:Bool;
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
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, localX:Float = 0, localY:Float = 0, sizeX:Float = 1, sizeY:Float = 1, relatedObject:InteractiveObject = null, ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, buttonDown:Bool = false, delta:Int = 0, commandKey:Bool = false, clickCount:Int = 0) {
		
		super (type, bubbles, cancelable);
		
		this.shiftKey = shiftKey;
		this.altKey = altKey;
		this.ctrlKey = ctrlKey;
		this.bubbles = bubbles;
		this.relatedObject = relatedObject;
		this.delta = delta;
		this.localX = localX;
		this.localY = localY;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.buttonDown = buttonDown;
		this.commandKey = commandKey;
		
		pressure = 1;
		touchPointID = 0;
		isPrimaryTouchPoint = true;
		
	}
	
	
	public function updateAfterEvent ():Void {
		
		
		
	}
	
	
	@:noCompletion public static function __create (type:String, /*event:lime.ui.TouchEvent,*/ touch:Dynamic /*js.html.Touch*/, local:Point, target:InteractiveObject):TouchEvent {
		
		#if js
		var evt = new TouchEvent (type, true, false, local.x, local.y, null, false, false, false/*event.ctrlKey, event.altKey, event.shiftKey*/, false /* note: buttonDown not supported on w3c spec */, 0, 0);
		
		evt.stageX = Lib.current.stage.mouseX;
		evt.stageY = Lib.current.stage.mouseY;
		evt.target = target;
		
		return evt;
		#else
		return null;
		#end
		
	}
	
	
}


#else
typedef TouchEvent = openfl._v2.events.TouchEvent;
#end
#else
typedef TouchEvent = flash.events.TouchEvent;
#end