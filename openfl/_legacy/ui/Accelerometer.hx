package openfl._legacy.ui; #if openfl_legacy


import openfl.Lib;


class Accelerometer {
	
	
	public static function get ():Acceleration {
		
		return lime_input_get_acceleration ();
		
	}
	
	
	private static var lime_input_get_acceleration = Lib.load ("lime-legacy", "lime_legacy_input_get_acceleration", 0);
	
	
}


#end