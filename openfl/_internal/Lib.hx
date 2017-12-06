package openfl._internal;


import haxe.PosInfos;
import lime.utils.Log;
import openfl.display.Application;
import openfl.display.MovieClip;


class Lib {
	
	
	public static var application:Application;
	public static var current:MovieClip #if flash = flash.Lib.current #end;
	
	@:noCompletion private static var __sentWarnings = new Map<String, Bool> ();
	
	
	public static function notImplemented (?posInfo:PosInfos):Void {
		
		var api = posInfo.className + "." + posInfo.methodName;
		
		if (!__sentWarnings.exists (api)) {
			
			__sentWarnings.set (api, true);
			
			Log.warn (posInfo.methodName + " is not implemented", posInfo);
			
		}
		
	}
	
	
}