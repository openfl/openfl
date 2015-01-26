package openfl.media; #if !flash #if !lime_legacy


import lime.audio.AudioSource;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;


/**
 * The SoundChannel class controls a sound in an application. Every sound is
 * assigned to a sound channel, and the application can have multiple sound
 * channels that are mixed together. The SoundChannel class contains a
 * <code>stop()</code> method, properties for monitoring the amplitude
 * (volume) of the channel, and a property for assigning a SoundTransform
 * object to the channel.
 * 
 * @event soundComplete Dispatched when a sound has finished playing.
 */
class SoundChannel extends EventDispatcher {
	
	
	/**
	 * The current amplitude(volume) of the left channel, from 0(silent) to 1
	 * (full amplitude).
	 */
	public var leftPeak (default, null):Float;
	
	/**
	 * When the sound is playing, the <code>position</code> property indicates in
	 * milliseconds the current point that is being played in the sound file.
	 * When the sound is stopped or paused, the <code>position</code> property
	 * indicates the last point that was played in the sound file.
	 *
	 * <p>A common use case is to save the value of the <code>position</code>
	 * property when the sound is stopped. You can resume the sound later by
	 * restarting it from that saved position. </p>
	 *
	 * <p>If the sound is looped, <code>position</code> is reset to 0 at the
	 * beginning of each loop.</p>
	 */
	public var position (get, set):Float;
	
	/**
	 * The current amplitude(volume) of the right channel, from 0(silent) to 1
	 * (full amplitude).
	 */
	public var rightPeak (default, null):Float;
	
	/**
	 * The SoundTransform object assigned to the sound channel. A SoundTransform
	 * object includes properties for setting volume, panning, left speaker
	 * assignment, and right speaker assignment.
	 */
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
	
	
	/**
	 * Stops the sound playing in the channel.
	 * 
	 */
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