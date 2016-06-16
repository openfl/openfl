package openfl.media;


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
	#end
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var id3 (get, null):ID3Info;
	public var isBuffering (default, null):Bool;
	public var length (get, never):Float;
	public var url (default, null):String;
	
	private var __buffer:AudioBuffer;
	
	#if html5
	private var __sound:SoundJSInstance;
	private var __soundID:String;
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
		
		if (__registeredSounds.exists (__soundID)) {
			
			SoundJS.removeSound (__soundID);
			
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
		
		url = stream.url;

		#if !html5
		
		AudioBuffer.fromURL (stream.url, AudioBuffer_onURLLoad);
		
		#else
		
		__soundID = Path.withoutExtension (stream.url);
		
		if (!__registeredSounds.exists (__soundID)) {
			
			__registeredSounds.set (__soundID, true);
			SoundJS.addEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.addEventListener ("fileerror", SoundJS_onFileError);
			SoundJS.registerSound (url, __soundID);
			
		} else {
			
			dispatchEvent (new Event (Event.COMPLETE));
			
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
		
		#if !html5
		
		var source = new AudioSource (__buffer);
		source.offset = Std.int (startTime * 1000);
		if (loops > 1) source.loops = loops - 1;
		
		if (sndTransform != null) {
			
			source.gain = sndTransform.volume;
			
			var position = source.position;
			position.x = sndTransform.pan;
			position.z = -1 * Math.sqrt (1 - Math.pow (sndTransform.pan, 2));
			source.position = position;
			
		}
		
		return new SoundChannel (source);
		
		#else
		
		if (sndTransform == null) {
			
			sndTransform = new SoundTransform (1, 0);
			
		}
		
		var pan = sndTransform.pan;
		
		// Hack to fix sound balance
		
		if (pan == 0) pan = -0.0000001;
		
		var instance = 
		if (loops > 1)
			SoundJS.play (__soundID, SoundJS.INTERRUPT_ANY, 0, Std.int (startTime), loops - 1, sndTransform.volume, pan);
		else
			SoundJS.play (__soundID, SoundJS.INTERRUPT_ANY, 0, Std.int (startTime), 0, sndTransform.volume, pan);
		
		return new SoundChannel (instance);
		
		#end
		
	}
	
	
	#if html5
	private static function __init__ ():Void {
		
		if (untyped window.createjs != null) {
			
			SoundJS.alternateExtensions = [ "ogg", "m4a", "mp3", "wav" ];
			
		}
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_id3 ():ID3Info {
		
		return new ID3Info ();
		
	}
	
	
	private function get_length ():Int {
		
		if (__buffer != null) {
			
			#if flash
			
			return Std.int (__buffer.src.length);
			
			#elseif !html5
			
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
	
	
	#if html5
	private function SoundJS_onFileLoad (event:Dynamic):Void {
		
		if (event.id == __soundID) {
			
			SoundJS.removeEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.removeEventListener ("fileerror", SoundJS_onFileError);
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	private function SoundJS_onFileError (event:Dynamic):Void {
		
		if (event.id == __soundID) {
			
			SoundJS.removeEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.removeEventListener ("fileerror", SoundJS_onFileError);
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			
		}
		
	}
	#end
	
	
}


#if html5
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
	
}
#end