package openfl.media {
	
	
	/**
	 * @externs
	 * The SoundTransform class contains properties for volume and panning.
	 */
	final public class SoundTransform {
		
		
		/**
		 * A value, from 0(none) to 1(all), specifying how much of the left input
		 * is played in the left speaker.
		 */
		public var leftToLeft:Number;
		
		/**
		 * A value, from 0(none) to 1(all), specifying how much of the left input
		 * is played in the right speaker.
		 */
		public var leftToRight:Number;
		
		/**
		 * The left-to-right panning of the sound, ranging from -1(full pan left) to
		 * 1(full pan right). A value of 0 represents no panning(balanced center
		 * between right and left).
		 */
		public var pan:Number;
		
		/**
		 * A value, from 0(none) to 1(all), specifying how much of the right input
		 * is played in the left speaker.
		 */
		public var rightToLeft:Number;
		
		/**
		 * A value, from 0(none) to 1(all), specifying how much of the right input
		 * is played in the right speaker.
		 */
		public var rightToRight:Number;
		
		/**
		 * The volume, ranging from 0(silent) to 1(full volume).
		 */
		public var volume:Number;
		
		
		/**
		 * Creates a SoundTransform object.
		 * 
		 * @param vol     The volume, ranging from 0(silent) to 1(full volume).
		 * @param panning The left-to-right panning of the sound, ranging from -1
		 *               (full pan left) to 1(full pan right). A value of 0
		 *                represents no panning(center).
		 */
		public function SoundTransform (vol:Number = 1, panning:Number = 0) {}
		
		
		public function clone ():SoundTransform { return null; }
		
		
	}
	
	
}