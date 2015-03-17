package openfl._legacy.ui; #if openfl_legacy


import openfl.Lib;


class Mouse {
	
	
	public static function hide ():Void {
		
		if (Lib.stage != null) {
			
			Lib.stage.showCursor (false);
			
		}
		
	}
	
	
	public static function show ():Void {
		
		if (Lib.stage != null) {
			
			Lib.stage.showCursor (true);
			
		}
		
	}
	
	
}


#end