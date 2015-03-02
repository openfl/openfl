package openfl._v2.system; #if lime_legacy


import haxe.macro.Compiler;
import openfl.system.TouchscreenType;
import openfl.Lib;


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
	public static var touchscreenType (default, null) = TouchscreenType.FINGER; // TODO
	public static var version (get, null):String; // TODO
	
	public static var screenModes (get, null):Array<ScreenMode>;
	public static var screenResolutions (get, null):Array<Array<Int>>;
	
	
	public static function hasMultiChannelAudio (type:String):Bool {
		
		return false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
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
	
	
	private static function get_language ():String {
		
		var locale:String = lime_capabilities_get_language ();
		
		if (locale == null || locale == "" || locale == "C" || locale == "POSIX") {
			
			return "en-US";
			
		} else {
			
			var formattedLocale = "";
			var length = locale.length;
			
			if (length > 5) {
				
				length = 5;
				
			}
			
			for (i in 0...length) {
				
				var char = locale.charAt (i);
				
				if (i < 2) {
					
					formattedLocale += char.toLowerCase ();
					
				} else if (i == 2) {
					
					formattedLocale += "-";
					
				} else {
					
					formattedLocale += char.toUpperCase ();
					
				}
				
			}
			
			return formattedLocale;
			
		}
		
	}
	
	
	private static function get_pixelAspectRatio ():Float { return lime_capabilities_get_pixel_aspect_ratio (); }
	private static function get_screenDPI ():Float { return lime_capabilities_get_screen_dpi (); }
	
	
	private static function get_screenResolutions ():Array<Array<Int>> {
		
		var res:Array<Int> = lime_capabilities_get_screen_resolutions ();
		
		if (res == null) {
			
			return new Array<Array<Int>> ();
			
		}
		
		var out = new Array<Array<Int>>();

		for (c in 0...Std.int (res.length / 2)) {
			
			out.push ([ res[ c * 2 ], res[ c * 2 + 1 ] ]);
			
		}
		
		return out;
		
	}
	
	
	private static function get_screenResolutionX ():Float { return lime_capabilities_get_screen_resolution_x (); }
	private static function get_screenResolutionY ():Float { return lime_capabilities_get_screen_resolution_y (); }
	
	private static function get_screenModes ():Array<ScreenMode> {
		var modes:Array<Int> = lime_capabilities_get_screen_modes ();
		var out = new Array<ScreenMode> ();

		if (modes == null) {
			return out;
		}

		for (c in 0...Std.int (modes.length / 4)) {
			var mode = new ScreenMode();
			mode.width = modes[ c * 4 + 0 ];
			mode.height = modes[ c * 4 + 1 ];
			mode.refreshRate = modes[ c * 4 + 2 ];
			mode.format = Type.createEnumIndex( PixelFormat, modes[ c * 4 + 3 ] );
			out.push (mode);
		}

		return out;
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
		#elseif android
		var value = "AND";
		#elseif blackberry
		var value = "QNX";
		#else
		var value = "OFL";
		#end
		
		if (Compiler.getDefine ("openfl") != null) {
			
			value += " " + StringTools.replace (Compiler.getDefine ("openfl"), ".", ",") + ",0";
			
		}
		
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_capabilities_get_pixel_aspect_ratio = Lib.load ("lime", "lime_capabilities_get_pixel_aspect_ratio", 0);
	private static var lime_capabilities_get_screen_dpi = Lib.load ("lime", "lime_capabilities_get_screen_dpi", 0);
	private static var lime_capabilities_get_screen_resolution_x = Lib.load ("lime", "lime_capabilities_get_screen_resolution_x", 0);
	private static var lime_capabilities_get_screen_resolution_y = Lib.load ("lime", "lime_capabilities_get_screen_resolution_y", 0);
	private static var lime_capabilities_get_screen_resolutions = Lib.load ("lime", "lime_capabilities_get_screen_resolutions", 0 );
	private static var lime_capabilities_get_screen_modes = Lib.load ("lime", "lime_capabilities_get_screen_modes", 0 );
	private static var lime_capabilities_get_language = Lib.load ("lime", "lime_capabilities_get_language", 0);
	
	
}


#end