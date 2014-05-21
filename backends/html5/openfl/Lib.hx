package openfl;


import haxe.Timer;
import js.html.HtmlElement;
import js.Browser;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.net.URLRequest;


@:access(openfl.display.Stage) class Lib {
	
	
	public static var current (default, null):MovieClip;
	
	private static var __sentWarnings = new Map<String, Bool> ();
	private static var __startTime:Float = Timer.stamp ();
	
	
	public static function as<T> (v:Dynamic, c:Class<T>):Null<T> {
		
		return Std.is (v, c) ? v : null;
		
	}
	
	
	public static function attach (name:String):MovieClip {
		
		return new MovieClip ();
		
	}
	
	
	public static function create (element:HtmlElement, width:Null<Int> = null, height:Null<Int> = null, backgroundColor:Null<Int>):Void {
		
		if (width == null) {
			
			width = 0;
			
		}
		
		if (height == null) {
			
			height = 0;
			
		}
		
		untyped __js__ ("
			var lastTime = 0;
			var vendors = ['ms', 'moz', 'webkit', 'o'];
			for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
				window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
				window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame'] 
										   || window[vendors[x]+'CancelRequestAnimationFrame'];
			}
			
			if (!window.requestAnimationFrame)
				window.requestAnimationFrame = function(callback, element) {
					var currTime = new Date().getTime();
					var timeToCall = Math.max(0, 16 - (currTime - lastTime));
					var id = window.setTimeout(function() { callback(currTime + timeToCall); }, 
					  timeToCall);
					lastTime = currTime + timeToCall;
					return id;
				};
			
			if (!window.cancelAnimationFrame)
				window.cancelAnimationFrame = function(id) {
					clearTimeout(id);
				};
			
			window.requestAnimFrame = window.requestAnimationFrame;
		");
		
		var stage = new Stage (width, height, element, backgroundColor);
		
		if (current == null) {
			
			current = new MovieClip ();
			stage.addChild (current);
			
		}
		
	}
	
	
	public static function getTimer ():Int {
		
		return Std.int ((Timer.stamp () - __startTime) * 1000);
		
	}
	
	
	public static function getURL (request:URLRequest, target:String = null) {
		
		if (target == null) {
			
			target = "_blank";
			
		}
		
		Browser.window.open (request.url, target);
		
	}
	
	
	public static function notImplemented (api:String):Void {
		
		if (!__sentWarnings.exists (api)) {
			
			__sentWarnings.set (api, true);
			
			trace ("Warning: " + api + " has not implemented");
			
		}
		
	}
	
	
	public static function preventDefaultTouchMove ():Void {
		
		Browser.document.addEventListener ("touchmove", function (evt:js.html.Event):Void {
			
			evt.preventDefault ();
			
		}, false);
		
	}
	
	
	public static function trace (arg:Dynamic):Void {
		
		haxe.Log.trace (arg);
		
	}
	
	
}