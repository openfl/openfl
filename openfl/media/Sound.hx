package openfl.media; #if (!openfl_legacy || disable_legacy_audio)


import haxe.io.Path;
import lime.audio.AudioBuffer;
import lime.audio.AudioSource;
import lime.Assets;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

@:autoBuild(openfl.Assets.embedSound())


class Sound extends EventDispatcher {


	#if html5
	private static var __registeredSounds = new Map<String, Bool> ();
	private var numberOfLoopsRemaining:Int;
	#end

	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var id3 (get, null):ID3Info;
	public var isBuffering (default, null):Bool;
	public var length (get, never):Float;
	public var url (default, null):String;

	private var __buffer:AudioBuffer;

	#if html5
	private var __sound:Howl;
	private var haveSprite:Bool = false;
	#end


	public function new (stream:URLRequest = null, context:SoundLoaderContext = null) {

		super (this);

		bytesLoaded = 0;
		bytesTotal = 0;
		id3 = null;
		isBuffering = false;
		url = null;

		if (stream != null) {

			load (stream, context);

		}

	}


	public function close ():Void {

		#if !html5

		if (__buffer != null) {

			__buffer.dispose ();

		}

		#end

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

		#if !html5

		AudioBuffer.fromURL (stream.url, AudioBuffer_onURLLoad);

		#else
		
		var spiritOptions = lime.Assets.getExtraSoundOptions(stream.url);
		var data:Dynamic = {src:stream.url, onload:howler_onFileLoad,onloaderror:howler_onFileError};
		if(spiritOptions != null)
		{
			haveSprite = true;
			data = {
				src:stream.url, 
				sprite:{clip : [spiritOptions.start, spiritOptions.duration]},
				onload:howler_onFileLoad,
				onloaderror:howler_onFileError
			};
		}
		__sound = new Howl(data);
		#end

	}


	public function loadCompressedDataFromByteArray (bytes:ByteArray, bytesLength:Int, forcePlayAsMusic:Bool = false):Void {

		// TODO: handle byte length

		#if !html5

		__buffer = AudioBuffer.fromBytes (bytes);

		#else

		openfl.Lib.notImplemented ("Sound.loadCompressedDataFromByteArray");

		#end

	}


	public function loadPCMFromByteArray (bytes:ByteArray, samples:Int, format:String = null, stereo:Bool = true, sampleRate:Float = 44100):Void {

		// TODO: handle pre-decoded data

		#if !html5

		__buffer = AudioBuffer.fromBytes (bytes);

		#else

		openfl.Lib.notImplemented ("Sound.loadPCMFromByteArray");

		#end

	}


	public function play (startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel {

		// TODO: handle pan

		#if !html5

		var source = new AudioSource (__buffer);
		source.offset = Std.int (startTime * 1000);
		if (loops > 1) source.loops = loops - 1;
		if (sndTransform != null) source.gain = sndTransform.volume;
		return SoundChannel.__create (source);

		#else

		if (sndTransform == null) {

			sndTransform = new SoundTransform (1, 0);

		}

		var pan = sndTransform.pan;

		// Hack to fix sound balance

		if (pan != 0) {
			throw ":TODO: use spacial plugin";
		} 
		this.numberOfLoopsRemaining = loops - 1;
		__sound.volume(sndTransform.volume);
		__sound.loop(loops > 1);
		__sound.on("end", onEndSound);
		__sound.seek(Std.int (startTime)); // :TODO: seek don't work as intended, seek must ignore the first part of the sound and do the same every loops
		if(haveSprite) {
			__sound.play('clip');
		}else {
			__sound.play();
		}

		return SoundChannel.__create (__sound);

		#end

	}

	#if html5
	public function onEndSound() {
		if(this.numberOfLoopsRemaining == 0) {
			__sound.stop();
		}else {
			this.numberOfLoopsRemaining -= 1;
		}
	}
	#end


	// Get & Set Methods




	private function get_id3 ():ID3Info {

		return new ID3Info ();

	}


	private function get_length ():Int {

		#if flash || !html5
			if (__buffer != null) {

				#if flash

				return Std.int (__buffer.src.length);

				#elseif !html5

				var samples = (__buffer.data.length * 8) / (__buffer.channels * __buffer.bitsPerSample);
				return Std.int (samples / __buffer.sampleRate * 1000);

				#end

			}
		#end

		return 0;

	}




	// Event Handlers




	private function AudioBuffer_onURLLoad (buffer:AudioBuffer):Void {

		if (buffer == null) {

			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));

		} else {

			__buffer = buffer;
			dispatchEvent (Event.__create (Event.COMPLETE));

		}

	}

	#if html5
	private function howler_onFileLoad ():Void {
		dispatchEvent (Event.__create (Event.COMPLETE));
	}
	private function howler_onFileError ():Void {
		dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
	}
	#end
}



#if html5

@:native("Howl") extern class Howl {
	public function new (o:Dynamic): Void;
	public function play (spriteOrId:Dynamic = null): Int;
	public function stop (id:Int = null): Howl;
	public function volume (vol:Float = null, id:Int = null): Dynamic;
	public function loop (loop:Bool = null, id:Int = null): Dynamic;
	public function seek (rate:Int = null, id:Int = null): Dynamic;
	public function on (event:String, fct:Dynamic, id:Int = null, once:Int = null): Howl;
}
#end

#else
typedef Sound = openfl._legacy.media.Sound;
#end
