package flash.media;
#if (flash || display)


/**
 * The SoundTransform class contains properties for volume and panning.
 */
@:final extern class SoundTransform {

	/**
	 * A value, from 0(none) to 1(all), specifying how much of the left input
	 * is played in the left speaker.
	 */
	var leftToLeft : Float;

	/**
	 * A value, from 0(none) to 1(all), specifying how much of the left input
	 * is played in the right speaker.
	 */
	var leftToRight : Float;

	/**
	 * The left-to-right panning of the sound, ranging from -1(full pan left) to
	 * 1(full pan right). A value of 0 represents no panning(balanced center
	 * between right and left).
	 */
	var pan : Float;

	/**
	 * A value, from 0(none) to 1(all), specifying how much of the right input
	 * is played in the left speaker.
	 */
	var rightToLeft : Float;

	/**
	 * A value, from 0(none) to 1(all), specifying how much of the right input
	 * is played in the right speaker.
	 */
	var rightToRight : Float;

	/**
	 * The volume, ranging from 0(silent) to 1(full volume).
	 */
	var volume : Float;

	/**
	 * Creates a SoundTransform object.
	 * 
	 * @param vol     The volume, ranging from 0(silent) to 1(full volume).
	 * @param panning The left-to-right panning of the sound, ranging from -1
	 *               (full pan left) to 1(full pan right). A value of 0
	 *                represents no panning(center).
	 */
	function new(vol : Float = 1, panning : Float = 0) : Void;
}


#end
