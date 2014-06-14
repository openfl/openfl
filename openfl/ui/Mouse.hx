package openfl.ui; #if !flash


import openfl.Lib;


@:access(openfl.display.Stage)
class Mouse {
	
	
	public static function hide ():Void {
		
		Lib.current.stage.__setCursorHidden (true);
		
	}
	
	
	public static function show ():Void {
		
		Lib.current.stage.__setCursorHidden (false);
		
	}
	
	
}


#else
typedef Mouse = flash.ui.Mouse;
#end