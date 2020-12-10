package flash.system;

#if flash
@:final extern class Capabilities
{
	public static var avHardwareDisable(default, never):Bool;
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
	#if air
	public static var languages(default, never):Array<Dynamic>;
	#end
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
	@:require(flash11) public static function hasMultiChannelAudio(type:String):Bool;
}
#else
typedef Capabilities = openfl.system.Capabilities;
#end
