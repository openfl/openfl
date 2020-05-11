package openfl.system;

import haxe.macro.Compiler;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Capabilities
{
	public static var avHardwareDisable = true;
	public static var cpuArchitecture(get, never):String;
	public static var hasAccessibility = false;
	public static var hasAudio = true;
	public static var hasAudioEncoder = false;
	public static var hasEmbeddedVideo = false;
	public static var hasIME = false;
	public static var hasMP3 = false;
	public static var hasPrinting = #if html5 true #else false #end;
	public static var hasScreenBroadcast = false;
	public static var hasScreenPlayback = false;
	public static var hasStreamingAudio = false;
	public static var hasStreamingVideo = false;
	public static var hasTLS = true;
	public static var hasVideoEncoder = #if html5 true #else false #end;
	public static var isDebugger = #if debug true #else false #end;
	public static var isEmbeddedInAcrobat = false;
	public static var language(get, never):String;
	public static var localFileReadDisable = #if web true #else false #end;
	public static var manufacturer(get, never):String;
	public static var maxLevelIDC = 0;
	public static var os(get, never):String;
	public static var pixelAspectRatio(get, never):Float;
	public static var playerType = #if web "PlugIn" #else "StandAlone" #end;
	public static var screenColor = "color";
	public static var screenDPI(get, never):Float;
	public static var screenResolutionX(get, never):Float;
	public static var screenResolutionY(get, never):Float;
	public static var serverString = ""; // TODO
	public static var supports32BitProcesses = #if sys true #else false #end;
	public static var supports64BitProcesses = #if desktop true #else false #end; // TODO
	public static var touchscreenType = TouchscreenType.FINGER; // TODO
	public static var version(get, never):String;

	public static function hasMultiChannelAudio(type:String):Bool
	{
		return false;
	}

	// Get & Set Methods

	public static inline function get_cpuArchitecture():String
	{
		// TODO: Check architecture
		#if (mobile && !simulator && !emulator)
		return "ARM";
		#else
		return "x86";
		#end
	}

	public static function get_language():String
	{
		return CapabilitiesBackend.getLanguage();
	}

	public static inline function get_manufacturer():String
	{
		return CapabilitiesBackend.getManufacturer();
	}

	public static inline function get_os():String
	{
		return CapabilitiesBackend.getOS();
	}

	public static function get_pixelAspectRatio():Float
	{
		return 1;
	}

	public static function get_screenDPI():Float
	{
		return CapabilitiesBackend.getScreenDPI();
	}

	public static function get_screenResolutionX():Float
	{
		return CapabilitiesBackend.getScreenResolutionX();
	}

	public static function get_screenResolutionY():Float
	{
		return CapabilitiesBackend.getScreenResolutionY();
	}

	public static function get_version():String
	{
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

		if (Compiler.getDefine("openfl") != null)
		{
			value += " " + StringTools.replace(Compiler.getDefine("openfl"), ".", ",") + ",0";
		}

		return value;
	}
}
