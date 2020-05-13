package openfl.media;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.media.SoundChannel)
@:noCompletion
class _SoundMixer
{
	public static inline var MAX_ACTIVE_CHANNELS:Int = 32;

	public static var bufferTime:Int;
	public static var soundTransform(get, set):SoundTransform;

	public static var __soundChannels:Array<SoundChannel> = new Array();
	public static var __soundTransform:SoundTransform = #if (mute || mute_sound) new SoundTransform(0) #else new SoundTransform() #end;

	public static function areSoundsInaccessible():Bool
	{
		return false;
	}

	public static function stopAll():Void
	{
		for (channel in __soundChannels)
		{
			channel.stop();
		}
	}

	public static function __registerSoundChannel(soundChannel:SoundChannel):Void
	{
		__soundChannels.push(soundChannel);
	}

	public static function __unregisterSoundChannel(soundChannel:SoundChannel):Void
	{
		__soundChannels.remove(soundChannel);
	}

	// Get & Set Methods

	public static function get_soundTransform():SoundTransform
	{
		return __soundTransform;
	}

	public static function set_soundTransform(value:SoundTransform):SoundTransform
	{
		__soundTransform = value.clone();

		for (channel in __soundChannels)
		{
			(channel._ : _SoundChannel).__updateTransform();
		}

		return value;
	}
}
