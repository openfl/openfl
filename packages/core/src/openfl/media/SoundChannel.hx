package openfl.media;

#if !flash
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
	The SoundChannel class controls a sound in an application. Every sound is
	assigned to a sound channel, and the application can have multiple sound
	channels that are mixed together. The SoundChannel class contains a
	`stop()` method, properties for monitoring the amplitude
	(volume) of the channel, and a property for assigning a SoundTransform
	object to the channel.

	@event soundComplete Dispatched when a sound has finished playing.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final @:keep class SoundChannel extends EventDispatcher
{
	/**
		The current amplitude(volume) of the left channel, from 0(silent) to 1
		(full amplitude).
	**/
	public var leftPeak(get, never):Float;

	/**
		When the sound is playing, the `position` property indicates in
		milliseconds the current point that is being played in the sound file.
		When the sound is stopped or paused, the `position` property
		indicates the last point that was played in the sound file.

		A common use case is to save the value of the `position`
		property when the sound is stopped. You can resume the sound later by
		restarting it from that saved position.

		If the sound is looped, `position` is reset to 0 at the
		beginning of each loop.
	**/
	public var position(get, set):Float;

	/**
		The current amplitude(volume) of the right channel, from 0(silent) to 1
		(full amplitude).
	**/
	public var rightPeak(get, never):Float;

	/**
		The SoundTransform object assigned to the sound channel. A SoundTransform
		object includes properties for setting volume, panning, left speaker
		assignment, and right speaker assignment.
	**/
	public var soundTransform(get, set):SoundTransform;

	@:allow(openfl) @:noCompletion private function new(sound:Sound = null, startTime:Float = 0, loops:Int = 0, soundTransform:SoundTransform = null):Void
	{
		_ = new _SoundChannel(sound, startTime, loops, soundTransform);

		super(this);
	}

	/**
		Stops the sound playing in the channel.
	**/
	public function stop():Void
	{
		(_ : _SoundChannel).stop();
	}

	// Get & Set Methods

	@:noCompletion private function get_leftPeak():Float
	{
		return (_ : _SoundChannel).leftPeak;
	}

	@:noCompletion private function get_position():Float
	{
		return (_ : _SoundChannel).position;
	}

	@:noCompletion private function set_position(value:Float):Float
	{
		return (_ : _SoundChannel).position = value;
	}

	@:noCompletion private function get_rightPeak():Float
	{
		return (_ : _SoundChannel).rightPeak;
	}

	@:noCompletion private function get_soundTransform():SoundTransform
	{
		return (_ : _SoundChannel).soundTransform;
	}

	@:noCompletion private function set_soundTransform(value:SoundTransform):SoundTransform
	{
		return (_ : _SoundChannel).soundTransform = value;
	}
}
#else
typedef SoundChannel = flash.media.SoundChannel;
#end
