package openfl;


import haxe.PosInfos;
import lime.system.System;
import lime.utils.Log;
import openfl._internal.Lib in InternalLib;
import openfl.display.Application;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.net.URLRequest;
import openfl.net.URLVariables;

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
	
	
	public static var application (get, never):Application;
	public static var current (get, never):MovieClip;
	
	@:noCompletion private static var __sentWarnings = new Map<String, Bool> ();
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Lib, {
			"application": { get: function () { return Lib.get_application (); } },
			"current": { get: function () { return Lib.get_current (); } }
		});
		
	}
	#end
	
	
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
	
	
	public static function getURL (request:URLRequest, target:String = null):Void {
		
		if (target == null) {
			
			target = "_blank";
			
		}
		
		#if flash
		return flash.Lib.getURL (request, target);
		#else
		var uri = request.url;
		
		if (Std.is (request.data, URLVariables)) {
			
			var query = "";
			var fields = Reflect.fields (request.data);
			
			for (field in fields) {
				
				if (query.length > 0) query += "&";
				query += StringTools.urlEncode (field) + "=" + StringTools.urlEncode (Std.string (Reflect.field (request.data, field)));
				
			}
			
			if (uri.indexOf ("?") > -1) {
				
				uri += "&" + query;
				
			} else {
				
				uri += "?" + query;
				
			}
			
		}
		
		System.openURL (uri, target);
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
	
	
	
	
	@:noCompletion private static function get_application ():Application {
		
		return InternalLib.application;
		
	}
	
	
	@:noCompletion private static function get_current ():MovieClip {
		
		#if flash
		return cast flash.Lib.current;
		#else
		if (InternalLib.current == null) InternalLib.current = new MovieClip ();
		return InternalLib.current;
		#end
		
	}
	
	
	// @:noCompletion private static function set_current (current:MovieClip):MovieClip {
		
	// 	return cast flash.Lib.current = cast current;
		
	// }
	
	
}