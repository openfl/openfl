package openfl; #if !macro


import lime.system.System;
import openfl.display.Application;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.net.URLRequest;

#if (js && html5)
import js.Browser;
#end


@:access(openfl.display.Stage) class Lib {
	
	
	public static var application:Application;
	
	#if !flash
	public static var current (default, null):MovieClip = new MovieClip ();
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
	
	
	#if (js && html5)
	@:keep @:expose("openfl.embed")
	public static function embed (elementName:String, width:Null<Int> = null, height:Null<Int> = null, background:String = null, assetsPrefix:String = null) {
		
		System.embed (elementName, width, height, background, assetsPrefix);
		
	}
	#end
	
	
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
		
		#if (js && html5)
		Browser.window.open (request.url, target);
		#elseif flash
		return flash.Lib.getURL (request, target);
		#elseif desktop
		lime.tools.helpers.ProcessHelper.openURL (request.url);
		#end
		
	}
	
	
	public static function notImplemented (api:String):Void {
		
		if (!__sentWarnings.exists (api)) {
			
			__sentWarnings.set (api, true);
			
			trace ("Warning: " + api + " is not implemented");
			
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


#else


import haxe.macro.Compiler;
import haxe.macro.Context;


class Lib {
	
	
	public static function includeExterns ():Void {
		
		var childPath = Context.resolvePath ("extern/openfl");
		
		var parts = StringTools.replace (childPath, "\\", "/").split ("/");
		parts.pop ();
		
		Compiler.addClassPath (parts.join ("/"));
		
	}
	
	
}


#end