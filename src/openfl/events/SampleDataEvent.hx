package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
#if (js && html5)
import js.html.audio.AudioProcessingEvent;
import haxe.io.Float32Array;
import js.html.audio.AudioBuffer;
import openfl.errors.Error;
#end
#if lime_openal
import openfl.errors.Error;
import haxe.io.Bytes;
#end

/**
	Dispatched when a Sound object requests new audio data or when a
	Microphone object has new audio data to provide.
	This event has two uses:

	* To provide dynamically generated audio data for a Sound object
	* To get audio data for a Microphone object

	**Dynamically generating audio using the Sound object** Use the
	`sampleData` event to play dynamically generated audio. In this
	environment, the Sound object doesn't actually contain sound data.
	Instead, it acts as a socket for sound data that is being streamed to it
	through the use of the function you assign as the handler for the
	`sampleData` event.

	In your function, you use the `ByteArray.writeFloat()` method to write to
	the event's `data`) property, which contains the sampled data you want to
	play.

	If a Sound object has not loaded an MP3 file, when you call its `play()`
	method the object starts dispatching `sampleData` events, requesting sound
	samples. The Sound object continues to send events as the sound plays back
	until you stop providing data, or until the `stop()` method of the
	SoundChannel object is called.

	Thes latency of the event varies from platform to platform, and it could
	change in future versions of Flash Player or AIR. Don't depend on a
	specific latency. Instead calculate it using
	`((SampleDataEvent.position/44.1) - SoundChannelObject.position)`.

	Provide between 2048 and 8192 samples to the `data` property of the
	SampleDataEvent object. For best performance, provide as many samples as
	possible. The fewer samples you provide, the more likely it is that clicks
	and pops will occur during playback. This behavior can differ on various
	platforms and can occur in various situations - for example, when resizing
	the browser. You might write code that works on one platform when you
	provide only 2048 samples, but that same code might not work as well when
	run on a different platform. If you require the lowest latency possible,
	consider making the amount of data user-selectable.

	If you provide fewer than 2048 samples, tha Sound object plays the
	remaining samples and then stops the sound as if the end of a sound file
	was reached, generating a `complete` event.

	You can use the `extract()` method of a Sound object to extract its sound
	data, which you can then write to the dynamic stream for playback.

	When you use the `sampleData` event with a Sound object, the only Sound
	methods that are enabled are `extract()` and `play()`. Calling any other
	methods or properties results in an "invalid call" exception. All methods
	and properties of the SoundChannel object are still enabled.

	**Capturing Microphone audio** Use the `sampleData` event to capture audio
	data from a microphone. When you add an event listener for the
	`sampleData` event, the Microphone dispatches the event as audio samples
	become available.

	In the event handler function, use the `ByteArray.readFloat()` method to
	read the event's `data`) property, which contains the sampled data. The
	event will contain multiple samples, so you should use a `while` loop to
	read the available data:

	```haxe
	var soundBytes = new ByteArray();
	while(event.data.bytesAvailable) {
		var sample = event.data.readFloat();
		soundBytes.writeFloat(sample);
	}
	```
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class SampleDataEvent extends Event
{
	/**
		Defines the value of the `type` property of a `SampleDataEvent` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `position` | The point from which audio data is provided. |
	**/
	public static inline var SAMPLE_DATA:EventType<SampleDataEvent> = "sampleData";

	// using @:keep on data/position vars because Haxe removes them with
	// dce full on some targets (at least cpp and hl), but doesn't remove the
	// code in the constructor that sets them

	/**
		The data in the audio stream.
	**/
	@:keep public var data:ByteArray;

	/**
		The position of the data in the audio stream.
	**/
	@:keep public var position:Float;

	// @:noCompletion private static var __pool:ObjectPool<SampleDataEvent> = new ObjectPool<SampleDataEvent>(function() return new SampleDataEvent(null),
	// function(event) event.__init());
	/**
		Creates an event object that contains information about audio data
		events. Event objects are passed as parameters to event listeners.

		@param type        The type of the event. This value
						   is:`Event.SAMPLE_DATA`.
		@param bubbles     Determines whether the Event object participates in
						   the bubbling stage of the event flow.
		@param cancelable  Determines whether the Event object can be
						   canceled.
		@param theposition The position of the data in the audio stream.
		@param thedata     A byte array of data.
	**/
	#if (js && html5)
	private var tempBuffer:Float32Array;
	private var leftChannel:#if haxe4 js.lib.Float32Array #else js.html.Float32Array #end;
	private var rightChannel:#if haxe4 js.lib.Float32Array #else js.html.Float32Array #end;
	#end
	#if lime_openal
	private var leftChannel:Int;
	private var rightChannel:Int;
	#end

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);

		data = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		position = 0.0;
	}

	public override function clone():SampleDataEvent
	{
		var event = new SampleDataEvent(type, bubbles, cancelable);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		event.data = data;
		event.position = position;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("SampleDataEvent", ["type", "bubbles", "cancelable"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		data = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		position = 0.0;
	}

	#if lime_openal
	private function getBufferSize():Int
	{
		var bufferSize:Int = Std.int(data.length / 4 / 2);
		if (bufferSize >= 2048 && bufferSize <= 8192)
		{
			return bufferSize;
		}
		else
		{
			throw new Error("To be consistent with flash the listener function registered to SampleDataEvent has to provide between 2048 and 8192 samples.");
		}
		return bufferSize;
	}

	private function getSamples(outputBuffer:ByteArray):Void
	{
		var bytesLength:Int = data.length;
		var tempFloat:Float;
		data.position = 0;
		outputBuffer.position = 0;
		while (data.position < bytesLength)
		{
			tempFloat = data.readFloat();
			leftChannel = Std.int(tempFloat * 32768);
			outputBuffer.writeShort(leftChannel);
			tempFloat = data.readFloat();
			rightChannel = Std.int(tempFloat * 32768);
			outputBuffer.writeShort(rightChannel);
		}

		data.position = 0;
	}
	#end

	#if (js && html5)
	private function getBufferSize():Int
	{
		var bufferSize:Int = Std.int(data.length / 4 / 2);
		if (bufferSize > 0)
		{
			if ((bufferSize != 0) && ((bufferSize & (bufferSize - 1)) == 0) && bufferSize >= 2048 && bufferSize <= 8192)
			{
				tempBuffer = new haxe.io.Float32Array(bufferSize * 2);
				return bufferSize;
			}
			else
			{
				throw new Error("To be consistent with flash the listener function registered to SampleDataEvent has to provide 2048, 4096 or 8192 samples if targeting HTML5.");
			}
		}
		return 0;
	}

	private function getSamples(event:js.html.audio.AudioProcessingEvent):Void
	{
		data.position = 0;
		tempBuffer = Float32Array.fromBytes(data);
		leftChannel = event.outputBuffer.getChannelData(0);
		rightChannel = event.outputBuffer.getChannelData(1);
		var pos:Int = 0;
		var bufferLength:Int = Std.int(data.length / 2);
		for (i in 0...bufferLength)
		{
			leftChannel[i] = tempBuffer[pos++];
			rightChannel[i] = tempBuffer[pos++];
		}
	}
	#end
}
#else
typedef SampleDataEvent = flash.events.SampleDataEvent;
#end
