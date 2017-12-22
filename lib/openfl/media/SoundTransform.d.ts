declare namespace openfl.media {
	
	
	/**
	 * The SoundTransform class contains properties for volume and panning.
	 */
	/*@:final*/ export class SoundTransform {
		
		
		/**
		 * A value, from 0(none) to 1(all), specifying how much of the left input
		 * is played in the left speaker.
		 */
		public leftToLeft:number;
		
		/**
		 * A value, from 0(none) to 1(all), specifying how much of the left input
		 * is played in the right speaker.
		 */
		public leftToRight:number;
		
		/**
		 * The left-to-right panning of the sound, ranging from -1(full pan left) to
		 * 1(full pan right). A value of 0 represents no panning(balanced center
		 * between right and left).
		 */
		public pan:number;
		
		/**
		 * A value, from 0(none) to 1(all), specifying how much of the right input
		 * is played in the left speaker.
		 */
		public rightToLeft:number;
		
		/**
		 * A value, from 0(none) to 1(all), specifying how much of the right input
		 * is played in the right speaker.
		 */
		public rightToRight:number;
		
		/**
		 * The volume, ranging from 0(silent) to 1(full volume).
		 */
		public volume:number;
		
		
		/**
		 * Creates a SoundTransform object.
		 * 
		 * @param vol     The volume, ranging from 0(silent) to 1(full volume).
		 * @param panning The left-to-right panning of the sound, ranging from -1
		 *               (full pan left) to 1(full pan right). A value of 0
		 *                represents no panning(center).
		 */
		public constructor (vol?:number, panning?:number);
		
		
		public clone ():SoundTransform;
		
		
	}
	
	
}


export default openfl.media.SoundTransform;