package flash.system;

#if flash
@:final extern class Capabilities
{
	#if (haxe_ver < 4.3)
	public static var avHardwareDisable(default, never):Bool;
	public static var cpuAddressSize(default, never):Float;
	@:require(flash10_1) public static var cpuArchitecture(default, never):String;
	public static var hasAccessibility(default, never):Bool;
	public static var hasAudio(default, never):Bool;
	public static var hasAudioEncoder(default, never):Bool;
	public static var hasEmbeddedVideo(default, never):Bool;
	public static var hasIME(default, never):Bool;
	public static var hasMP3(default, never):Bool;
	public static var hasPrinting(default, never):Bool;
	public static var hasScreenBroadcast(default, never):Bool;
	public static var hasScreenPlayback(default, never):Bool;
	public static var hasStreamingAudio(default, never):Bool;
	public static var hasStreamingVideo(default, never):Bool;
	public static var hasTLS(default, never):Bool;
	public static var hasVideoEncoder(default, never):Bool;
	public static var isDebugger(default, never):Bool;
	@:require(flash10) public static var isEmbeddedInAcrobat(default, never):Bool;
	public static var language(default, never):String;
	public static var localFileReadDisable(default, never):Bool;
	public static var manufacturer(default, never):String;
	@:require(flash10) public static var maxLevelIDC(default, never):Int;
	public static var os(default, never):String;
	public static var pixelAspectRatio(default, never):Float;
	public static var playerType(default, never):String;
	public static var screenColor(default, never):String;
	public static var screenDPI(default, never):Float;
	public static var screenResolutionX(default, never):Float;
	public static var screenResolutionY(default, never):Float;
	public static var serverString(default, never):String;
	@:require(flash10_1) public static var supports32BitProcesses(default, never):Bool;
	@:require(flash10_1) public static var supports64BitProcesses(default, never):Bool;
	@:require(flash10_1) public static var touchscreenType(default, never):TouchscreenType;
	public static var version(default, never):String;
	#if air
	public static var languages(default, never):Array<String>;
	#end
	#else
	@:flash.property static var avHardwareDisable(get, never):Bool;
	@:flash.property static var cpuAddressSize(get, never):Float;
	@:flash.property @:require(flash10_1) static var cpuArchitecture(get, never):String;
	@:flash.property static var hasAccessibility(get, never):Bool;
	@:flash.property static var hasAudio(get, never):Bool;
	@:flash.property static var hasAudioEncoder(get, never):Bool;
	@:flash.property static var hasEmbeddedVideo(get, never):Bool;
	@:flash.property static var hasIME(get, never):Bool;
	@:flash.property static var hasMP3(get, never):Bool;
	@:flash.property static var hasPrinting(get, never):Bool;
	@:flash.property static var hasScreenBroadcast(get, never):Bool;
	@:flash.property static var hasScreenPlayback(get, never):Bool;
	@:flash.property static var hasStreamingAudio(get, never):Bool;
	@:flash.property static var hasStreamingVideo(get, never):Bool;
	@:flash.property static var hasTLS(get, never):Bool;
	@:flash.property static var hasVideoEncoder(get, never):Bool;
	@:flash.property static var isDebugger(get, never):Bool;
	@:flash.property @:require(flash10) static var isEmbeddedInAcrobat(get, never):Bool;
	@:flash.property static var language(get, never):String;
	@:flash.property static var localFileReadDisable(get, never):Bool;
	@:flash.property static var manufacturer(get, never):String;
	@:flash.property @:require(flash10) static var maxLevelIDC(get, never):String;
	@:flash.property static var os(get, never):String;
	@:flash.property static var pixelAspectRatio(get, never):Float;
	@:flash.property static var playerType(get, never):String;
	@:flash.property static var screenColor(get, never):String;
	@:flash.property static var screenDPI(get, never):Float;
	@:flash.property static var screenResolutionX(get, never):Float;
	@:flash.property static var screenResolutionY(get, never):Float;
	@:flash.property static var serverString(get, never):String;
	@:flash.property @:require(flash10_1) static var supports32BitProcesses(get, never):Bool;
	@:flash.property @:require(flash10_1) static var supports64BitProcesses(get, never):Bool;
	@:flash.property @:require(flash10_1) static var touchscreenType(get, never):TouchscreenType;
	@:flash.property static var version(get, never):String;
	#if air
	@:flash.property static var languages(get, never):Array<String>;
	#end
	#end
	@:require(flash11) public static function hasMultiChannelAudio(type:String):Bool;

	#if (haxe_ver >= 4.3)
	private static function get_avHardwareDisable():Bool;
	private static function get_cpuAddressSize():Float;
	private static function get_cpuArchitecture():String;
	private static function get_hasAccessibility():Bool;
	private static function get_hasAudio():Bool;
	private static function get_hasAudioEncoder():Bool;
	private static function get_hasEmbeddedVideo():Bool;
	private static function get_hasIME():Bool;
	private static function get_hasMP3():Bool;
	private static function get_hasPrinting():Bool;
	private static function get_hasScreenBroadcast():Bool;
	private static function get_hasScreenPlayback():Bool;
	private static function get_hasStreamingAudio():Bool;
	private static function get_hasStreamingVideo():Bool;
	private static function get_hasTLS():Bool;
	private static function get_hasVideoEncoder():Bool;
	private static function get_isDebugger():Bool;
	private static function get_isEmbeddedInAcrobat():Bool;
	private static function get_language():String;
	private static function get_localFileReadDisable():Bool;
	private static function get_manufacturer():String;
	private static function get_maxLevelIDC():String;
	private static function get_os():String;
	private static function get_pixelAspectRatio():Float;
	private static function get_playerType():String;
	private static function get_screenColor():String;
	private static function get_screenDPI():Float;
	private static function get_screenResolutionX():Float;
	private static function get_screenResolutionY():Float;
	private static function get_serverString():String;
	private static function get_supports32BitProcesses():Bool;
	private static function get_supports64BitProcesses():Bool;
	private static function get_touchscreenType():TouchscreenType;
	private static function get_version():String;
	#if air
	private static function get_languages():Array<String>;
	#end
	#end
}
#else
typedef Capabilities = openfl.system.Capabilities;
#end
