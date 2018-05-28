package flash.media {
	
	
	import flash.utils.ByteArray;
	
	
	/**
	 * @externs
	 */
	final public class SoundMixer {
		
		public static var bufferTime:int;
		public static var soundTransform:SoundTransform;
		
		public static function areSoundsInaccessible ():Boolean { return false; }
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function computeSpectrum (outputArray:ByteArray, FFTMode:Bool = false, stretchFactor:Int = 0):Void;
		// #end
		
		public static function stopAll ():void {}
		
	}
	
	
}