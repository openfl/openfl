package flash.media;

#if flash
import openfl.utils.ByteArray;

@:final extern class SoundMixer
{
	#if (haxe_ver < 4.3)
	public static var bufferTime:Int;
	public static var soundTransform:SoundTransform;
	#if air
	public static var audioPlaybackMode:String;
	public static var useSpeakerphoneForVoice:Bool;
	#end
	#else
	@:flash.property static var bufferTime(get, set):Int;
	@:flash.property static var soundTransform(get, set):SoundTransform;
	#if air
	@:flash.property static var audioPlaybackMode(get, set):String;
	@:flash.property static var useSpeakerphoneForVoice(get, set):Bool;
	#end
	#end
	public static function areSoundsInaccessible():Bool;
	public static function computeSpectrum(outputArray:ByteArray, FFTMode:Bool = false, stretchFactor:Int = 0):Void;
	public static function stopAll():Void;

	#if (haxe_ver >= 4.3)
	private static function get_bufferTime():Int;
	private static function get_soundTransform():SoundTransform;
	#if air
	private static function get_audioPlaybackMode():String;
	private static function get_useSpeakerphoneForVoice():Bool;
	#end
	private static function set_bufferTime(value:Int):Int;
	private static function set_soundTransform(value:SoundTransform):SoundTransform;
	#if air
	private static function set_audioPlaybackMode(value:String):String;
	private static function set_useSpeakerphoneForVoice(value:Bool):Bool;
	#end
	#end
}
#else
typedef SoundMixer = openfl.media.SoundMixer;
#end
