package openfl._legacy.feedback; #if openfl_legacy


import openfl.Lib;


class Haptic {
	
	
	public static function vibrate (period:Int = 0, duration:Int = 1000):Void {
		
		#if cpp
		lime_haptic_vibrate (period, duration);
		#end
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	#if cpp
	static var lime_haptic_vibrate = Lib.load ("lime-legacy", "lime_legacy_haptic_vibrate", 2);
	#end
	
	
}


#end