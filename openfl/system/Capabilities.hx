package openfl.system;


import haxe.macro.Compiler;
import lime.system.Locale;


@:final class Capabilities {
	
	
	public static var avHardwareDisable (default, null) = true;
	public static var cpuArchitecture (get, never):String;
	public static var hasAccessibility (default, null) = false;
	public static var hasAudio (default, null) = true;
	public static var hasAudioEncoder (default, null) = false;
	public static var hasEmbeddedVideo (default, null) = false;
	public static var hasIME (default, null) = false;
	public static var hasMP3 (default, null) = false;
	public static var hasPrinting (default, null) = #if html5 true #else false #end;
	public static var hasScreenBroadcast (default, null) = false;
	public static var hasScreenPlayback (default, null) = false;
	public static var hasStreamingAudio (default, null) = false;
	public static var hasStreamingVideo (default, null) = false;
	public static var hasTLS (default, null) = true;
	public static var hasVideoEncoder (default, null) = #if html5 true #else false #end;
	public static var isDebugger (default, null) = #if debug true #else false #end;
	public static var isEmbeddedInAcrobat (default, null) = false;
	public static var language (get, never):String;
	public static var localFileReadDisable (default, null) = #if web true #else false #end;
	public static var manufacturer (get, never):String;
	public static var maxLevelIDC (default, null) = 0;
	public static var os (get, never):String;
	public static var pixelAspectRatio (get, never):Float;
	public static var playerType (default, null) = #if web "PlugIn" #else "StandAlone" #end;
	public static var screenColor (default, null) = "color";
	public static var screenDPI (get, never):Float;
	public static var screenResolutionX (get, never):Float;
	public static var screenResolutionY (get, never):Float;
	public static var serverString (default, null) = ""; // TODO
	public static var supports32BitProcesses (default, null) = #if sys true #else false #end;
	public static var supports64BitProcesses (default, null) = #if desktop true #else false #end; // TODO
	public static var touchscreenType (default, null) = TouchscreenType.FINGER; // TODO
	public static var version (get, never):String;
	
	private static var __standardDensities = [ 120, 160, 240, 320, 480, 640, 800, 960 ];
	
	
	public static function hasMultiChannelAudio (type:String):Bool {
		
		return false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static inline function get_cpuArchitecture ():String {
		
		#if mobile
		return "ARM";
		#else
		return "x86";
		#end
		
	}
	
	
	private static function get_language ():String {
		
		var language = Locale.currentLocale.language;
		
		if (language != null) {
			
			language = language.toLowerCase ();
			
			switch (language) {
				
				case "cs", "da", "nl", "en", "fi", "fr", "de", "hu", "it", "ja", "ko", "nb", "pl", "pt", "ru", "es", "sv", "tr":
					
					return language;
				
				case "zh":
					
					var region = Locale.currentLocale.region;
					
					if (region != null) {
						
						switch (region.toUpperCase ()) {
							
							case "TW", "HANT":
								
								return "zh-TW";
							
							default:
							
						}
						
					}
					
					return "zh-CN";
				
				default:
					
					return "xu";
				
			}
			
		}
		
		return "en";
	
	}
	
	
	private static inline function get_manufacturer ():String {
		
		#if firefox
		return "OpenFL Firefox";
		#elseif (js && html5)
		return "OpenFL HTML5";
		#elseif android
		return "OpenFL Android";
		#elseif blackberry
		return "OpenFL BlackBerry";
		#elseif ios
		return "OpenFL iOS";
		#elseif tvos
		return "OpenFL tvOS";
		#elseif tizen
		return "OpenFL Tizen";
		#elseif webos
		return "OpenFL webOS";
		#elseif sys
		return "OpenFL " + Sys.systemName ();
		#else
		return "OpenFL";
		#end
		
	}
	
	
	private static inline function get_os ():String {
		
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
		#elseif tvos
		return "tvOS";
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
	
	
	private static function get_pixelAspectRatio ():Float {
		
		return 1;
		
	}
	
	
	private static function get_screenDPI ():Float {
		
		var window = Lib.application != null ? Lib.application.window : null;
		var screenDPI:Float;
		
		#if (desktop || web)
		
		screenDPI = 72;
		
		if (window != null) {
			
			screenDPI *= window.scale;
			
		}
		
		#else
		
		screenDPI = __standardDensities[0];
		
		if (window != null) {
			
			var display = window.display;
			
			if (display != null) {
				
				var actual = display.dpi;
				
				var closestValue = screenDPI;
				var closestDifference = Math.abs (actual - screenDPI);
				var difference:Float;
				
				for (density in __standardDensities) {
					
					difference = Math.abs (actual - density);
					
					if (difference < closestDifference) {
						
						closestDifference = difference;
						closestValue = density;
						
					}
					
				}
				
				screenDPI = closestValue;
				
			}
			
		}
		
		#end
		
		return screenDPI;
		
	}
	
	
	private static function get_screenResolutionX ():Float { 
		
		var stage = Lib.current.stage;
		var resolutionX = 0;
		
		if (stage.window != null) {
			
			var display = stage.window.display;
			
			if (display != null) {
				
				resolutionX = display.currentMode.width;
				
			}
			
		}
		
		if (resolutionX > 0) {
			
			return resolutionX;
			
		}
		
		return stage.stageWidth;
		
	}
	
	
	private static function get_screenResolutionY ():Float {
		
		var stage = Lib.current.stage;
		var resolutionY = 0;
		
		if (stage.window != null) {
			
			var display = stage.window.display;
			
			if (display != null) {
				
				resolutionY = display.currentMode.height;
				
			}
			
		}
		
		if (resolutionY > 0) {
			
			return resolutionY;
			
		}
		
		return stage.stageHeight;
		
	}
	
	
	private static function get_version () {
		
		#if windows
		var value = "WIN";
		#elseif mac
		var value = "MAC";
		#elseif linux
		var value = "LNX";
		#elseif ios
		var value = "IOS";
		#elseif tvos
		var value = "TVO";
		#elseif android
		var value = "AND";
		#elseif blackberry
		var value = "QNX";
		#elseif firefox
		var value = "MOZ";
		#elseif html5
		var value = "WEB";
		#else
		var value = "OFL";
		#end
		
		if (Compiler.getDefine ("openfl") != null) {
			
			value += " " + StringTools.replace (Compiler.getDefine ("openfl"), ".", ",") + ",0";
			
		}
		
		return value;
		
	}
	
	
}
