package openfl.media;

#if (display || !flash)
import openfl.utils.ByteArray;

#if !openfl_global
@:jsRequire("openfl/media/SoundMixer", "default")
#end
@:final extern class SoundMixer
{
	public static var bufferTime:Int;
	public static var soundTransform:SoundTransform;
	public static function areSoundsInaccessible():Bool;
	#if flash
	@:noCompletion @:dox(hide) public static function computeSpectrum(outputArray:ByteArray, FFTMode:Bool = false, stretchFactor:Int = 0):Void;
	#end
	public static function stopAll():Void;
}
#else
typedef SoundMixer = flash.media.SoundMixer;
#end
