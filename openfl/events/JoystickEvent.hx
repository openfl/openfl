package openfl.events;
#if (display)


extern class JoystickEvent extends Event
{	
	static var AXIS_MOVE:String;
	static var BALL_MOVE:String;
	static var BUTTON_DOWN:String;
	static var BUTTON_UP:String;
	static var HAT_MOVE:String;
	
	var axis:Array<Float>;
	var device:Int;
	var id:Int;
	var x:Float;
	var y:Float;
	var z:Float;
	
	function new(type:String, bubbles:Bool = false, cancelable:Bool = false, device:Int = 0, id:Int = 0, x:Float = 0, y:Float = 0, z:Float = 0):Void;
}


#end
