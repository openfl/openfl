package openfl.media;


@:access(openfl.media.SoundChannel)


@:final class SoundMixer {
	
	
	private static inline var MAX_ACTIVE_CHANNELS = 32;
	
	public static var bufferTime:Int;
	public static var soundTransform (get, set):SoundTransform;
	
	private static var __soundChannels = new Array<SoundChannel> ();
	private static var __soundTransform = #if mute_sound new SoundTransform (0) #else new SoundTransform () #end;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (SoundMixer, "soundTransform", { get: function () { return SoundMixer.get_soundTransform (); }, set: function (value) { return SoundMixer.set_soundTransform (value); } });
		
	}
	#end
	
	
	public static function areSoundsInaccessible ():Bool {
		
		return false;
		
	}
	
	
	public static function stopAll ():Void {
		
		for (channel in __soundChannels) {
			
			channel.stop ();
			
		}
		
	}
	
	
	private static function __registerSoundChannel (soundChannel:SoundChannel):Void {
		
		__soundChannels.push (soundChannel);
		
	}
	
	
	private static function __unregisterSoundChannel (soundChannel:SoundChannel):Void {
		
		__soundChannels.remove (soundChannel);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private static function get_soundTransform ():SoundTransform {
		
		return __soundTransform;
		
	}
	
	
	private static function set_soundTransform (value:SoundTransform):SoundTransform {
		
		__soundTransform = value.clone ();
		
		for (channel in __soundChannels) {
			
			channel.__updateTransform ();
			
		}
		
		return value;
		
	}
	
	
}