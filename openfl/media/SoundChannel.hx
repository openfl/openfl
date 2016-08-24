package openfl.media;


import lime.audio.AudioSource;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;

@:access(openfl.media.SoundMixer)


@:final @:keep class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (default, null):Float;
	public var position (get, set):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform (get, set):SoundTransform;
	
	private var __isValid:Bool;
	private var __soundTransform:SoundTransform;
	private var __source:AudioSource;
	
	#if html5
	private var __soundInstance:SoundJSInstance;
	#end
	
	
	private function new (#if !html5 source:AudioSource #else soundInstance:SoundJSInstance #end = null, soundTransform:SoundTransform = null):Void {
		
		super (this);
		
		leftPeak = 1;
		rightPeak = 1;
		
		if (soundTransform != null) {
			
			__soundTransform = soundTransform;
			
		} else {
			
			__soundTransform = new SoundTransform ();
			
		}
		
		#if !html5
			
			if (source != null) {
				
				__source = source;
				__source.onComplete.add (source_onComplete);
				__isValid = true;
				
				__source.play ();
				
			}
			
		#else
			
			if (soundInstance != null) {
				
				__soundInstance = soundInstance;
				__soundInstance.addEventListener ("complete", source_onComplete);
				__isValid = true;
				
			}
			
		#end
		
		SoundMixer.__registerSoundChannel (this);
		
	}
	
	
	public function stop ():Void {
		
		SoundMixer.__unregisterSoundChannel (this);
		
		if (!__isValid) return;
		
		#if !html5
		__source.stop ();
		__dispose ();
		#else
		__soundInstance.stop ();
		#end
		
	}
	
	
	private function __dispose ():Void {
		
		if (!__isValid) return;
		
		#if !html5
		__source.dispose ();
		#else
		__soundInstance.stop ();
		__soundInstance = null;
		#end
		
		__isValid = false;
		
	}
	
	
	private function __updateTransform ():Void {
		
		this.soundTransform = soundTransform;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_position ():Float {
		
		if (!__isValid) return 0;
		
		#if !html5
		return (__source.currentTime + __source.offset) / 1000;
		#else
		return __soundInstance.getPosition ();
		#end
		
	}
	
	
	private function set_position (value:Float):Float {
		
		if (!__isValid) return 0;
		
		#if !html5
		__source.currentTime = Std.int (value * 1000) - __source.offset;
		return value;
		#else
		__soundInstance.setPosition (Std.int (value));
		return __soundInstance.getPosition ();
		#end
		
	}
	
	
	private function get_soundTransform ():SoundTransform {
		
		return __soundTransform.clone ();
		
	}
	
	
	private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		if (value != null) {
			
			__soundTransform.pan = value.pan;
			__soundTransform.volume = value.volume;
			
			var pan = SoundMixer.__soundTransform.pan + __soundTransform.pan;
			
			if (pan < -1) pan = -1;
			if (pan > 1) pan = 1;
			
			var volume = SoundMixer.__soundTransform.volume * __soundTransform.volume;
			
			if (__isValid) {
				
				#if !html5
				__source.gain = volume;
				
				var position = __source.position;
				position.x = pan;
				position.z = -1 * Math.sqrt (1 - Math.pow (pan, 2));
				__source.position = position;
				
				return value;
				#else
				__soundInstance.setVolume (volume);
				__soundInstance.setPan (pan);
				#end
				
			}
			
		}
		
		return value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	#if html5
	private function soundInstance_onComplete (_):Void {
		
		dispatchEvent (new Event (Event.SOUND_COMPLETE));
		
	}
	#end
	
	
	private function source_onComplete ():Void {
		
		__dispose ();
		dispatchEvent (new Event (Event.SOUND_COMPLETE));
		
	}
	
	
}