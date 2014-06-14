package openfl;


import haxe.Timer;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.net.URLRequest;

#if js
import js.html.HtmlElement;
import js.Browser;
#end


@:access(openfl.display.Stage) class Lib {
	
	
	#if !flash
	public static var current (default, null):MovieClip = new MovieClip ();
	#else
	public static var current (get, set):MovieClip;
	#end
	
	private static var __sentWarnings = new Map<String, Bool> ();
	private static var __startTime:Float = Timer.stamp ();
	
	
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
	
	
	#if flash
	public static function eval (path:String):Dynamic {
		
		return flash.Lib.eval (path);
		
	}
	
	
	public static function fscommand (cmd:String, ?param:String) {
		
		return flash.Lib.fscommand (cmd, param);
		
	}
	#end
	
	
	public static function getTimer ():Int {
		
		#if flash
		return flash.Lib.getTimer ();
		#else
		return Std.int ((Timer.stamp () - __startTime) * 1000);
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
	
	
	
	
	private static function get_current ():MovieClip {
		
		return flash.Lib.current;
		
	}
	
	
	private static function set_current (current:MovieClip):MovieClip {
		
		return flash.Lib.current = current;
		
	}
	
	
}