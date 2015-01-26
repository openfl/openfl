package openfl._v2.events; #if lime_legacy


import openfl.display.InteractiveObject;
import openfl.geom.Point;


class MouseEvent extends Event {
	
	
	public static var DOUBLE_CLICK:String = "doubleClick";
	public static var CLICK:String = "click";
	public static var MIDDLE_CLICK:String = "middleClick";
	public static var MIDDLE_MOUSE_DOWN:String = "middleMouseDown";
	public static var MIDDLE_MOUSE_UP:String = "middleMouseUp";
	public static var MOUSE_DOWN:String = "mouseDown";
	public static var MOUSE_MOVE:String = "mouseMove";
	public static var MOUSE_OUT:String = "mouseOut";
	public static var MOUSE_OVER:String = "mouseOver";
	public static var MOUSE_UP:String = "mouseUp";
	public static var MOUSE_WHEEL:String = "mouseWheel";
	public static var RIGHT_CLICK:String = "rightClick";
	public static var RIGHT_MOUSE_DOWN:String = "rightMouseDown";
	public static var RIGHT_MOUSE_UP:String = "rightMouseUp";
	public static var ROLL_OUT:String = "rollOut";
	public static var ROLL_OVER:String = "rollOver";
	
	public var altKey:Bool;
	public var buttonDown:Bool;
	public var clickCount:Int;
	public var commandKey:Bool;
	public var ctrlKey:Bool;
	public var delta:Int;
	public var localX:Float;
	public var localY:Float;
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	public var stageX:Float;
	public var stageY:Float;
	
	private static var efLeftDown = 0x0001;
	private static var efShiftDown = 0x0002;
	private static var efCtrlDown = 0x0004;
	private static var efAltDown = 0x0008;
	private static var efCommandDown = 0x0010;
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, localX:Float = 0, localY:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, buttonDown:Bool = false, delta:Int = 0, commandKey:Bool = false, clickCount:Int = 0) {
		
		super (type, bubbles, cancelable);
		
		this.localX = localX;
		this.localY = localY;
		this.relatedObject = relatedObject;
		this.ctrlKey = ctrlKey;
		this.altKey = altKey;
		this.shiftKey = shiftKey;
		this.buttonDown = buttonDown;
		this.delta = delta;
		this.commandKey = commandKey;
		this.clickCount = clickCount;
		
	}
	
	
	public override function clone ():Event {
		
		return new MouseEvent (type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, clickCount);
		
	}
	
	
	public override function toString ():String {
		
		return "[MouseEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " localX=" + localX + " localY=" + localY + " relatedObject=" + relatedObject + " ctrlKey=" + ctrlKey + " altKey=" + altKey + " shiftKey=" + shiftKey + " buttonDown=" + buttonDown + " delta=" + delta + "]";
		
	}
	
	
	public function updateAfterEvent ():Void {
		
		
		
	}
	
	
	@:noCompletion public static function __create (type:String, event:Dynamic, local:Point, target:InteractiveObject):MouseEvent {
		
		var flags:Int = event.flags;
		var mouseEvent = new MouseEvent (type, true, true, local.x, local.y, null, (flags & efCtrlDown) != 0, (flags & efAltDown) != 0, (flags & efShiftDown) != 0, (flags & efLeftDown) != 0, 0, 0);
		mouseEvent.stageX = event.x;
		mouseEvent.stageY = event.y;
		mouseEvent.target = target;
		return mouseEvent;
		
	}
	
	
	@:noCompletion public function __createSimilar (type:String, related:InteractiveObject = null, target:InteractiveObject = null):MouseEvent {
		
		var mouseEvent = new MouseEvent (type, bubbles, cancelable, localX, localY, related == null ? relatedObject : related, ctrlKey, altKey, shiftKey, buttonDown, delta, commandKey, clickCount);
		
		mouseEvent.stageX = stageX;
		mouseEvent.stageY = stageY;

		if (target != null) {
			
			mouseEvent.target = target;
			
		}
		
		return mouseEvent;
		
	}
	
	
}


#end