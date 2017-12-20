package openfl.media;


import lime.media.AudioSource;
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
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (SoundChannel.prototype, {
			"position": { get: untyped __js__ ("function () { return this.get_position (); }"), set: untyped __js__ ("function (v) { return this.set_position (v); }") },
			"soundTransform": { get: untyped __js__ ("function () { return this.get_soundTransform (); }"), set: untyped __js__ ("function (v) { return this.set_soundTransform (v); }") },
		});
		
	}
	#end
	
	
	private function new (source:AudioSource = null, soundTransform:SoundTransform = null):Void {
		
		super (this);
		
		leftPeak = 1;
		rightPeak = 1;
		
		if (soundTransform != null) {
			
			__soundTransform = soundTransform;
			
		} else {
			
			__soundTransform = new SoundTransform ();
			
		}
		
		if (source != null) {
			
			__source = source;
			__source.onComplete.add (source_onComplete);
			__isValid = true;
			
			__source.play ();
			
		}
		
		SoundMixer.__registerSoundChannel (this);
		
	}
	
	
	public function stop ():Void {
		
		SoundMixer.__unregisterSoundChannel (this);
		
		if (!__isValid) return;
		
		__source.stop ();
		__dispose ();
		
	}
	
	
	private function __dispose ():Void {
		
		if (!__isValid) return;
		
		__source.onComplete.remove (source_onComplete);
		__source.dispose ();
		__isValid = false;
		
	}
	
	
	private function __updateTransform ():Void {
		
		this.soundTransform = soundTransform;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_position ():Float {
		
		if (!__isValid) return 0;
		
		return __source.currentTime + __source.offset;
		
	}
	
	
	private function set_position (value:Float):Float {
		
		if (!__isValid) return 0;
		
		__source.currentTime = Std.int (value) - __source.offset;
		return value;
		
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
				
				__source.gain = volume;
				
				var position = __source.position;
				position.x = pan;
				position.z = -1 * Math.sqrt (1 - Math.pow (pan, 2));
				__source.position = position;
				
				return value;
				
			}
			
		}
		
		return value;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function source_onComplete ():Void {
		
		SoundMixer.__unregisterSoundChannel (this);
		
		__dispose ();
		dispatchEvent (new Event (Event.SOUND_COMPLETE));
		
	}
	
	
}