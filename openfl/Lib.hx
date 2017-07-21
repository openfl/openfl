package openfl;


import haxe.PosInfos;
import lime.system.System;
import lime.utils.Log;
import openfl.display.Application;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.net.URLRequest;

#if swf
#if flash
import openfl._internal.swf.SWFLibrary;
#else
import openfl._internal.swf.SWFLiteLibrary; // workaround
#end
#end

#if (js && html5)
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:access(openfl.display.Stage) class Lib {
	
	
	public static var application:Application;
	
	#if !flash
	public static var current (default, null):MovieClip #if !macro = new MovieClip () #end;
	#else
	public static var current (get, set):MovieClip;
	#end
	
	@:noCompletion private static var __sentWarnings = new Map<String, Bool> ();
	
	
	public static function as<T> (v:Dynamic, c:Class<T>):Null<T> {
		
		#if flash
		return flash.Lib.as (v,c);
		#else
		return Std.is (v, c) ? v : null;
		#end
		
	}
	
	
	public static function attach (name:String):MovieClip {
		
		#if flash
		return cast flash.Lib.attach (name);
		#else
		return new MovieClip ();
		#end
		
	}
	
	
	#if flash
	public static function eval (path:String):Dynamic {
		
		return flash.Lib.eval (path);
		
	}
	#end
	
	
	#if flash
	public static function fscommand (cmd:String, ?param:String) {
		
		return flash.Lib.fscommand (cmd, param);
		
	}
	#end
	
	
	public static function getTimer ():Int {
		
		#if flash
		return flash.Lib.getTimer ();
		#else
		return System.getTimer ();
		#end
		
	}
	
	
	public static function getURL (request:URLRequest, target:String = null) {
		
		if (target == null) {
			
			target = "_blank";
			
		}
		
		#if flash
		return flash.Lib.getURL (request, target);
		#else
		System.openURL (request.url, target);
		#end
		
	}
	
	
	public static function notImplemented (?posInfo:PosInfos):Void {
		
		var api = posInfo.className + "." + posInfo.methodName;
		
		if (!__sentWarnings.exists (api)) {
			
			__sentWarnings.set (api, true);
			
			Log.warn (posInfo.methodName + " is not implemented", posInfo);
			
		}
		
	}
	
	
	public static function preventDefaultTouchMove ():Void {
		
		#if (js && html5)
		Browser.document.addEventListener ("touchmove", function (evt:js.html.Event):Void {
			
			evt.preventDefault ();
			
		}, false);
		#end
		
	}
	
	
	#if flash
	public static function redirectTraces () {
		
		return flash.Lib.redirectTraces ();
		
	}
	#end
	
	
	public static function trace (arg:Dynamic):Void {
		
		haxe.Log.trace (arg);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	#if flash
	@:noCompletion private static function get_current ():MovieClip {
		
		return cast flash.Lib.current;
		
	}
	
	
	@:noCompletion private static function set_current (current:MovieClip):MovieClip {
		
		return cast flash.Lib.current = cast current;
		
	}
	#end
	
	
}