package flash.media {
	
	
	import flash.events.EventDispatcher;
	
	
	/**
	 * @externs
	 * The SoundChannel class controls a sound in an application. Every sound is
	 * assigned to a sound channel, and the application can have multiple sound
	 * channels that are mixed together. The SoundChannel class contains a
	 * `stop()` method, properties for monitoring the amplitude
	 * (volume) of the channel, and a property for assigning a SoundTransform
	 * object to the channel.
	 * 
	 * @event soundComplete Dispatched when a sound has finished playing.
	 */
	final public class SoundChannel extends EventDispatcher {
		
		
		/**
		 * The current amplitude(volume) of the left channel, from 0(silent) to 1
		 * (full amplitude).
		 */
		public function get leftPeak ():Number { return 0; }
		
		/**
		 * When the sound is playing, the `position` property indicates in
		 * milliseconds the current point that is being played in the sound file.
		 * When the sound is stopped or paused, the `position` property
		 * indicates the last point that was played in the sound file.
		 *
		 * A common use case is to save the value of the `position`
		 * property when the sound is stopped. You can resume the sound later by
		 * restarting it from that saved position. 
		 *
		 * If the sound is looped, `position` is reset to 0 at the
		 * beginning of each loop.
		 */
		public var position:Number;
		
		protected function get_position ():Number { return 0; }
		protected function set_position (value:Number):Number { return 0; }
		
		/**
		 * The current amplitude(volume) of the right channel, from 0(silent) to 1
		 * (full amplitude).
		 */
		public function get rightPeak ():Number { return 0; }
		
		/**
		 * The SoundTransform object assigned to the sound channel. A SoundTransform
		 * object includes properties for setting volume, panning, left speaker
		 * assignment, and right speaker assignment.
		 */
		public var soundTransform:SoundTransform;
		
		protected function get_soundTransform ():SoundTransform { return null; }
		protected function set_soundTransform (value:SoundTransform):SoundTransform { return null; }
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function new ();
		// #end
		
		
		/**
		 * Stops the sound playing in the channel.
		 * 
		 */
		public function stop ():void {}
		
		
	}
	
	
}