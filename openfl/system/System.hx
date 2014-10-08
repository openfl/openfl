package openfl.system; #if !flash #if (display || openfl_next || js)


class System {
	
	
	public static var totalMemory (get, null):Int;
	public static var useCodePage:Bool = false;
	public static var vmVersion (get, null):String;
	

	public static function exit (code:Int):Void {
		
		throw "System.exit is currently not supported for HTML5";
		
	}
	
	
	public static function gc ():Void {
		
		
		
	}
	
	
	public static function pause ():Void {
		
		throw "System.pause is currently not supported for HTML5";
		
	}
	
	
	public static function resume ():Void {
		
		throw "System.resume is currently not supported for HTML5";
		
	}
	
	
	public static function setClipboard (string:String):Void {
		
		throw "System.setClipboard is currently not supported for HTML5";
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private static function get_totalMemory ():Int {
		
		return 0;
		
	}
	
	
	@:noCompletion private static function get_vmVersion ():String {
		
		return "1.0.0";
		
	}
	
	
}


#else
typedef System = openfl._v2.system.System;
#end
#else
typedef System = flash.system.System;
#end