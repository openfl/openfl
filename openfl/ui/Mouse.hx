package openfl.ui; #if (!openfl_legacy || lime_hybrid)


import lime.ui.Mouse in LimeMouse;
import openfl.Lib;

@:access(openfl.display.Stage)


@:final class Mouse {
	
	
	public static function hide ():Void {
		
		LimeMouse.hide ();
		
	}
	
	
	public static function show ():Void {
		
		LimeMouse.show ();
		
	}
	
	
}


#else
typedef Mouse = openfl._legacy.ui.Mouse;
#end