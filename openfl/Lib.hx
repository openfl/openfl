package openfl; #if !lime_legacy
#if !macro


import lime.system.System;
import openfl.display.Application;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.net.URLRequest;

#if js
import js.html.HtmlElement;
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
		return flash.Lib.attach (name);
		#else
		return new MovieClip ();
		#end
		
	}
	
	
	#if js
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
		
		#if js
		Browser.window.open (request.url, target);
		#elseif flash
		return flash.Lib.getURL (request, target);
		#end
		
	}
	
	
	public static function notImplemented (api:String):Void {
		
		if (!__sentWarnings.exists (api)) {
			
			__sentWarnings.set (api, true);
			
			trace ("Warning: " + api + " is not implemented");
			
		}
		
	}
	
	
	public static function preventDefaultTouchMove ():Void {
		
		#if js
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
		
		return flash.Lib.current;
		
	}
	
	
	@:noCompletion private static function set_current (current:MovieClip):MovieClip {
		
		return flash.Lib.current = current;
		
	}
	#end
	
	
}


#else


import haxe.macro.Compiler;
import haxe.macro.Context;
import sys.FileSystem;


class Lib {
	
	
	public static function includeBackend (type:String) {
		
		if (type == "native" || type == "legacy") {
			
			Compiler.define ("openfl");
			Compiler.define ("openfl_native");
			
			var paths = Context.getClassPath();
			
			for (path in paths) {
				
				if (FileSystem.exists (path + "/legacy/openfl")) {
					
					Compiler.addClassPath (path + "/legacy");
					
				}
				
			}
			
		}
		
	}
	
	
}


#end
#else
typedef Lib = openfl._v2.Lib;
#end
