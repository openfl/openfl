package openfl;


import haxe.Constraints.Function;
import haxe.PosInfos;
import haxe.Timer;
import lime.system.System;
import lime.utils.Log;
import openfl._internal.Lib in InternalLib;
import openfl.display.Application;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.net.URLLoader;
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
	
	private static var __lastTimerID:UInt = 0;
	private static var __sentWarnings = new Map<String, Bool> ();
	private static var __timers = new Map<UInt, Timer> ();
	
	
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
	
	
	public static function clearInterval (id:UInt):Void {
		
		if (__timers.exists (id)) {
			
			var timer = __timers[id];
			timer.stop ();
			__timers.remove (id);
			
		}
		
	}
	
	
	public static function clearTimeout (id:UInt):Void {
		
		if (__timers.exists (id)) {
			
			var timer = __timers[id];
			timer.stop ();
			__timers.remove (id);
			
		}
		
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
	
	
	public static function getDefinitionByName (name:String):Class<Dynamic> {
		
		return Type.resolveClass (name);
		
	}
	
	
	public static function getQualifiedClassName (value:Dynamic):String {
		
		return Type.getClassName (Type.getClass (value));
		
	}
	
	
	public static function getQualifiedSuperclassName (value:Dynamic):String {
		
		var ref = Type.getSuperClass (Type.getClass (value));
		return (ref != null ? Type.getClassName (ref) : null);
		
	}
	
	
	public static function getTimer ():Int {
		
		#if flash
		return flash.Lib.getTimer ();
		#else
		return System.getTimer ();
		#end
		
	}
	
	
	public static function getURL (request:URLRequest, target:String = null):Void {
		
		navigateToURL (request, target);
		
	}
	
	
	public static function navigateToURL (request:URLRequest, window:String = null):Void {
		
		if (window == null) {
			
			window = "_blank";
			
		}
		
		#if flash
		return flash.Lib.getURL (request, window);
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
		
		System.openURL (uri, window);
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
	
	
	public static function sendToURL (request:URLRequest):Void {
		
		var urlLoader = new URLLoader ();
		urlLoader.load (request);
		
	}
	
	
	public static function setInterval (closure:Function, delay:Int, args:Array<Dynamic>):UInt {
		
		var id = ++__lastTimerID;
		var timer = new Timer (delay);
		__timers[id] = timer;
		timer.run = function () {
			
			Reflect.callMethod (closure, closure, args);
			
		};
		return id;
		
	}
	
	
	public static function setTimeout (closure:Function, delay:Int, args:Array<Dynamic>):UInt {
		
		var id = ++__lastTimerID;
		__timers[id] = Timer.delay (function () {
			
			Reflect.callMethod (closure, closure, args);
			
		}, delay);
		return id;
		
	}
	
	
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