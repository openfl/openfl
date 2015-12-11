package flash.system; #if (!display && flash)


@:final extern class Capabilities {
	
	
	public static var avHardwareDisable (default, null):Bool;
	@:require(flash10_1) public static var cpuArchitecture (default, null):String;
	public static var hasAccessibility (default, null):Bool;
	public static var hasAudio (default, null):Bool;
	public static var hasAudioEncoder (default, null):Bool;
	public static var hasEmbeddedVideo (default, null):Bool;
	public static var hasIME (default, null):Bool;
	public static var hasMP3 (default, null):Bool;
	public static var hasPrinting (default, null):Bool;
	public static var hasScreenBroadcast (default, null):Bool;
	public static var hasScreenPlayback (default, null):Bool;
	public static var hasStreamingAudio (default, null):Bool;
	public static var hasStreamingVideo (default, null):Bool;
	public static var hasTLS (default, null):Bool;
	public static var hasVideoEncoder (default, null):Bool;
	public static var isDebugger (default, null):Bool;
	@:require(flash10) public static var isEmbeddedInAcrobat (default, null):Bool;
	public static var language (default, null):String;
	public static var localFileReadDisable (default, null):Bool;
	public static var manufacturer (default, null):String;
	@:require(flash10) public static var maxLevelIDC (default, null):Int;
	public static var os (default, null):String;
	public static var pixelAspectRatio (default, null):Float;
	public static var playerType (default, null):String;
	public static var screenColor (default, null):String;
	public static var screenDPI (default, null):Float;
	public static var screenResolutionX (default, null):Float;
	public static var screenResolutionY (default, null):Float;
	public static var serverString (default, null):String;
	@:require(flash10_1) public static var supports32BitProcesses (default, null):Bool;
	@:require(flash10_1) public static var supports64BitProcesses (default, null):Bool;
	@:require(flash10_1) public static var touchscreenType (default, null):TouchscreenType;
	public static var version (default, null):String;
	@:require(flash11) public static function hasMultiChannelAudio (type:String):Bool;
	
	
}


#else
typedef Capabilities = openfl.system.Capabilities;
#end