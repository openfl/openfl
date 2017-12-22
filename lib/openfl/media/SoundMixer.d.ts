import SoundTransform from "./SoundTransform";


declare namespace openfl.media {
	
	
	/*@:final*/ export class SoundMixer {
		
		public static bufferTime:number;
		public static soundTransform:SoundTransform;
		
		public static areSoundsInaccessible ():boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function computeSpectrum (outputArray:ByteArray, FFTMode:boolean = false, stretchFactor:Int = 0):Void;
		// #end
		
		public static stopAll ():void;
		
	}
	
	
}


export default openfl.media.SoundMixer;