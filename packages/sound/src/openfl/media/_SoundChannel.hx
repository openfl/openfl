package openfl.media;

import lime.media.AudioSource;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events._EventDispatcher;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _SoundChannel extends _EventDispatcher
{
	public var leftPeak(default, null):Float;
	public var position(get, set):Float;
	public var rightPeak(default, null):Float;
	public var soundTransform(get, set):SoundTransform;

	public var source:AudioSource;

	private var __soundTransform:SoundTransform;

	private var soundChannel:SoundChannel;

	public function new(soundChannel:SoundChannel, sound:Sound = null, startTime:Float = 0, loops:Int = 0, soundTransform:SoundTransform = null):Void
	{
		this.soundChannel = soundChannel;

		super(soundChannel);

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
			_SoundMixer.__registerSoundChannel(soundChannel);
			var pan = _SoundMixer.__soundTransform.pan + __soundTransform.pan;

			if (pan > 1) pan = 1;
			if (pan < -1) pan = -1;

			var volume = _SoundMixer.__soundTransform.volume * __soundTransform.volume;

			source = new AudioSource(@:privateAccess (sound._ : _Sound).buffer);
			source.offset = Std.int(startTime);
			if (loops > 1) source.loops = loops - 1;

			source.gain = volume;

			var position = source.position;
			position.x = pan;
			position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
			source.position = position;

			source.onComplete.add(__onComplete);
			source.play();
		}
	}

	public function stop():Void
	{
		_SoundMixer.__unregisterSoundChannel(soundChannel);

		if (source != null)
		{
			source.stop();
		}

		__dispose();
	}

	private function __dispose():Void
	{
		if (source != null)
		{
			source.onComplete.remove(__onComplete);
			source.dispose();
			source = null;
		}
	}

	private function __onComplete():Void
	{
		_SoundMixer.__unregisterSoundChannel(soundChannel);

		__dispose();
		dispatchEvent(new Event(Event.SOUND_COMPLETE));
	}

	public function __updateTransform():Void
	{
		this.soundTransform = soundTransform;
	}

	// Get & Set Methods

	private function get_position():Float
	{
		if (source == null) return 0;

		return source.currentTime + source.offset;
	}

	private function set_position(value:Float):Float
	{
		if (source != null)
		{
			source.currentTime = Std.int(value < 0 ? 0 : value) - source.offset;
		}

		return value;
	}

	private function get_soundTransform():SoundTransform
	{
		return __soundTransform.clone();
	}

	private function set_soundTransform(value:SoundTransform):SoundTransform
	{
		if (value != null)
		{
			__soundTransform.pan = value.pan;
			__soundTransform.volume = value.volume;

			if (source != null)
			{
				var pan = _SoundMixer.__soundTransform.pan + value.pan;

				if (pan < -1) pan = -1;
				if (pan > 1) pan = 1;

				var volume = _SoundMixer.__soundTransform.volume * value.volume;

				source.gain = volume;
				var position = source.position;
				position.x = pan;
				position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
				source.position = position;
			}
		}

		return value;
	}
}
