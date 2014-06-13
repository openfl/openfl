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
	
	
	public static var current (default, null):MovieClip = new MovieClip ();
	
	private static var __sentWarnings = new Map<String, Bool> ();
	private static var __startTime:Float = Timer.stamp ();
	
	
	public static function as<T> (v:Dynamic, c:Class<T>):Null<T> {
		
		return Std.is (v, c) ? v : null;
		
	}
	
	
	public static function attach (name:String):MovieClip {
		
		return new MovieClip ();
		
	}
	
	
	public static function getTimer ():Int {
		
		return Std.int ((Timer.stamp () - __startTime) * 1000);
		
	}
	
	
	public static function getURL (request:URLRequest, target:String = null) {
		
		if (target == null) {
			
			target = "_blank";
			
		}
		
		#if js
		Browser.window.open (request.url, target);
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
	
	
	public static function trace (arg:Dynamic):Void {
		
		haxe.Log.trace (arg);
		
	}
	
	
}