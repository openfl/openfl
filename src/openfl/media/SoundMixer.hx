package openfl.media; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.media.SoundChannel)


@:final class SoundMixer {
	
	
	@:noCompletion private static inline var MAX_ACTIVE_CHANNELS = 32;
	
	public static var bufferTime:Int;
	public static var soundTransform (get, set):SoundTransform;
	
	@:noCompletion private static var __soundChannels = new Array<SoundChannel> ();
	@:noCompletion private static var __soundTransform = #if (mute || mute_sound) new SoundTransform (0) #else new SoundTransform () #end;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperty (SoundMixer, "soundTransform", { get: function () { return SoundMixer.get_soundTransform (); }, set: function (value) { return SoundMixer.set_soundTransform (value); } });
		
	}
	#end
	
	
	public static function areSoundsInaccessible ():Bool {
		
		return false;
		
	}
	
	
	// @:noCompletion @:dox(hide) public static function computeSpectrum (outputArray:ByteArray, FFTMode:Bool = false, stretchFactor:Int = 0):Void;
	
	
	public static function stopAll ():Void {
		
		for (channel in __soundChannels) {
			
			channel.stop ();
			
		}
		
	}
	
	
	@:noCompletion private static function __registerSoundChannel (soundChannel:SoundChannel):Void {
		
		__soundChannels.push (soundChannel);
		
	}
	
	
	@:noCompletion private static function __unregisterSoundChannel (soundChannel:SoundChannel):Void {
		
		__soundChannels.remove (soundChannel);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private static function get_soundTransform ():SoundTransform {
		
		return __soundTransform;
		
	}
	
	
	@:noCompletion private static function set_soundTransform (value:SoundTransform):SoundTransform {
		
		__soundTransform = value.clone ();
		
		for (channel in __soundChannels) {
			
			channel.__updateTransform ();
			
		}
		
		return value;
		
	}
	
	
}


#else
typedef SoundMixer = flash.media.SoundMixer;
#end