package flash.media;

#if flash
import openfl.utils.ByteArray;

@:final extern class SoundMixer
{
	#if (flash && air)
	public static var audioPlaybackMode:String;
	#end
	public static var bufferTime:Int;
	public static var soundTransform:SoundTransform;
	#if (flash && air)
	public static var useSpeakerphoneForVoice:Bool;
	#end
	public static function areSoundsInaccessible():Bool;
	#if flash
	@:noCompletion @:dox(hide) public static function computeSpectrum(outputArray:ByteArray, FFTMode:Bool = false, stretchFactor:Int = 0):Void;
	#end
	public static function stopAll():Void;
}
#else
typedef SoundMixer = openfl.media.SoundMixer;
#end
