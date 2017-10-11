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
import openfl.ObjectPool;

@:autoBuild(openfl.Assets.embedSound())


class Sound extends EventDispatcher {


	#if html5
	private static var __registeredSounds = new Map<String, ObjectPool<Howl>> ();
	private var numberOfLoopsRemaining:Int;
	private var soundName:String;
	private var __sound:Howl;
	private var itHasSoundSprite:Bool = false;
	#end

	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var id3 (get, null):ID3Info;
	public var isBuffering (default, null):Bool;
	public var length (get, never):Float;
	public var url (default, null):String;

	private var __buffer:AudioBuffer;


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
		#else

		if(__sound != null) {
			__sound.unload();
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


	public function load (stream:URLRequest, context:SoundLoaderContext = null, preload:Bool = false):Void {

		#if !html5

		AudioBuffer.fromURL (stream.url, AudioBuffer_onURLLoad);

		#else

		soundName = stream.url;
		if ( !__registeredSounds.exists(soundName) ) {
			__registeredSounds[soundName] = new ObjectPool<Howl>(function() { return null;});
		} else if (!preload) {
			#if dev
				if ( __sound != null ) {
					throw ":TODO:";
				}
			#end
			__sound = __registeredSounds[soundName].get();
		}

		var logicalPath = lime.Assets.getLogicalPath(soundName);
		var spriteOptions = lime.Assets.getExtraSoundOptions(logicalPath);
		var data:Dynamic = null;

		if ( spriteOptions != null && spriteOptions.start != null && spriteOptions.duration != null )
		{
			itHasSoundSprite = true;
		}

		if ( __sound == null ) {

			if ( itHasSoundSprite ) {
				data = {
						src:soundName,
					sprite:{clip : [spriteOptions.start, spriteOptions.duration]},
					onload:howler_onFileLoad,
					onloaderror:howler_onFileError
				};
			} else {
				data = {
						src:soundName,
					onload:howler_onFileLoad,
					onloaderror:howler_onFileError
				};
			}

			__sound = new Howl(data);

			if ( preload ) {
				Reflect.setField(__sound, "__itIsInPool", true);
				onStop();
			} else {
				Reflect.setField(__sound, "__itIsInPool", false);
				trace('Loading sound at runtime! $soundName');
			}

		}
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

		if (pan != 0) {
			throw ":TODO: use spacial plugin";
		}
		this.numberOfLoopsRemaining = loops;
		__sound.volume(sndTransform.volume);
		__sound.loop(true);
		__sound.off("end");
		__sound.off("stop");
		__sound.on("end", onEndSound);
		__sound.on("stop", onStop);
		__sound.seek(Std.int (startTime)); // :TODO: seek don't work as intended, seek must ignore the first part of the sound and do the same every loops
		if(itHasSoundSprite) {
			__sound.play('clip');
		}else {
			__sound.play();
		}

		return SoundChannel.__create (__sound);

		#end

	}

	#if html5
	public function onEndSound() {
		this.numberOfLoopsRemaining--;
		if(this.numberOfLoopsRemaining <= 0) {
			Reflect.setField(__sound, "__itIsInPool", true);
			__sound.stop();
		}
	}

	public function onStop() {
		if ( Reflect.field(__sound, "__itIsInPool") == true ) {
			__registeredSounds[soundName].put(__sound);
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

		#if html5
		if(__sound != null) {
			return __sound.duration();
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
	public function pause (id:Int = null): Howl;
	public function stop (id:Int = null): Howl;
	public function volume (vol:Float = null, id:Int = null): Dynamic;
	public function loop (loop:Bool = null, id:Int = null): Dynamic;
	public function seek (rate:Int = null, id:Int = null): Dynamic;
	public function on (event:String, fct:Dynamic, id:Int = null): Howl;
	public function off (event:String, fct:Dynamic = null, id:Int = null): Howl;
	public function unload (): Void;
	public function duration (id:Int = null): Int;
}
#end

#else
typedef Sound = openfl._legacy.media.Sound;
#end
