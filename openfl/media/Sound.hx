package openfl.media; #if !flash


import haxe.io.Path;
import lime.media.AudioBuffer;
import lime.media.AudioSource;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;


@:autoBuild(openfl.Assets.embedSound())
class Sound extends EventDispatcher {
	
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var id3 (get, null):ID3Info;
	public var isBuffering (default, null):Bool;
	public var length (default, null):Float;
	public var url (default, null):String;
	
	private var __buffer:AudioBuffer;
	
	
	public function new (stream:URLRequest = null, context:SoundLoaderContext = null) {
		
		super (this);
		
		bytesLoaded = 0;
		bytesTotal = 0;
		id3 = null;
		isBuffering = false;
		length = 0;
		url = null;
		
		if (stream != null) {
			
			load (stream, context);
			
		}
		
	}
	
	
	public function close ():Void {
		
		if (__buffer != null) {
			
			__buffer.dispose ();
			
		}
		
	}
	
	
	public static function fromAudioBuffer (buffer:AudioBuffer):Sound {
		
		var sound = new Sound ();
		sound.__buffer = buffer;
		return sound;
		
	}
	
	
	public function load (stream:URLRequest, context:SoundLoaderContext = null):Void {
		
		AudioBuffer.fromURL (stream.url, AudioBuffer_onURLLoad);
		
	}
	
	
	public function loadCompressedDataFromByteArray (bytes:ByteArray, bytesLength:Int, forcePlayAsMusic = false):Void {
		
		// TODO: handle byte length
		
		__buffer = AudioBuffer.fromBytes (bytes);
		
	}
	
	
	public function loadPCMFromByteArray (bytes:ByteArray, samples:Int, format:String = null, stereo:Bool = true, sampleRate:Float = 44100):Void {
		
		// TODO: handle pre-decoded data
		
		__buffer = AudioBuffer.fromBytes (bytes);
		
	}
	
	
	public function play (startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel {
		
		if (sndTransform == null) {
			
			sndTransform = new SoundTransform (1, 0);
			
		}
		
		// TODO: handle start time, loops, sound transform
		
		var source = new AudioSource (__buffer);
		return new SoundChannel (source);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_id3 ():ID3Info {
		
		return new ID3Info ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function AudioBuffer_onURLLoad (buffer:AudioBuffer):Void {
		
		__buffer = buffer;
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
}


#else
typedef Sound = flash.media.Sound;
#end