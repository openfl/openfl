package flash.media;
#if (flash || display)


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
@:final extern class SoundChannel extends flash.events.EventDispatcher {

	/**
	 * The current amplitude(volume) of the left channel, from 0(silent) to 1
	 * (full amplitude).
	 */
	var leftPeak(default,null) : Float;

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
	var position : Float;

	/**
	 * The current amplitude(volume) of the right channel, from 0(silent) to 1
	 * (full amplitude).
	 */
	var rightPeak(default,null) : Float;

	/**
	 * The SoundTransform object assigned to the sound channel. A SoundTransform
	 * object includes properties for setting volume, panning, left speaker
	 * assignment, and right speaker assignment.
	 */
	var soundTransform : SoundTransform;
	function new() : Void;

	/**
	 * Stops the sound playing in the channel.
	 * 
	 */
	function stop() : Void;
}


#end
