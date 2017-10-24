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
@:allow(openfl.media.SoundChannel)

class Sound extends EventDispatcher {


	#if html5
	private static var __registeredSounds = new Map<String, Howl> ();
	private var numberOfLoopsRemaining:Int;
	private var soundName:String;
	private var __sound:Howl;
	private var itHasSoundSprite:Bool = false;
	private var __soundId:Int;
	#else
	private var __sound:AudioSource;
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


	public function load (stream:URLRequest, context:SoundLoaderContext = null, poolAmount:Int=5, preloader:Bool=false):Void {

		#if !html5

		AudioBuffer.fromURL (stream.url, AudioBuffer_onURLLoad);

		#else

		soundName = stream.url;
		if ( __registeredSounds.exists(soundName) ) {
			#if dev
				if ( __sound != null ) {
					throw ":TODO:";
				}
			#end
			__sound = __registeredSounds[soundName];
		} else if ( !preloader ) {
			throw "All sounds should have been registered in preloader!";
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
					onloaderror:howler_onFileError,
					pool:poolAmount
				};
			} else {
				data = {
					src:soundName,
					onload:howler_onFileLoad,
					onloaderror:howler_onFileError,
					pool:poolAmount
				};
			}

			__sound = new Howl(data);

			__registeredSounds[soundName] = __sound;
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
		__sound = source;
		return SoundChannel.__create (this);

		#else

		if (sndTransform == null) {

			sndTransform = new SoundTransform (1, 0);

		}

		var pan = sndTransform.pan;

		if (pan != 0) {
			throw ":TODO: use spatial plugin";
		}
		this.numberOfLoopsRemaining = loops;
		if(itHasSoundSprite) {
			__soundId = __sound.play('clip');
		}else {
			__soundId = __sound.play();
		}

		__sound.volume(sndTransform.volume, __soundId);
		__sound.loop(loops > 1, __soundId);
		__sound.on("end", onEnd, __soundId);
		if ( startTime != 0 ) {
			__sound.seek(Std.int (startTime), __soundId); // :TODO: seek don't work as intended, seek must ignore the first part of the sound and do the same every loops
		}


		return SoundChannel.__create (this);

		#end

	}

	#if html5
	public function prePlayHTML5(startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel {
		if ( @:privateAccess !__sound._webAudio ) {
			return this.play(startTime, loops, sndTransform);
		}
		return null;
	}
	#end

	public function stop() {
		#if html5
		__sound.stop(__soundId);
		#else
		__sound.stop();
		#end
	}

	public function dispose() {
		#if !html5
		__sound.dispose ();
		#else
		__sound.off("end", null, __soundId);
		__sound.off("stop", null, __soundId);
		#end
	}

	#if html5
	public function onEnd() {
		this.numberOfLoopsRemaining--;
		if(this.numberOfLoopsRemaining <= 0) {
			__sound.stop(__soundId);
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
			return __sound.duration(__soundId);
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
	public function once (event:String, fct:Dynamic, id:Int = null): Howl;
	public function off (event:String, fct:Dynamic = null, id:Int = null): Howl;
	public function unload (): Void;
	public function duration (id:Int = null): Int;
	private var _webAudio:Bool;
}
#end

#else
typedef Sound = openfl._legacy.media.Sound;
#end
