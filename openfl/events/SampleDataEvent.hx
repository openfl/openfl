package openfl.events;



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

class SampleDataEvent extends Event {
	
	
	public static inline var SAMPLE_DATA = "sampleData";
	
	public var data:ByteArray;
	public var position:Float;
	
	
	#if (js && html5)	
		private var tempBuffer:Float32Array;
		private var leftChannel:js.html.Float32Array;
		private var rightChannel:js.html.Float32Array;
	#end	
	#if lime_openal
		private var leftChannel:Int;
		private var rightChannel:Int;
	#end
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false) {
		
		super (type, bubbles, cancelable);
		
		data = new ByteArray ();
		data.endian = Endian.LITTLE_ENDIAN;
		position = 0.0;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new SampleDataEvent (type, bubbles, cancelable);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("SampleDataEvent",  [ "type", "bubbles", "cancelable" ]);
		
	}
	
	
#if lime_openal
	private function getBufferSize():Int {
		var bufferSize:Int = Std.int(data.length / 4 / 2);
			if (bufferSize >= 2048 && bufferSize <= 8192) {
				return bufferSize;
			} else {
				throw new Error("To be consistent with flash the listener function registered to SampleDataEvent has to provide between 2048 and 8192 samples.");
			}		
		return bufferSize;
	}	
	
	private function getSamples(outputBuffer:ByteArray):Void {
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
	private function getBufferSize():Int {
		var bufferSize:Int = Std.int(data.length/4/2);
		if (bufferSize > 0) {
			if ((bufferSize != 0) && ((bufferSize & (bufferSize - 1)) == 0) && bufferSize >= 2048 && bufferSize <= 8192) {
				tempBuffer = new haxe.io.Float32Array(bufferSize * 2);
				return bufferSize;
			} else {
				throw new Error("To be consistent with flash the listener function registered to SampleDataEvent has to provide 2048, 4096 or 8192 samples if targeting HTML5.");
			}
		}
		return 0;
	}

private function getSamples(event:js.html.audio.AudioProcessingEvent):Void {
		data.position = 0;
		tempBuffer=Float32Array.fromBytes(data);

		leftChannel = event.outputBuffer.getChannelData(0);
		rightChannel = event.outputBuffer.getChannelData(1);
		var pos:Int = 0;
		var bufferLength:Int = Std.int(data.length / 2);
		for (i in 0...bufferLength) {
			leftChannel[i] = tempBuffer[pos++];
			rightChannel[i] = tempBuffer[pos++];
		}		
	}
	#end	
}