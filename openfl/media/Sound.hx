package openfl.media; #if (!openfl_legacy || disable_legacy_audio)


import haxe.io.Path;
import lime.audio.AudioBuffer;
import lime.audio.AudioSource;
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
	private var data:Dynamic;
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

		#else

	/*	if (__registeredSounds.exists (__soundID)) {

			SoundJS.removeSound (__soundID);

		}
*/
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
		__sound = new Howl({
			src:stream.url,
			sprite : {
				background : [1000, 21000],
			},
			onload:function() {
				dispatchEvent (Event.__create (Event.COMPLETE));
			},
			onloaderror:function() {
				dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			}
		});
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
		this.numberOfLoopsRemaining = loops;
		__sound.volume(sndTransform.volume);
		__sound.loop(loops > 1);
		__sound.on("end", onEndSound);
		__sound.seek(Std.int (startTime));
		__sound.play('background');

		return SoundChannel.__create (__sound);

		#end

	}

	#if html5
	public function onEndSound() {
		if(this.numberOfLoopsRemaining == 1)
			__sound.stop();
		else
			this.numberOfLoopsRemaining -= 1;

	}
	#end


	#if html5
	private static function __init__ ():Void {

		/*if (untyped window.createjs != null) {
ls
			SoundJS.alternateExtensions = [ "m4a" ];

		}*/ // ???????? :TODO: check this

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
	/*private function SoundJS_onFileLoad (event:Dynamic):Void {

		if (event.id == __soundID) {

			SoundJS.removeEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.removeEventListener ("fileerror", SoundJS_onFileError);
			dispatchEvent (Event.__create (Event.COMPLETE));

		}

	}

	private function SoundJS_onFileError (event:Dynamic):Void {

		if (event.id == __soundID) {

			SoundJS.removeEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.removeEventListener ("fileerror", SoundJS_onFileError);
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));

		}

	}*/
	#end


}


#if html5

@:native("Howl") extern class Howl {
	public function new (o:Dynamic): Void;
	public function load (): Howl;
	public function play (spriteOrId:Dynamic = null): Int;
	public function pause (id:Int = null): Howl;
	public function stop (id:Int = null): Howl;
	public function mute (muted:Bool, id:Int = null): Howl;
	public function volume (vol:Float = null, id:Int = null): Dynamic;
	public function fade (from:Float, to:Float, len:Int, id:Int = null): Howl;
	public function loop (loop:Bool = null, id:Int = null): Dynamic;
	public function rate (rate:Int = null, id:Int = null): Dynamic;
	public function seek (rate:Int = null, id:Int = null): Dynamic;
	public function playing (id:Int = null): Bool;
	public function duration (id:Int = null): Int;
	public function unload (): Void;
	public function on (event:String, fct:Dynamic, id:Int = null, once:Int = null): Howl;
	public function off (event:String, fct:Dynamic, id:Int = null): Howl;
	public function once (event:String, fct:Dynamic, id:Int = null): Howl;


}

@:native("Howler") extern class Howler {
	public function new (): Void;
	public function volume (vol:Float): Dynamic;
	public function mute (muted:Bool): Void;
	public function unload (): Howler;
	public function codecs (ext:String): Bool;

}
/*
@:native("createjs.Sound") extern class SoundJS {

	public static function addEventListener (type:String, listener:Dynamic, ?useCapture:Bool):Dynamic;
	public static function dispatchEvent (eventObj:Dynamic, ?target:Dynamic):Bool;
	public static function hasEventListener (type:String):Bool;
	public static function removeAllEventListeners (?type:String):Void;
	public static function removeEventListener (type:String, listener:Dynamic, ?useCapture:Bool):Void;

	public static function createInstance (src:String):SoundJSInstance;
	public static function getCapabilities ():Dynamic;
	public static function getCapability (key:String):Dynamic;
	public static function getMute ():Bool;
	public static function getVolume ():Float;
	public static function initializeDefaultPlugins ():Bool;
	public static function isReady ():Bool;
	public static function loadComplete (src:String):Bool;
	//public static function mute(value:Bool):Void;
	public static function play (src:String, ?interrupt:String = INTERRUPT_NONE, ?delay:Int = 0, ?offset:Int = 0, ?loop:Int = 0, ?volume:Float = 1, ?pan:Float = 0):SoundJSInstance;
	public static function registerManifest (manifest:Array<Dynamic>, basepath:String):Dynamic;
	public static function registerPlugin (plugin:Dynamic):Bool;
	public static function registerPlugins (plugins:Array<Dynamic>):Bool;
	public static function registerSound (src:String, ?id:String, ?data:Float, ?preload:Bool = true):Dynamic;

	public static function removeAllSounds ():Void;
	public static function removeManifest (manifest:Array<Dynamic>):Dynamic;
	public static function removeSound (src:String):Void;

	public static function setMute (value:Bool):Bool;
	public static function setVolume (value:Float):Void;
	public static function stop ():Void;

	public static var activePlugin:Dynamic;
	public static var alternateExtensions:Array<String>;
	//public static var AUDIO_TIMEOUT:Float;
	public static var defaultInterruptBehavior:String;
	public static var DELIMITER:String;
	//public static var EXTENSION_MAP:Dynamic;
	public static inline var INTERRUPT_ANY:String = "any";
	public static inline var INTERRUPT_EARLY:String = "early";
	public static inline var INTERRUPT_LATE:String = "late";
	public static inline var INTERRUPT_NONE:String = "none";
	//public var onLoadComplete:Dynamic->Void;
	public static var PLAY_FAILED:String;
	public static var PLAY_FINISHED:String;
	public static var PLAY_INITED:String;
	public static var PLAY_INTERRUPTED:String;
	public static var PLAY_SUCCEEDED:String;
	public static var SUPPORTED_EXTENSIONS:Array<String>;

}


@:native("createjs.SoundInstance") extern class SoundJSInstance extends SoundJSEventDispatcher {

	public function new (src:String, owner:Dynamic):Void;
	public function getDuration ():Int;
	public function getMute ():Bool;
	public function getPan ():Float;
	public function getPosition ():Int;
	public function getVolume ():Float;
	//public function mute (value:Bool):Bool;
	public function pause ():Bool;
	public function play (?interrupt:String = Sound.INTERRUPT_NONE, ?delay:Int = 0, ?offset:Int = 0, ?loop:Int = 0, ?volume:Float = 1, ?pan:Float = 0):Void;
	public function resume ():Bool;
	public function setMute (value:Bool):Bool;
	public function setPan (value:Float):Float;
	public function setPosition (value:Int):Void;
	public function setVolume (value:Float):Bool;
	public function stop ():Bool;

	public var gainNode:Dynamic;
	public var pan:Float;
	public var panNode:Dynamic;
	public var playState:String;
	public var sourceNode:Dynamic;
	//public var startTime:Float;
	public var uniqueId:Dynamic;
	public var volume:Float;

	public var onComplete:SoundJSInstance->Void;
	public var onLoop:SoundJSInstance->Void;
	public var onPlayFailed:SoundJSInstance->Void;
	public var onPlayInterrupted:SoundJSInstance->Void;
	public var onPlaySucceeded:SoundJSInstance->Void;
	public var onReady:SoundJSInstance->Void;

}


@:native("createjs.EventDispatcher") extern class SoundJSEventDispatcher {

	public function addEventListener (type:String, listener:Dynamic, ?useCapture:Bool):Dynamic;
	public function dispatchEvent (eventObj:Dynamic, ?target:Dynamic):Bool;
	public function hasEventListener (type:String):Bool;
	public static function initialize (target:Dynamic):Void;
	public function off (type:String, listener:Dynamic, ?useCapture:Bool):Bool;
	public function on (type:String, listener:Dynamic, ?scope:Dynamic, ?once:Bool=false, ?data:Dynamic = null, ?useCapture:Bool=false):Dynamic;
	public function removeAllEventListeners (?type:String):Void;
	public function removeEventListener(type:String, listener:Dynamic, ?useCapture:Bool):Void;
	public function toString ():String;

}*/
#end


#else
typedef Sound = openfl._legacy.media.Sound;
#end
