package openfl.media;


import haxe.io.Path;
import lime.app.Future;
import lime.app.Preloader;
import lime.media.AudioBuffer;
import lime.media.AudioSource;
import lime.utils.UInt8Array;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

@:access(lime.utils.AssetLibrary)
@:access(openfl.media.SoundMixer)

@:autoBuild(openfl._internal.macros.AssetsMacro.embedSound())


class Sound extends EventDispatcher {
	
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var id3 (get, never):ID3Info;
	public var isBuffering (default, null):Bool;
	public var length (get, never):Float;
	public var url (default, null):String;
	
	private var __buffer:AudioBuffer;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Sound.prototype, {
			"id3": { get: untyped __js__ ("function () { return this.get_id3 (); }") },
			"length": { get: untyped __js__ ("function () { return this.get_length (); }") },
		});
		
	}
	#end
	
	
	public function new (stream:URLRequest = null, context:SoundLoaderContext = null) {
		
		super (this);
		
		bytesLoaded = 0;
		bytesTotal = 0;
		isBuffering = false;
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
	
	
	public static function fromFile (path:String):Sound {
		
		return fromAudioBuffer (AudioBuffer.fromFile (path));
		
	}
	
	
	public function load (stream:URLRequest, context:SoundLoaderContext = null):Void {
		
		url = stream.url;
		
		#if (js && html5)
		
		var defaultLibrary = lime.utils.Assets.getLibrary ("default"); // TODO: Improve this
		
		if (defaultLibrary != null && defaultLibrary.cachedAudioBuffers.exists (url)) {
			
			AudioBuffer_onURLLoad (defaultLibrary.cachedAudioBuffers.get (url));
			
		} else {
			
			AudioBuffer.loadFromFile (url).onComplete (AudioBuffer_onURLLoad).onError (function (_) AudioBuffer_onURLLoad (null));
			
		}
		
		#else
		
		AudioBuffer.loadFromFile (url).onComplete (AudioBuffer_onURLLoad).onError (function (_) AudioBuffer_onURLLoad (null));
		
		#end
		
	}
	
	
	public function loadCompressedDataFromByteArray (bytes:ByteArray, bytesLength:Int):Void {
		
		if (bytes == null || bytesLength <= 0) {
			
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			return;
			
		}
		
		if (bytes.length > bytesLength) {
			
			var copy = new ByteArray (bytesLength);
			copy.writeBytes (bytes, 0, bytesLength);
			bytes = copy;
			
		}
		
		__buffer = AudioBuffer.fromBytes (bytes);
		
		if (__buffer == null) {
			
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			
		} else {
			
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	
	public static function loadFromFile (path:String):Future<Sound> {
		
		return AudioBuffer.loadFromFile (path).then (function (audioBuffer) {
			
			return Future.withValue (fromAudioBuffer (audioBuffer));
			
		});
		
	}
	
	
	public static function loadFromFiles (paths:Array<String>):Future<Sound> {
		
		return AudioBuffer.loadFromFiles (paths).then (function (audioBuffer) {
			
			return Future.withValue (fromAudioBuffer (audioBuffer));
			
		});
		
	}
	
	
	public function loadPCMFromByteArray (bytes:ByteArray, samples:Int, format:String = "float", stereo:Bool = true, sampleRate:Float = 44100):Void {
		
		if (bytes == null) {
			
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			return;
			
		}
		
		var audioBuffer = new AudioBuffer ();
		audioBuffer.bitsPerSample = format == "float" ? 32 : 16; // "short"
		audioBuffer.channels = stereo ? 2 : 1;
		audioBuffer.data = new UInt8Array (bytes);
		audioBuffer.sampleRate = Std.int (sampleRate);
		
		__buffer = audioBuffer;
		
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	public function play (startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel {
		
		if (SoundMixer.__soundChannels.length >= SoundMixer.MAX_ACTIVE_CHANNELS) {
			
			return null;
			
		}
		
		if (sndTransform == null) {
			
			sndTransform = new SoundTransform ();
			
		} else {
			
			sndTransform = sndTransform.clone ();
			
		}
		
		var pan = SoundMixer.__soundTransform.pan + sndTransform.pan;
		
		if (pan > 1) pan = 1;
		if (pan < -1) pan = -1;
		
		var volume = SoundMixer.__soundTransform.volume * sndTransform.volume;
		
		var source = new AudioSource (__buffer);
		source.offset = Std.int (startTime);
		if (loops > 1) source.loops = loops - 1;
		
		source.gain = volume;
		
		var position = source.position;
		position.x = pan;
		position.z = -1 * Math.sqrt (1 - Math.pow (pan, 2));
		source.position = position;
		
		return new SoundChannel (source, sndTransform);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_id3 ():ID3Info {
		
		return new ID3Info ();
		
	}
	
	
	private function get_length ():Int {
		
		if (__buffer != null) {
			
			#if (js && html5 && howlerjs)
			
			return Std.int(__buffer.src.duration() * 1000);
			
			#else
			
			var samples = (__buffer.data.length * 8) / (__buffer.channels * __buffer.bitsPerSample);
			return Std.int (samples / __buffer.sampleRate * 1000);
			
			#end
			
		}
		
		return 0;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function AudioBuffer_onURLLoad (buffer:AudioBuffer):Void {
		
		if (buffer == null) {
			
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			
		} else {
			
			__buffer = buffer;
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	
}