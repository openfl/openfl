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
@:access(openfl.media.SoundMixer)
@:final @:keep class SoundChannel extends EventDispatcher
{
	/**
		The current amplitude(volume) of the left channel, from 0(silent) to 1
		(full amplitude).
	**/
	public var leftPeak(default, null):Float;

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
	public var rightPeak(default, null):Float;

	/**
		The SoundTransform object assigned to the sound channel. A SoundTransform
		object includes properties for setting volume, panning, left speaker
		assignment, and right speaker assignment.
	**/
	public var soundTransform(get, set):SoundTransform;

	@:noCompletion private var _:_SoundChannel;
	@:noCompletion private var __soundTransform:SoundTransform;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(SoundChannel.prototype, {
			"position": {
				get: untyped __js__("function () { return this.get_position (); }"),
				set: untyped __js__("function (v) { return this.set_position (v); }")
			},
			"soundTransform": {
				get: untyped __js__("function () { return this.get_soundTransform (); }"),
				set: untyped __js__("function (v) { return this.set_soundTransform (v); }")
			},
		});
	}
	#end

	@:noCompletion private function new(sound:Sound = null, startTime:Float = 0, loops:Int = 0, soundTransform:SoundTransform = null):Void
	{
		super(this);

		leftPeak = 1;
		rightPeak = 1;

		if (soundTransform != null)
		{
			__soundTransform = soundTransform.clone();
		}
		else
		{
			__soundTransform = new SoundTransform();
		}

		if (sound != null)
		{
			SoundMixer.__registerSoundChannel(this);
			_ = new _SoundChannel(this, sound, startTime, loops);
		}
	}

	/**
		Stops the sound playing in the channel.
	**/
	public function stop():Void
	{
		SoundMixer.__unregisterSoundChannel(this);

		if (_ == null) return;

		_.stop();
		__dispose();
	}

	@:noCompletion private function __dispose():Void
	{
		if (_ == null) return;

		_.dispose();
		_ = null;
	}

	@:noCompletion private function __onComplete():Void
	{
		SoundMixer.__unregisterSoundChannel(this);

		__dispose();
		dispatchEvent(new Event(Event.SOUND_COMPLETE));
	}

	@:noCompletion private function __updateTransform():Void
	{
		this.soundTransform = soundTransform;
	}

	// Get & Set Methods
	@:noCompletion private function get_position():Float
	{
		if (_ == null) return 0;

		return _.getPosition();
	}

	@:noCompletion private function set_position(value:Float):Float
	{
		if (_ == null) return 0;

		_.setPosition(value);
		return value;
	}

	@:noCompletion private function get_soundTransform():SoundTransform
	{
		return __soundTransform.clone();
	}

	@:noCompletion private function set_soundTransform(value:SoundTransform):SoundTransform
	{
		if (value != null)
		{
			__soundTransform.pan = value.pan;
			__soundTransform.volume = value.volume;

			if (_ != null)
			{
				_.setSoundTransform(value);
			}
		}

		return value;
	}
}
#else
typedef SoundChannel = flash.media.SoundChannel;
#end
