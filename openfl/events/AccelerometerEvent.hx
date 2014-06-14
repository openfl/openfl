package openfl.events; #if !flash


import openfl.events.Event;


class AccelerometerEvent extends Event {
	
	
	public static var UPDATE:String;
	
	public var accelerationX:Float;
	public var accelerationY:Float;
	public var accelerationZ:Float;
	public var timestamp:Float;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false, timestamp:Float = 0, accelerationX:Float = 0, accelerationY:Float = 0, accelerationZ:Float = 0):Void {
		
		super (type, bubbles, cancelable);
		
		this.timestamp = timestamp;
		this.accelerationX = accelerationX;
		this.accelerationY = accelerationY;
		this.accelerationZ = accelerationZ;
		
	}
	
	
	public override function clone ():Event {
		
		return new AccelerometerEvent (type, bubbles, cancelable, timestamp, accelerationX, accelerationY, accelerationZ);
		
	}
	
	
	public override function toString ():String {
		
		return "[AccelerometerEvent type=" + type + " bubbles=" + bubbles + " cancelable=" + cancelable + " timestamp=" + timestamp + " accelerationX=" + accelerationX + " accelerationY=" + accelerationY + " accelerationZ=" + accelerationZ + "]";
		
	}
	
	
}


#else
typedef AccelerometerEvent = flash.events.AccelerometerEvent;
#end