import * as internal from "../_internal/utils/InternalAccess";
import Event from "../events/Event";
import EventDispatcher from "../events/EventDispatcher";
import Sound from "../media/Sound";
import SoundMixer from "../media/SoundMixer";
import SoundTransform from "../media/SoundTransform";

/**
	The SoundChannel class controls a sound in an application. Every sound is
	assigned to a sound channel, and the application can have multiple sound
	channels that are mixed together. The SoundChannel class contains a
	`stop()` method, properties for monitoring the amplitude
	(volume) of the channel, and a property for assigning a SoundTransform
	object to the channel.

	@event soundComplete Dispatched when a sound has finished playing.
**/
export default class SoundChannel extends EventDispatcher
{
	/**
		The current amplitude(volume) of the left channel, from 0(silent) to 1
		(full amplitude).
	**/
	public readonly leftPeak: number;

	/**
		The current amplitude(volume) of the right channel, from 0(silent) to 1
		(full amplitude).
	**/
	public readonly rightPeak: number;

	protected __soundTransform: SoundTransform;

	protected constructor(sound: Sound = null, startTime: number = 0, loops: number = 0, soundTransform: SoundTransform = null)
	{
		super();

		this.leftPeak = 1;
		this.rightPeak = 1;

		if (soundTransform != null)
		{
			this.__soundTransform = soundTransform.clone();
		}
		else
		{
			this.__soundTransform = new SoundTransform();
		}

		if (sound != null)
		{
			(<internal.SoundMixer><any>SoundMixer).__registerSoundChannel(this);
			// __backend = new SoundChannelBackend(this, sound, startTime, loops);
		}
	}

	/**
		Stops the sound playing in the channel.
	**/
	public stop(): void
	{
		(<internal.SoundMixer><any>SoundMixer).__unregisterSoundChannel(this);

		// if (__backend == null) return;

		// __backend.stop();
		this.__dispose();
	}

	protected __dispose(): void
	{
		// if (__backend == null) return;

		// __backend.dispose();
		// __backend = null;
	}

	protected __onComplete(): void
	{
		(<internal.SoundMixer><any>SoundMixer).__unregisterSoundChannel(this);

		this.__dispose();
		this.dispatchEvent(new Event(Event.SOUND_COMPLETE));
	}

	protected __updateTransform(): void
	{
		this.soundTransform = this.soundTransform;
	}

	// Get & Set Methods

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
	public get position(): number
	{
		// if (__backend == null) return 0;

		// return __backend.getPosition();
		return 0;
	}

	public set position(value: number)
	{
		// if (__backend == null) return 0;

		// __backend.setPosition(value);
	}

	/**
		The SoundTransform object assigned to the sound channel. A SoundTransform
		object includes properties for setting volume, panning, left speaker
		assignment, and right speaker assignment.
	**/
	public get soundTransform(): SoundTransform
	{
		return this.__soundTransform.clone();
	}

	public set soundTransform(value: SoundTransform)
	{
		if (value != null)
		{
			this.__soundTransform.pan = value.pan;
			this.__soundTransform.volume = value.volume;

			// if (__backend != null)
			// {
			// 	__backend.setSoundTransform(value);
			// }
		}
	}
}
