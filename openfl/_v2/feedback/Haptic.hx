package openfl._v2.feedback; #if lime_legacy


import openfl.Lib;


class Haptic {
	
	
	public static function vibrate (period:Int = 0, duration:Int = 1000):Void {
		
		#if cpp
		lime_haptic_vibrate (period, duration);
		#end
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	#if cpp
	static var lime_haptic_vibrate = Lib.load ("lime", "lime_haptic_vibrate", 2);
	#end
	
	
}


#end