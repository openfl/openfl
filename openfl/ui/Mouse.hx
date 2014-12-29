package openfl.ui; #if !flash #if (display || openfl_next || js)


import lime.ui.Mouse in LimeMouse;
import openfl.Lib;

@:access(openfl.display.Stage)


class Mouse {
	
	
	public static function hide ():Void {
		
		LimeMouse.hide ();
		
	}
	
	
	public static function show ():Void {
		
		LimeMouse.show ();
		
	}
	
	
}


#else
typedef Mouse = openfl._v2.ui.Mouse;
#end
#else
typedef Mouse = flash.ui.Mouse;
#end