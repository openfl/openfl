package openfl.events; #if !openfl_legacy


import openfl.display.InteractiveObject;
import openfl.geom.Point;


class MouseEvent extends Event {

	public static var pool:ObjectPool<MouseEvent> = new ObjectPool<MouseEvent>( function() { return new MouseEvent(); } );

	public static inline var CLICK = "click";
	public static inline var DOUBLE_CLICK = "doubleClick";
	public static inline var MIDDLE_CLICK = "middleClick";
	public static inline var MIDDLE_MOUSE_DOWN = "middleMouseDown";
	public static inline var MIDDLE_MOUSE_UP = "middleMouseUp";
	public static inline var MOUSE_DOWN = "mouseDown";
	public static inline var MOUSE_MOVE = "mouseMove";
	public static inline var MOUSE_OUT = "mouseOut";
	public static inline var MOUSE_OVER = "mouseOver";
	public static inline var MOUSE_UP = "mouseUp";
	public static inline var MOUSE_WHEEL = "mouseWheel";
	public static inline var RIGHT_CLICK = "rightClick";
	public static inline var RIGHT_MOUSE_DOWN = "rightMouseDown";
	public static inline var RIGHT_MOUSE_UP = "rightMouseUp";
	public static inline var ROLL_OUT = "rollOut";
	public static inline var ROLL_OVER = "rollOver";

	private static var __altKey:Bool;
	private static var __buttonDown:Bool;
	private static var __commandKey:Bool;
	private static var __ctrlKey:Bool;
	private static var __shiftKey:Bool;

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


	private function new (type:String = "unset", bubbles:Bool = true, cancelable:Bool = false) {
		super (type, bubbles, cancelable);
	}


	public static function __create (type:String, button:Int, stageX:Float, stageY:Float, local:Point, target:InteractiveObject, delta:Int = 0):MouseEvent {

		switch (type) {

			case MouseEvent.MOUSE_DOWN:

				__buttonDown = true;

			case MouseEvent.MOUSE_UP:

				__buttonDown = false;

			default:

		}

		var event = pool.get();

		event.type = type;
		event.bubbles = true;
		event.cancelable = false;
		event.altKey = __altKey;
		event.ctrlKey = __ctrlKey;
		event.shiftKey = __shiftKey;
		event.relatedObject = null;
		event.delta = delta;
		event.localX = local.x;
		event.localY = local.y;
		event.buttonDown = __buttonDown;
		event.commandKey = __commandKey;
		event.clickCount = 0;
		event.stageX = stageX;
		event.stageY = stageY;
		event.target = target;

		return event;

	}


	public override function toString ():String {

		return __formatToString ("MouseEvent",  [ "type", "bubbles", "cancelable", "localX", "localY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "buttonDown", "delta" ]);

	}


	public function updateAfterEvent ():Void {



	}

	override public function dispose()
	{
		pool.put(this);
	}

}


#else
typedef MouseEvent = openfl._legacy.events.MouseEvent;
#end
