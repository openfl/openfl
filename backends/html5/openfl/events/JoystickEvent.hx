package openfl.events;


import openfl.events.Event;


class JoystickEvent extends Event {
	
	
	public static inline var AXIS_MOVE:String = "axisMove";
	public static inline var BALL_MOVE:String = "ballMove";
	public static inline var BUTTON_DOWN:String = "buttonDown";
	public static inline var BUTTON_UP:String = "buttonUp";
	public static inline var HAT_MOVE:String = "hatMove";
	public static inline var DEVICE_ADDED:String = "deviceAdded";
	public static inline var DEVICE_REMOVED:String = "deviceRemoved";
	
	public var axis:Array<Float>;
	public var device:Int;
	public var id:Int;
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, device:Int = 0, id:Int = 0, x:Float = 0, y:Float = 0, z:Float = 0) {
		
		super (type, bubbles, cancelable);
		
		this.device = device;
		this.id = id;
		this.x = x;
		this.y = y;
		this.z = z;

		axis = [ x, y, z, 0, 0, 0 ];
		
	}
	
	
	public override function clone ():Event {
		
		return new JoystickEvent (type, bubbles, cancelable, device, id, x, y, z);
		
	}
	
	
	public override function toString ():String {
		
		return "[JoystickEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " device=" + device + " id=" + id + " x=" + x + " y=" + y + " z=" + z + "]";
		
	}
	
	
}