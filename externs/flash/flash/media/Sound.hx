package flash.media;

#if flash
import lime.app.Future;
import lime.app.Promise;
import lime.media.AudioBuffer;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

@:access(lime.media.AudioBuffer)
extern class Sound extends EventDispatcher
{
	public var bytesLoaded(default, never):Int;
	public var bytesTotal(default, never):Int;
	public var id3(default, never):ID3Info;
	public var isBuffering(default, never):Bool;
	#if flash
	@:require(flash10_1) public var isURLInaccessible(default, never):Bool;
	#end
	public var length(default, never):Float;
	public var url(default, never):String;
	public function new(stream:URLRequest = null, context:SoundLoaderContext = null);
	public function close():Void;
	#if flash
	@:require(flash10) public function extract(target:ByteArray, length:Float, startPosition:Float = -1):Float;
	#end
	public static inline function fromAudioBuffer(buffer:AudioBuffer):Sound
	{
		return buffer.__srcSound;
	}
	public static inline function fromFile(path:String):Sound
	{
		return null;
	}
	public function load(stream:URLRequest, context:SoundLoaderContext = null):Void;
	@:require(flash11) public function loadCompressedDataFromByteArray(bytes:ByteArray, bytesLength:Int, forcePlayAsMusic:Bool = false):Void;
	public static inline function loadFromFile(path:String):Future<Sound>
	{
		var promise = new Promise<Sound>();

		var sound = new Sound();
		sound.addEventListener(Event.COMPLETE, function(e)
		{
			promise.complete(sound);
		});
		sound.addEventListener(IOErrorEvent.IO_ERROR, function(e)
		{
			promise.error(e.text);
		});
		sound.addEventListener(ProgressEvent.PROGRESS, function(e)
		{
			promise.progress(Std.int(e.bytesLoaded), Std.int(e.bytesTotal));
		});
		sound.load(new URLRequest(path));

		return promise.future;
	}
	@:require(flash11) public function loadPCMFromByteArray(bytes:ByteArray, samples:Int, format:String = null, stereo:Bool = true,
		sampleRate:Float = 44100):Void;
	public function play(startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel;
}
#else
typedef Sound = openfl.media.Sound;
#end
