package flash.media; #if (!display && flash)


import lime.audio.AudioBuffer;
import openfl.events.EventDispatcher;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;


extern class Sound extends EventDispatcher {
	
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var id3 (default, null):ID3Info;
	public var isBuffering (default, null):Bool;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var isURLInaccessible (default, null):Bool;
	#end
	
	public var length (default, null):Float;
	public var url (default, null):String;
	
	public function new (stream:URLRequest = null, context:SoundLoaderContext = null);
	public function close ():Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public function extract (target:ByteArray, length:Float, startPosition:Float = -1):Float;
	#end
	
	public static function fromAudioBuffer (buffer:AudioBuffer):Sound;
	public static function fromFile (path:String):Sound;
	public function load (stream:URLRequest, context:SoundLoaderContext = null):Void;
	@:require(flash11) public function loadCompressedDataFromByteArray (bytes:ByteArray, bytesLength:Int, forcePlayAsMusic:Bool = false):Void;
	@:require(flash11) public function loadPCMFromByteArray (bytes:ByteArray, samples:Int, format:String = null, stereo:Bool = true, sampleRate:Float = 44100):Void;
	public function play (startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel;
	
	
}


#else
typedef Sound = openfl.media.Sound;
#end