package openfl.media;

#if !flash
import openfl.events.Event;
import openfl.events.EventDispatcher;
#if lime
import lime.media.AudioSource;
#end
#if (js && html5)
import openfl.events.SampleDataEvent;
import js.html.audio.AudioProcessingEvent;
import js.html.audio.ScriptProcessorNode;
#end
#if lime_openal
import openfl.events.SampleDataEvent;
import openfl.utils.ByteArray;
import lime.media.openal.ALBuffer;
import lime.media.openal.ALSource;
import lime.utils.ArrayBufferView;
import lime.utils.Int16Array;
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
@:access(openfl.events.SampleDataEvent)
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

	@:noCompletion private var __sound:Sound;
	@:noCompletion private var __isValid:Bool;
	@:noCompletion private var __soundTransform:SoundTransform;
	#if lime
	@:noCompletion private var __audioSource:AudioSource;
	#end

	#if (js && html5)
	private var __sampleDataEvent:SampleDataEvent;
	private var __processor:ScriptProcessorNode;
	private var __firstRun:Bool = true;
	#end

	#if lime_openal
	private var __sampleDataEvent:SampleDataEvent;
	private var __alSource:ALSource;
	private var __outputBuffer:ByteArray;
	private var __bufferView:ArrayBufferView;
	private var __alBuffers:Array<ALBuffer>;
	private var __numberOfBuffers:Int = 3;
	private var __emptyBuffers:Array<ALBuffer>;
	#end

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(SoundChannel.prototype, {
			"position": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_position (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_position (v); }")
			},
			"soundTransform": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_soundTransform (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_soundTransform (v); }")
			},
		});
	}
	#end

	@:noCompletion private function new(sound:Sound, audioSource:#if lime AudioSource #else Dynamic #end = null, soundTransform:SoundTransform = null):Void
	{
		super(this);

		__sound = sound;

		leftPeak = 1;
		rightPeak = 1;

		if (soundTransform != null)
		{
			__soundTransform = soundTransform;
		}
		else
		{
			__soundTransform = new SoundTransform();
		}

		__initAudioSource(audioSource);

		SoundMixer.__registerSoundChannel(this);
	}

	/**
		Stops the sound playing in the channel.
	**/
	public function stop():Void
	{
		SoundMixer.__unregisterSoundChannel(this);

		if (!__isValid) return;

		#if (js && html5)
		if (__processor != null)
		{
			__processor.disconnect();
			__processor.onaudioprocess = null;
			__processor = null;
		}
		#end

		#if lime_openal
		if (__alSource != null)
		{
			lime.app.Application.current.onUpdate.remove(watchBuffers);
			var alAudioContext = __sound.__alAudioContext;
			alAudioContext.sourceStop(__alSource);
			alAudioContext.deleteSource(__alSource);
			alAudioContext.deleteBuffers(__alBuffers);
			__emptyBuffers = null;
			__alSource = null;
		}
		#end

		#if lime
		__audioSource.stop();
		#end
		__dispose();
	}

	@:noCompletion private function __dispose():Void
	{
		if (!__isValid) return;

		#if lime
		__audioSource.onComplete.remove(audioSource_onComplete);
		__audioSource.dispose();
		__audioSource = null;
		#end
		__isValid = false;
	}

	@:noCompletion private function __startSampleData():Void
	{
		#if (js && html5)
		var webAudioContext = __sound.__webAudioContext;
		if (webAudioContext != null)
		{
			__sampleDataEvent = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
			__sound.dispatchEvent(__sampleDataEvent);
			var bufferSize = __sampleDataEvent.getBufferSize();
			if (bufferSize == 0)
			{
				// ensure that listeners can be added to the SoundChannel
				// before dispatching this event
				openfl.Lib.setTimeout(function():Void
				{
					stop();
					dispatchEvent(new Event(Event.SOUND_COMPLETE));
				}, 1);
			}
			else
			{
				__processor = webAudioContext.createScriptProcessor(bufferSize, 0, 2);
				__processor.connect(webAudioContext.destination);
				__processor.onaudioprocess = onSample;
				#if (haxe_ver >= 4.2)
				webAudioContext.resume();
				#else
				Reflect.callMethod(webAudioContext, Reflect.field(webAudioContext, "resume"), []);
				#end
			}
		}
		#end
		#if lime_openal
		var alAudioContext = __sound.__alAudioContext;
		if (alAudioContext != null)
		{
			__sampleDataEvent = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
			__sound.dispatchEvent(__sampleDataEvent);
			var bufferSize = __sampleDataEvent.getBufferSize();
			if (bufferSize == 0)
			{
				// ensure that listeners can be added to the SoundChannel
				// before dispatching this event
				openfl.Lib.setTimeout(function():Void
				{
					stop();
					dispatchEvent(new Event(Event.SOUND_COMPLETE));
				}, 1);
			}
			else
			{
				bufferSize = 0;
				__alSource = alAudioContext.createSource();
				alAudioContext.sourcef(__alSource, alAudioContext.GAIN, 1);
				alAudioContext.source3f(__alSource, alAudioContext.POSITION, 0, 0, 0);
				alAudioContext.sourcef(__alSource, alAudioContext.PITCH, 1.0);

				__alBuffers = alAudioContext.genBuffers(__numberOfBuffers);
				__outputBuffer = new ByteArray();
				__bufferView = new lime.utils.Int16Array(__outputBuffer);

				for (a in 0...__numberOfBuffers)
				{
					if (bufferSize == 0)
					{
						bufferSize = __sampleDataEvent.getBufferSize();
						__sampleDataEvent.getSamples(__outputBuffer);
						alAudioContext.bufferData(__alBuffers[a], alAudioContext.FORMAT_STEREO16, __bufferView, bufferSize * 4, 44100);
					}
					else
					{
						__sound.dispatchEvent(__sampleDataEvent);
						__sampleDataEvent.getSamples(__outputBuffer);
						alAudioContext.bufferData(__alBuffers[a], alAudioContext.FORMAT_STEREO16, __bufferView, bufferSize * 4, 44100);
					}
				}

				alAudioContext.sourceQueueBuffers(__alSource, __numberOfBuffers, __alBuffers);

				alAudioContext.sourcePlay(__alSource);
				lime.app.Application.current.onUpdate.add(watchBuffers);
			}
		}
		#end
	}

	@:noCompletion private function __updateTransform():Void
	{
		this.soundTransform = soundTransform;
	}

	@:noCompletion private function __initAudioSource(audioSource:#if lime AudioSource #else Dynamic #end):Void
	{
		#if lime
		__audioSource = audioSource;
		if (__audioSource == null)
		{
			return;
		}

		__audioSource.onComplete.add(audioSource_onComplete);
		__isValid = true;

		__audioSource.play();
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_position():Float
	{
		if (!__isValid) return 0;

		#if lime
		return __audioSource.currentTime + __audioSource.offset;
		#else
		return 0;
		#end
	}

	@:noCompletion private function set_position(value:Float):Float
	{
		if (!__isValid) return 0;

		#if lime
		__audioSource.currentTime = Std.int(value) - __audioSource.offset;
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
				__audioSource.gain = volume;

				var position = __audioSource.position;
				position.x = pan;
				position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
				__audioSource.position = position;

				return value;
				#end
			}
		}

		return value;
	}

	// Event Handlers
	@:noCompletion private function audioSource_onComplete():Void
	{
		SoundMixer.__unregisterSoundChannel(this);

		__dispose();
		dispatchEvent(new Event(Event.SOUND_COMPLETE));
	}

	#if (js && html5)
	private function onSample(event:AudioProcessingEvent):Void
	{
		var hasSampleData = false;
		if (__firstRun)
		{
			hasSampleData = true;
			__firstRun = false;
		}
		else
		{
			__sampleDataEvent.data.length = 0;
			__sound.dispatchEvent(__sampleDataEvent);
			hasSampleData = __sampleDataEvent.data.length > 0;
		}
		if (hasSampleData)
		{
			__sampleDataEvent.getSamples(event);
		}
		else
		{
			stop();
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
	}
	#end

	#if lime_openal
	private function watchBuffers(i:Int):Void
	{
		var alAudioContext = __sound.__alAudioContext;
		var hasSampleData = true;

		if (alAudioContext != null)
		{
			var bufferState = alAudioContext.getSourcei(__alSource, alAudioContext.BUFFERS_PROCESSED);
			if (bufferState > 0)
			{
				__emptyBuffers = alAudioContext.sourceUnqueueBuffers(__alSource, bufferState);
				for (a in 0...__emptyBuffers.length)
				{
					__sampleDataEvent.data.length = 0;
					__sound.dispatchEvent(__sampleDataEvent);
					if (__sampleDataEvent.data.length == 0)
					{
						hasSampleData = false;
					}
					else
					{
						__sampleDataEvent.getSamples(__outputBuffer);
						alAudioContext.bufferData(__emptyBuffers[a], alAudioContext.FORMAT_STEREO16, __bufferView, __sampleDataEvent.getBufferSize() * 4,
							44100);
						alAudioContext.sourceQueueBuffer(__alSource, __emptyBuffers[a]);
					}
				}

				if (hasSampleData && alAudioContext.getSourcei(__alSource, alAudioContext.SOURCE_STATE) != alAudioContext.PLAYING)
				{
					alAudioContext.sourcePlay(__alSource);
				}
			}
		}
		if (!hasSampleData)
		{
			stop();
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
	}
	#end
}
#else
typedef SoundChannel = flash.media.SoundChannel;
#end
