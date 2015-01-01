package openfl.system; #if !flash #if (display || openfl_next || js)


import openfl.Lib;

#if js
import js.html.Element;
import js.Browser;
#end


class Capabilities {
	
	
	public static var avHardwareDisable (default, null) = true;
	public static var cpuArchitecture (default, null) = ""; // TODO
	public static var hasAccessibility (default, null) = false;
	public static var hasAudio (default, null) = true;
	public static var hasAudioEncoder (default, null) = false;
	public static var hasEmbeddedVideo (default, null) = false;
	public static var hasIME (default, null) = false;
	public static var hasMP3 (default, null) = false;
	public static var hasPrinting (default, null) = false;
	public static var hasScreenBroadcast (default, null) = false;
	public static var hasScreenPlayback (default, null) = false;
	public static var hasStreamingAudio (default, null) = false;
	public static var hasStreamingVideo (default, null) = false;
	public static var hasTLS (default, null) = true;
	public static var hasVideoEncoder (default, null) = false;
	public static var isDebugger (default, null) = #if debug true #else false #end;
	public static var isEmbeddedInAcrobat (default, null) = false;
	public static var language (get, null):String;
	public static var localFileReadDisable (default, null) = #if html5 true #else false #end;
	public static var manufacturer (default, null) = "OpenFL Contributors";
	public static var maxLevelIDC (default, null) = 0;
	public static var os (get, null):String;
	public static var pixelAspectRatio (get, null):Float;
	public static var playerType (default, null) = "OpenFL";
	public static var screenColor (default, null) = "color";
	public static var screenDPI (get, null):Float;
	public static var screenResolutionX (get, null):Float;
	public static var screenResolutionY (get, null):Float;
	public static var serverString (default, null) = ""; // TODO
	public static var supports32BitProcesses (default, null) = #if sys true #else false #end;
	public static var supports64BitProcesses (default, null) = #if desktop true #else false #end; // TODO
	public static var touchscreenType (default, null) = "finger"; // TODO
	public static var version (default, null) = ""; // TODO
	
	
	public static function hasMultiChannelAudio (type:String):Bool {
		
		return false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private static inline function get_os ():String {
		
		// TODO: OS version, too?
		
		#if firefox
		return "Firefox";
		#elseif (js && html5)
		return "HTML5";
		#elseif android
		return "Android";
		#elseif blackberry
		return "BlackBerry";
		#elseif ios
		return "iOS";
		#elseif tizen
		return "Tizen";
		#elseif webos
		return "webOS";
		#elseif sys
		return Sys.systemName ();
		#else
		return "";
		#end
		
	}
	
	
	@:noCompletion private static function get_pixelAspectRatio ():Float { return 1; }
	@:noCompletion private static function get_screenDPI ():Float {
		
		#if js
		
		if (screenDPI > 0) return screenDPI;
		
		//little trick of measuring the width of a 1 inch div
		//but sadly most browsers/OSs still return wrong result...
		var body = Browser.document.getElementsByTagName ("body")[0];
		var testDiv:Element = cast Browser.document.createElement ("div");
		testDiv.style.width = testDiv.style.height = "1in";
		testDiv.style.padding = testDiv.style.margin = "0px";
		testDiv.style.position = "absolute";
		testDiv.style.top = "-100%";
		body.appendChild (testDiv);
		screenDPI = testDiv.offsetWidth;
		body.removeChild (testDiv);
		
		return screenDPI;
		
		#else
		
		return 0;
		
		#end
		
	}
	
	
	@:noCompletion private static function get_screenResolutionX ():Float { 
		
		#if js
		
		return Browser.window.screen.width;
		
		#else
		
		return 0;
		
		#end
		
	}
	
	
	@:noCompletion private static function get_screenResolutionY ():Float {
		
		#if js
		
		return Browser.window.screen.height;
		
		#else
		
		return 0;
		
		#end
		
	}
	
	
	@:noCompletion private static function get_language ():String {
		
		#if js
		
		return untyped navigator.language;
		
		#else
		
		return "en-US";
		
		#end
	
	}
	
	
}


#else
typedef Capabilities = openfl._v2.system.Capabilities;
#end
#else
typedef Capabilities = flash.system.Capabilities;
#end