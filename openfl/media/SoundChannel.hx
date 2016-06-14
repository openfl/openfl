package openfl.media;


import lime.audio.AudioSource;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;


@:final @:keep class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (default, null):Float;
	public var position (get, set):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform (get, set):SoundTransform;
	
	private var __isValid:Bool;
	private var __source:AudioSource;
	
	#if html5
	private var __soundInstance:SoundJSInstance;
	#end
	
	
	private function new (#if !html5 source:AudioSource #else soundInstance:SoundJSInstance #end = null):Void {
		
		super (this);
		
		leftPeak = 1;
		rightPeak = 1;
		
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
		
	}
	
	
	public function stop ():Void {
		
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
		
		if (!__isValid) return new SoundTransform ();
		
		// TODO: pan
		
		#if !html5
		return new SoundTransform (__source.gain, 0);
		#else
		return new SoundTransform (__soundInstance.getVolume (), __soundInstance.getPan ());
		#end
		
	}
	
	
	private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		if (!__isValid) return value;
		
		#if !html5
		__source.gain = value.volume;
		
		var position = __source.position;
		position.x = value.pan;
		position.z = -1 * Math.sqrt (1 - Math.pow (value.pan, 2));
		__source.position = position;
		
		return value;
		#else
		__soundInstance.setVolume (value.volume);
		__soundInstance.setPan (value.pan);
		
		return value;
		#end
		
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