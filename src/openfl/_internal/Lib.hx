package openfl._internal;


import haxe.PosInfos;

#if !openfl_unit_testing
import openfl.display.Application;
import openfl.display.MovieClip;
#end

#if lime
import lime.utils.Log;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Lib {
	
	
	#if !openfl_unit_testing
	public static var application:Application;
	public static var current: MovieClip #if flash = flash.Lib.current #end;
	#end
	
	@:noCompletion private static var __sentWarnings = new Map<String, Bool> ();
	
	
	public static function notImplemented (?posInfo:PosInfos):Void {
		
		var api = posInfo.className + "." + posInfo.methodName;
		
		if (!__sentWarnings.exists (api)) {
			
			__sentWarnings.set (api, true);
			
			#if lime
			Log.warn (posInfo.methodName + " is not implemented", posInfo);
			#else
			trace (posInfo.methodName, posInfo);
			#end
			
		}
		
	}
	
	
}