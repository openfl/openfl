import Event from "openfl/events/Event";
import EventDispatcher from "openfl/events/EventDispatcher";

namespace openfl.media
{
	/**
		The SoundChannel class controls a sound in an application. Every sound is
		assigned to a sound channel, and the application can have multiple sound
		channels that are mixed together. The SoundChannel class contains a
		`stop()` method, properties for monitoring the amplitude
		(volume) of the channel, and a property for assigning a SoundTransform
		object to the channel.

		@event soundComplete Dispatched when a sound has finished playing.
	**/
	export class SoundChannel extends EventDispatcher
	{
		/**
			The current amplitude(volume) of the left channel, from 0(silent) to 1
			(full amplitude).
		**/
		public leftPeak(default , null): number;

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
		public position(get, set): number;

		/**
			The current amplitude(volume) of the right channel, from 0(silent) to 1
			(full amplitude).
		**/
		public rightPeak(default , null): number;

		/**
			The SoundTransform object assigned to the sound channel. A SoundTransform
			object includes properties for setting volume, panning, left speaker
			assignment, and right speaker assignment.
		**/
		public soundTransform(get, set): SoundTransform;

		protected __backend: SoundChannelBackend;
		protected __soundTransform: SoundTransform;

		protected constructor(sound: Sound = null, startTime: number = 0, loops: number = 0, soundTransform: SoundTransform = null): void
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
				__backend = new SoundChannelBackend(this, sound, startTime, loops);
			}
		}

		/**
			Stops the sound playing in the channel.
		**/
		public stop(): void
		{
			SoundMixer.__unregisterSoundChannel(this);

			if (__backend == null) return;

			__backend.stop();
			__dispose();
		}

		protected __dispose(): void
		{
			if (__backend == null) return;

			__backend.dispose();
			__backend = null;
		}

		protected __onComplete(): void
		{
			SoundMixer.__unregisterSoundChannel(this);

			__dispose();
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}

		protected __updateTransform(): void
		{
			this.soundTransform = soundTransform;
		}

		// Get & Set Methods
		protected get_position(): number
		{
			if (__backend == null) return 0;

			return __backend.getPosition();
		}

		protected set_position(value: number): number
		{
			if (__backend == null) return 0;

			__backend.setPosition(value);
			return value;
		}

		protected get_soundTransform(): SoundTransform
		{
			return __soundTransform.clone();
		}

		protected set_soundTransform(value: SoundTransform): SoundTransform
		{
			if (value != null)
			{
				__soundTransform.pan = value.pan;
				__soundTransform.volume = value.volume;

				if (__backend != null)
				{
					__backend.setSoundTransform(value);
				}
			}

			return value;
		}
	}
}

export default openfl.media.SoundChannel;
