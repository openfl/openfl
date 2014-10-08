package openfl.media; #if !flash #if (display || openfl_next || js)


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
	@:noCompletion private static var __registeredSounds = new Map<String, Bool> ();
	#end
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var id3 (get, null):ID3Info;
	public var isBuffering (default, null):Bool;
	public var length (default, null):Float;
	public var url (default, null):String;
	
	@:noCompletion private var __buffer:AudioBuffer;
	
	#if html5
	@:noCompletion private var __sound:SoundJSInstance;
	@:noCompletion private var __soundID:String;
	#end
	
	
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
	
	
	public function load (stream:URLRequest, context:SoundLoaderContext = null):Void {
		
		#if !html5
		AudioBuffer.fromURL (stream.url, AudioBuffer_onURLLoad);
		#else
		url = stream.url;
		__soundID = Path.withoutExtension (stream.url);
		
		if (!__registeredSounds.exists (__soundID)) {
			
			__registeredSounds.set (__soundID, true);
			SoundJS.addEventListener ("fileload", SoundJS_onFileLoad);
			SoundJS.registerSound (url, __soundID);
			
		} else {
			
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		#end
		
	}
	
	
	public function loadCompressedDataFromByteArray (bytes:ByteArray, bytesLength:Int, forcePlayAsMusic = false):Void {
		
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
		
		if (sndTransform == null) {
			
			sndTransform = new SoundTransform (1, 0);
			
		}
		
		// TODO: handle start time, loops, sound transform
		
		#if !html5
		var source = new AudioSource (__buffer);
		return new SoundChannel (source);
		#else
		var instance = SoundJS.play (__soundID, SoundJS.INTERRUPT_ANY, 0, Std.int (startTime), loops, sndTransform.volume, sndTransform.pan);
		return new SoundChannel (instance);
		#end
		
	}
	
	
	#if html5
	@:noCompletion private static function __init__ ():Void {
		
		if (untyped window.createjs != null) {
			
			SoundJS.alternateExtensions = [ "ogg", "mp3", "wav" ];
			
		}
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_id3 ():ID3Info {
		
		return new ID3Info ();
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	@:noCompletion private function AudioBuffer_onURLLoad (buffer:AudioBuffer):Void {
		
		__buffer = buffer;
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	#if html5
	@:noCompletion private function SoundJS_onFileLoad (event:Dynamic):Void {
		
		if (event.id == __soundID) {
			
			SoundJS.removeEventListener ("fileload", SoundJS_onFileLoad);
			dispatchEvent (new Event (Event.COMPLETE));
			
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


#else
typedef Sound = openfl._v2.media.Sound;
#end
#else
typedef Sound = flash.media.Sound;
#end