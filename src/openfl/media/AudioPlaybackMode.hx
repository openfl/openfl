package openfl.media;

#if (!flash && sys)

#if !openfljs
/**
	The AudioPlaybackMode class defines constants for the `audioPlaybackMode`
	property of the SoundMixer class.

	**Known Issue:** No audio is played in the Media Playback mode for
	StageVideo, when the mute switch is ON.

	Each of these constants represents a set of behavior for audio on mobile
	tailored to a particular use.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AudioPlaybackMode(Null<Int>)

{
	/**
		A mode for playing ambient sound. Use this mode for playing sounds that
		are accompaniments to the actual purpose of the application and are not
		necessary for its successful use. When using this mode, audio is routed
		through the speakerphone. If headphones are plugged in, they override
		the speakerphone. The operating system uses defaults for ambient sound
		when deciding behavior and priority for audio.

		This setting has no special effect on the desktop or TV.

		On iOS, using this mode causes audio to be silenced by locking the
		screen (or sending the app to the background by any other means) and
		enabling the hardware Silent switch while the Microphone is not in use.
		If a Microphone is in use, audio is not affected by these actions.

		**Note:** Audio is not silenced by the Silent switch if a Headset is
		connected.
	**/
	public var AMBIENT = 0;

	/**
		A mode for playing media sounds. When using this mode on mobile, sound
		is routed through the speakerphone. If headphones are plugged in they
		override the speakerphone. The operating system uses defaults for media
		audio when deciding behavior and priority for audio.

		This setting has no special effect on the desktop or TV.

		This is the default.
	**/
	public var MEDIA = 1;

	/**
		A mode for playing voice audio. When using this mode, audio is routed
		through the phone earpiece by default. If headphones are plugged in they
		override the earpiece. If the `SoundMixer.useSpeakerphoneForVoice`
		property is set, sound goes to the speakerphone, overriding the
		earpiece/headphones. The operating system uses defaults for voice audio
		when deciding behavior and priority for audio.

		Try to minimize usage of `AudioPlaybackMode.VOICE`, and try to switch to
		`AudioPlaybackMode.MEDIA` as soon as possible after a voice call ends,
		which allows other applications to play in media mode.

		This setting has no special effect on the desktop or TV.
	**/
	public var VOICE = 2;

	@:from private static function fromString(value:String):AudioPlaybackMode
	{
		return switch (value)
		{
			case "ambient": AMBIENT;
			case "media": MEDIA;
			case "voice": VOICE;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : AudioPlaybackMode)
		{
			case AudioPlaybackMode.AMBIENT: "ambient";
			case AudioPlaybackMode.MEDIA: "media";
			case AudioPlaybackMode.VOICE: "voice";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract AudioPlaybackMode(String) from String to String

{
	public var AMBIENT = "ambient";
	public var MEDIA = "media";
	public var VOICE = "voice";
}
#end
#else
#if air
typedef AudioPlaybackMode = flash.media.AudioPlaybackMode;
#end
#end
