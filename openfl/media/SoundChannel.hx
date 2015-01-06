package openfl.media; #if !flash #if (display || openfl_next || js)


import lime.audio.AudioSource;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;


class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (default, null):Float;
	public var position (get, set):Float;
	public var rightPeak (default, null):Float;
	public var soundTransform (get, set):SoundTransform;
	
	@:noCompletion private var __isValid:Bool;
	@:noCompletion private var __source:AudioSource;
	
	#if html5
	@:noCompletion private var __soundInstance:SoundJSInstance;
	#end
	
	
	private function new (#if !html5 source:AudioSource #else soundInstance:SoundJSInstance #end = null):Void {
		
		super (this);
		
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
		#else
		__soundInstance.stop ();
		#end
		
	}
	
	
	#if html5
	@:noCompletion private function __dispose ():Void {
		
		if (!__isValid) return;
		
		__soundInstance.stop ();
		__soundInstance = null;
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_position ():Float {
		
		if (!__isValid) return 0;
		
		#if !html5
		return __source.timeOffset / 1000;
		#else
		return __soundInstance.getPosition ();
		#end
		
	}
	
	
	@:noCompletion private function set_position (value:Float):Float {
		
		if (!__isValid) return 0;
		
		#if !html5
		__source.timeOffset = Std.int (value * 1000);
		return value;
		#else
		__soundInstance.setPosition (Std.int (value));
		return __soundInstance.getPosition ();
		#end
		
	}
	
	
	@:noCompletion private function get_soundTransform ():SoundTransform {
		
		if (!__isValid) return new SoundTransform ();
		
		// TODO: pan
		
		#if !html5
		return new SoundTransform (__source.gain, 0);
		#else
		return new SoundTransform (__soundInstance.getVolume (), __soundInstance.getPan ());
		#end
		
	}
	
	
	@:noCompletion private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		if (!__isValid) return value;
		
		#if !html5
		__source.gain = value.volume;
		
		// TODO: pan
		
		return value;
		#else
		__soundInstance.setVolume (value.volume);
		__soundInstance.setPan (value.pan);
		
		return value;
		#end
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	#if html5
	@:noCompletion private function soundInstance_onComplete (_):Void {
		
		dispatchEvent (new Event (Event.SOUND_COMPLETE));
		
	}
	#end
	
	
	@:noCompletion private function source_onComplete ():Void {
		
		dispatchEvent (new Event (Event.SOUND_COMPLETE));
		
	}
	
	
}


#else
typedef SoundChannel = openfl._v2.media.SoundChannel;
#end
#else
typedef SoundChannel = flash.media.SoundChannel;
#end