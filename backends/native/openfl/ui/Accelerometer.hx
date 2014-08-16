package openfl.ui;


import openfl.Lib;


class Accelerometer {
	
	
	public static function get ():Acceleration {
		
		return lime_input_get_acceleration ();
		
	}
	
	
	private static function __init__ () {
		
		lime_input_get_acceleration = Lib.load ("lime", "lime_input_get_acceleration", 0);
		
	}
	
	
	private static var lime_input_get_acceleration;
	
	
}
