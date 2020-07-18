package openfl;

import haxe.Constraints.Function;
import haxe.PosInfos;
import haxe.Timer;
import openfl._internal.utils.Log;
import openfl._internal.Lib as InternalLib;
import openfl.display.Application;
import openfl.display.MovieClip;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
#if lime
import lime.system.System;
#end
#if (js && html5)
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Stage) class Lib
{
	public static var application(get, never):Application;
	public static var current(get, never):MovieClip;
	@:noCompletion private static var __lastTimerID:UInt = 0;
	@:noCompletion private static var __sentWarnings:Map<String, Bool> = new Map();
	@:noCompletion private static var __timers:Map<UInt, Timer> = new Map();
	#if 0
	private static var __unusedImports:Array<Class<Dynamic>> = [SWFLibrary, SWFLiteLibrary];
	#end

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Lib, {
			"application": {
				get: function()
				{
					return Lib.get_application();
				}
			},
			"current": {
				get: function()
				{
					return Lib.get_current();
				}
			}
		});
	}
	#end

	public static function as<T>(v:Dynamic, c:Class<T>):Null<T>
	{
		#if flash
		return flash.Lib.as(v, c);
		#else
		return #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (v, c) ? v : null;
		#end
	}

	public static function attach(name:String):MovieClip
	{
		#if flash
		return cast flash.Lib.attach(name);
		#else
		return new MovieClip();
		#end
	}

	public static function clearInterval(id:UInt):Void
	{
		if (__timers.exists(id))
		{
			var timer = __timers[id];
			timer.stop();
			__timers.remove(id);
		}
	}

	public static function clearTimeout(id:UInt):Void
	{
		if (__timers.exists(id))
		{
			var timer = __timers[id];
			timer.stop();
			__timers.remove(id);
		}
	}

	#if flash
	public static function eval(path:String):Dynamic
	{
		return flash.Lib.eval(path);
	}
	#end

	#if flash
	public static function fscommand(cmd:String, ?param:String)
	{
		return flash.Lib.fscommand(cmd, param);
	}
	#end

	public static function getDefinitionByName(name:String):Class<Dynamic>
	{
		if (name == null) return null;
		#if flash
		if (StringTools.startsWith(name, "openfl."))
		{
			var value = Type.resolveClass(name);
			if (value == null) value = Type.resolveClass(StringTools.replace(name, "openfl.", "flash."));
			return value;
		}
		#end
		return Type.resolveClass(name);
	}

	public static function getQualifiedClassName(value:Dynamic):String
	{
		if (value == null) return null;
		var ref = (value is Class) ? value : Type.getClass(value);
		if (ref == null)
		{
			if ((value is Bool) || value == Bool) return "Bool";
			else if ((value is Int) || value == Int) return "Int";
			else if ((value is Float) || value == Float) return "Float";
			// TODO: Array? Map?
			else
				return null;
		}
		return Type.getClassName(ref);
	}

	public static function getQualifiedSuperclassName(value:Dynamic):String
	{
		if (value == null) return null;
		var ref = (value is Class) ? value : Type.getClass(value);
		if (ref == null) return null;
		var parentRef = Type.getSuperClass(ref);
		if (parentRef == null) return null;
		return Type.getClassName(parentRef);
	}

	public static function getTimer():Int
	{
		#if lime
		#if flash
		return flash.Lib.getTimer();
		#else
		return System.getTimer();
		#end
		#else
		return 0;
		#end
	}

	public static function getURL(request:URLRequest, target:String = null):Void
	{
		navigateToURL(request, target);
	}

	public static function navigateToURL(request:URLRequest, window:String = null):Void
	{
		if (window == null)
		{
			window = "_blank";
		}

		#if flash
		return flash.Lib.getURL(request, window);
		#elseif lime
		var uri = request.url;

		if (Type.typeof(request.data) == Type.ValueType.TObject)
		{
			var query = "";
			var fields = Reflect.fields(request.data);

			for (field in fields)
			{
				if (query.length > 0) query += "&";
				query += StringTools.urlEncode(field) + "=" + StringTools.urlEncode(Std.string(Reflect.field(request.data, field)));
			}

			if (uri.indexOf("?") > -1)
			{
				uri += "&" + query;
			}
			else
			{
				uri += "?" + query;
			}
		}

		System.openURL(uri, window);
		#end
	}

	public static function notImplemented(?posInfo:PosInfos):Void
	{
		var api = posInfo.className + "." + posInfo.methodName;

		if (!__sentWarnings.exists(api))
		{
			__sentWarnings.set(api, true);

			Log.warn(posInfo.methodName + " is not implemented", posInfo);
		}
	}

	public static function preventDefaultTouchMove():Void
	{
		#if (js && html5)
		Browser.document.addEventListener("touchmove", function(evt:js.html.Event):Void
		{
			evt.preventDefault();
		}, false);
		#end
	}

	#if flash
	public static function redirectTraces()
	{
		return flash.Lib.redirectTraces();
	}
	#end

	public static function sendToURL(request:URLRequest):Void
	{
		var urlLoader = new URLLoader();
		urlLoader.load(request);
	}

	public static function setInterval(closure:Function, delay:Int, args:Array<Dynamic> = null):UInt
	{
		var id = ++__lastTimerID;
		var timer = new Timer(delay);
		__timers[id] = timer;
		timer.run = function()
		{
			Reflect.callMethod(closure, closure, args == null ? [] : args);
		};
		return id;
	}

	public static function setTimeout(closure:Function, delay:Int, args:Array<Dynamic> = null):UInt
	{
		var id = ++__lastTimerID;
		__timers[id] = Timer.delay(function()
		{
			Reflect.callMethod(closure, closure, args == null ? [] : args);
		}, delay);
		return id;
	}

	public static function trace(arg:Dynamic):Void
	{
		haxe.Log.trace(arg);
	}

	// Get & Set Methods
	@:noCompletion private static function get_application():Application
	{
		return InternalLib.application;
	}

	@:noCompletion private static function get_current():MovieClip
	{
		#if flash
		return cast flash.Lib.current;
		#else
		if (InternalLib.current == null) InternalLib.current = new MovieClip();
		return InternalLib.current;
		#end
	}

	// @:noCompletion private static function set_current (current:MovieClip):MovieClip {
	// 	return cast flash.Lib.current = cast current;
	// }
}
