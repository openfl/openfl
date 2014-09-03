package openfl.events;


import openfl.display.InteractiveObject;
import openfl.geom.Point;


class MouseEvent extends Event {
	
	
	public static var CLICK:String = "click";
	public static var DOUBLE_CLICK:String = "doubleClick";
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

	private static var __buttonDown:Bool;
	
	public var altKey:Bool;
	public var buttonDown:Bool;
	public var commandKey:Bool;
	public var clickCount:Int;
	public var ctrlKey:Bool;
	public var delta:Int;
	public var localX:Float;
	public var localY:Float;
	public var relatedObject:InteractiveObject;
	public var shiftKey:Bool;
	public var stageX:Float;
	public var stageY:Float;
	
	
	public function new (type:String, bubbles:Bool = true, cancelable:Bool = false, localX:Float = 0, localY:Float = 0, relatedObject:InteractiveObject = null, ctrlKey:Bool = false, altKey:Bool = false, shiftKey:Bool = false, buttonDown:Bool = false, delta:Int = 0, commandKey:Bool = false, clickCount:Int = 0) {
		
		super (type, bubbles, cancelable);
		
		this.shiftKey = shiftKey;
		this.altKey = altKey;
		this.ctrlKey = ctrlKey;
		this.bubbles = bubbles;
		this.relatedObject = relatedObject;
		this.delta = delta;
		this.localX = localX;
		this.localY = localY;
		this.buttonDown = buttonDown;
		this.commandKey = commandKey;
		this.clickCount = clickCount;
		
	}
	
	
	public static function __create (type:String, event:js.html.MouseEvent, local:Point, target:InteractiveObject):MouseEvent {
		
		var delta = 2;
		
		if (type == MouseEvent.MOUSE_WHEEL) {
			
			var mouseEvent:Dynamic = event;
			delta = mouseEvent.deltaY > 0 ? 1 : -1;
			
		}
		
		// source: http://unixpapa.com/js/mouse.html
		if (type == MouseEvent.MOUSE_DOWN) {
			
			__buttonDown = true;
			
		} else if (type == MouseEvent.MOUSE_UP) {
			
			__buttonDown = false;
			
		}
		
		var pseudoEvent = new MouseEvent (type, true, false, local.x, local.y, null, event.ctrlKey, event.altKey, event.shiftKey, __buttonDown, delta);
		pseudoEvent.stageX = Lib.current.stage.mouseX;
		pseudoEvent.stageY = Lib.current.stage.mouseY;
		pseudoEvent.target = target;
		
		return pseudoEvent;
		
	}
	
	
	public function updateAfterEvent ():Void {
		
		
		
	}
	
	
}
