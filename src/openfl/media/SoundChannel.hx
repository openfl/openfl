package openfl.media;

#if !flash
import openfl.events.Event;
import openfl.events.EventDispatcher;
#if lime
import openfl._internal.backend.lime.AudioSource;
#elseif openfl_html5
import openfl._internal.backend.howlerjs.Howl;
#end

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
@:access(openfl.media.Sound)
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

	@:noCompletion private var __isValid:Bool;
	@:noCompletion private var __soundTransform:SoundTransform;

	#if lime
	@:noCompletion private var __source:AudioSource;
	#elseif openfl_html5
	@:noCompletion private var __howlID:Int;
	@:noCompletion private var __srcHowl:Howl;
	#end

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

		if (soundTransform == null)
		{
			soundTransform = new SoundTransform();
		}
		else
		{
			soundTransform = soundTransform.clone();
		}

		if (sound != null)
		{
			SoundMixer.__registerSoundChannel(this);

			var pan = SoundMixer.__soundTransform.pan + soundTransform.pan;

			if (pan > 1) pan = 1;
			if (pan < -1) pan = -1;

			var volume = SoundMixer.__soundTransform.volume * soundTransform.volume;
			this.soundTransform = soundTransform;

			#if lime
			__source = new AudioSource(sound.__buffer);
			__source.offset = Std.int(startTime);
			if (loops > 1) __source.loops = loops - 1;

			__source.gain = volume;

			var position = __source.position;
			position.x = pan;
			position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
			__source.position = position;

			__source.onComplete.add(soundChannel_onComplete);
			__isValid = true;

			__source.play();
			#elseif openfl_html5
			__srcHowl = sound.__srcHowl;

			var cacheVolume = untyped __srcHowl._volume;
			untyped __srcHowl._volume = volume;

			__howlID = __srcHowl.play();

			untyped __srcHowl._volume = cacheVolume;

			if (__srcHowl.pos != null)
			{
				parent.buffer.__srcHowl.pos(pan, 0, -1 * Math.sqrt(1 - Math.pow(pan, 2)), __howlID);
				// There are more settings to the position of the sound on the "pannerAttr()" function of howler.
				// Maybe somebody who understands sound should look into it?
			}

			__srcHowl.on("end", soundChannel_onComplete, __howlID);

			if (startTime > 0)
			{
				__srcHowl.seek(startTime, __howlID);
			}
			#end
		}
		else
		{
			this.soundTransform = new SoundTransform();
		}
	}

	/**
		Stops the sound playing in the channel.
	**/
	public function stop():Void
	{
		SoundMixer.__unregisterSoundChannel(this);

		if (!__isValid) return;

		#if lime
		__source.stop();
		#elseif openfl_html5
		__srcHowl.stop(__howlID);
		#end
		__dispose();
	}

	@:noCompletion private function __dispose():Void
	{
		if (!__isValid) return;

		#if lime
		__source.onComplete.remove(soundChannel_onComplete);
		__source.dispose();
		__source = null;
		#elseif openfl_html5
		__srcHowl.off("end", sourceChannel_onComplete, __howlID);
		__srcHowl = null;
		#end
		__isValid = false;
	}

	@:noCompletion private function __updateTransform():Void
	{
		this.soundTransform = soundTransform;
	}

	// Get & Set Methods
	@:noCompletion private function get_position():Float
	{
		if (!__isValid) return 0;

		#if lime
		return __source.currentTime + __source.offset;
		#elseif openfl_html5
		return __srcHowl.seek(__howlID) * 1000;
		#else
		return 0;
		#end
	}

	@:noCompletion private function set_position(value:Float):Float
	{
		if (!__isValid) return 0;

		#if lime
		__source.currentTime = Std.int(value < 0 ? 0 : value) - __source.offset;
		#elseif openfl_html5
		__srcHowl.seek(value < 0 ? 0 : value, __howlID);
		#end
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

			var pan = SoundMixer.__soundTransform.pan + __soundTransform.pan;

			if (pan < -1) pan = -1;
			if (pan > 1) pan = 1;

			var volume = SoundMixer.__soundTransform.volume * __soundTransform.volume;

			if (__isValid)
			{
				#if lime
				__source.gain = volume;
				var position = __source.position;
				position.x = pan;
				position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
				__source.position = position;
				#elseif openfl_html5
				__srcHowl.volume(volume, __howlID);
				if (__srcHowl.pos != null)
				{
					__srcHowl.pos(pan, 0, -1 * Math.sqrt(1 - Math.pow(pan, 2)), __howlID);
				}
				#end
				return value;
			}
		}

		return value;
	}

	// Event Handlers
	@:noCompletion private function soundChannel_onComplete():Void
	{
		SoundMixer.__unregisterSoundChannel(this);

		__dispose();
		dispatchEvent(new Event(Event.SOUND_COMPLETE));
	}
}
#else
typedef SoundChannel = flash.media.SoundChannel;
#end
