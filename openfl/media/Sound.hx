package openfl.media;


import haxe.io.Path;
import lime.app.Future;
import lime.app.Preloader;
import lime.media.AudioBuffer;
import lime.media.AudioSource;
import lime.utils.UInt8Array;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;

#if (js && html5)
	import lime.media.AudioManager;	
	import lime.media.WebAudioContext;
	import openfl.events.SampleDataEvent;
#end
#if lime_openal
	import lime.media.openal.ALBuffer;
	import lime.media.openal.ALSource;
	import lime.media.AudioManager;		
	import lime.media.ALAudioContext;
	import lime.media.ALCAudioContext;
	import openfl.events.SampleDataEvent;
	import lime.utils.ArrayBufferView;
	import lime.utils.Int16Array;	
#end
@:access(lime.utils.AssetLibrary)
@:access(openfl.media.SoundMixer)

@:autoBuild(openfl._internal.macros.AssetsMacro.embedSound())


class Sound extends EventDispatcher {
	
	
	public var bytesLoaded (default, null):Int;
	public var bytesTotal (default, null):Int;
	public var id3 (get, never):ID3Info;
	public var isBuffering (default, null):Bool;
	public var length (get, never):Float;
	public var url (default, null):String;
	
	private var __buffer:AudioBuffer;
	
	#if (js && html5)
		public var sampleRate(get, never):Int;
		private var __audioContext:WebAudioContext=null;
		private var __processor:js.html.audio.ScriptProcessorNode;
		private var __sampleData:SampleDataEvent;
		private var __firstRun:Bool = true;
	#end	
	#if lime_openal
		public var sampleRate(get, never):Int;
		private var __ALCAudioContext:ALCAudioContext=null;
		private var __ALAudioContext:ALAudioContext=null;
		private var __sampleData:SampleDataEvent;
		private var __source:ALSource;
		private var __outputBuffer:ByteArray;
		private var __bufferView:ArrayBufferView;
		private var __buffers:Array<ALBuffer>;
		private var __numberOFBuffers:Int=3;
		private var __listenerRemoved:Bool = false;
		private var __emptyBuffers:Array<ALBuffer>;
	#end
	
	public function new (stream:URLRequest = null, context:SoundLoaderContext = null) {
		
		super (this);
		
		bytesLoaded = 0;
		bytesTotal = 0;
		isBuffering = false;
		url = null;
		
		if (stream != null) {
			
			load (stream, context);
			
		}
		
		#if (js && html5)
			if (stream == null) {
				switch(AudioManager.context) {
					case WEB (context):
						__audioContext = context;
						default:
				}
			}
		#end
		#if lime_openal
			if (stream == null) {
				switch(AudioManager.context) {
					case OPENAL (alc, al):
						__ALCAudioContext = alc;
						__ALAudioContext = al;
						default:
				}
			}
		#end		
	}
	
	
	public function close ():Void {
		
		if (__buffer != null) {
			
			__buffer.dispose ();
			
		}
		
	}
	
	
	public static function fromAudioBuffer (buffer:AudioBuffer):Sound {
		
		var sound = new Sound ();
		sound.__buffer = buffer;
		return sound;
		
	}
	
	
	public static function fromFile (path:String):Sound {
		
		return fromAudioBuffer (AudioBuffer.fromFile (path));
		
	}
	
	
	public function load (stream:URLRequest, context:SoundLoaderContext = null):Void {
		
		url = stream.url;
		
		#if (js && html5)
		
		var defaultLibrary = lime.utils.Assets.getLibrary ("default"); // TODO: Improve this
		
		if (defaultLibrary != null && defaultLibrary.cachedAudioBuffers.exists (url)) {
			
			AudioBuffer_onURLLoad (defaultLibrary.cachedAudioBuffers.get (url));
			
		} else {
			
			AudioBuffer.loadFromFile (url).onComplete (AudioBuffer_onURLLoad).onError (function (_) AudioBuffer_onURLLoad (null));
			
		}
		
		#else
		
		AudioBuffer.loadFromFile (url).onComplete (AudioBuffer_onURLLoad).onError (function (_) AudioBuffer_onURLLoad (null));
		
		#end
		
	}
	
	
	public function loadCompressedDataFromByteArray (bytes:ByteArray, bytesLength:Int):Void {
		
		if (bytes == null || bytesLength <= 0) {
			
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			return;
			
		}
		
		if (bytes.length > bytesLength) {
			
			var copy = new ByteArray (bytesLength);
			copy.writeBytes (bytes, 0, bytesLength);
			bytes = copy;
			
		}
		
		__buffer = AudioBuffer.fromBytes (bytes);
		
		if (__buffer == null) {
			
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			
		} else {
			
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	
	public static function loadFromFile (path:String):Future<Sound> {
		
		return AudioBuffer.loadFromFile (path).then (function (audioBuffer) {
			
			return Future.withValue (fromAudioBuffer (audioBuffer));
			
		});
		
	}
	
	
	public function loadPCMFromByteArray (bytes:ByteArray, samples:Int, format:String = "float", stereo:Bool = true, sampleRate:Float = 44100):Void {
		
		if (bytes == null) {
			
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			return;
			
		}
		
		var audioBuffer = new AudioBuffer ();
		audioBuffer.bitsPerSample = format == "float" ? 32 : 16; // "short"
		audioBuffer.channels = stereo ? 2 : 1;
		audioBuffer.data = new UInt8Array (bytes);
		audioBuffer.sampleRate = Std.int (sampleRate);
		
		__buffer = audioBuffer;
		
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	public function play (startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel {
		
		if (SoundMixer.__soundChannels.length >= SoundMixer.MAX_ACTIVE_CHANNELS) {
			
			return null;
			
		}
		
		if (sndTransform == null) {
			
			sndTransform = new SoundTransform ();
			
		} else {
			
			sndTransform = sndTransform.clone ();
			
		}
		
		var pan = SoundMixer.__soundTransform.pan + sndTransform.pan;
		
		if (pan > 1) pan = 1;
		if (pan < -1) pan = -1;
		
		var volume = SoundMixer.__soundTransform.volume * sndTransform.volume;
		
		var source = new AudioSource (__buffer);
		
		source.offset = Std.int (startTime);
	
		if (loops > 1) source.loops = loops - 1;
		
		source.gain = volume;
		
		var position = source.position;
		position.x = pan;
		position.z = -1 * Math.sqrt (1 - Math.pow (pan, 2));
		source.position = position;
		
		#if (js && html5)
			if (__audioContext != null && __buffer == null) {
				__sampleData = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
				dispatchEvent(__sampleData);
				__processor = __audioContext.createScriptProcessor(@:privateAccess __sampleData.getBufferSize(), 0, 2);
				__processor.connect(__audioContext.destination);
				__processor.onaudioprocess = onSample;				
			}
		#end
		#if lime_openal
			if (__ALCAudioContext != null && __buffer == null) {
				__listenerRemoved = false;
				__sampleData = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
				dispatchEvent(__sampleData);
				var bufferSize:Int = 0;
				__source = __ALAudioContext.createSource();
				__ALAudioContext.sourcef(__source, __ALAudioContext.GAIN, 1);
				__ALAudioContext.source3f(__source, __ALAudioContext.POSITION, 0, 0, 0);
				__ALAudioContext.sourcef(__source,__ALAudioContext.PITCH,1.0);
				
				__buffers = __ALAudioContext.genBuffers(__numberOFBuffers);
				__outputBuffer = new ByteArray();
				__bufferView = new lime.utils.Int16Array(__outputBuffer);
				
				for (a in 0...__numberOFBuffers) {
					if (bufferSize == 0) {
						bufferSize = @:privateAccess __sampleData.getBufferSize();
						@:privateAccess __sampleData.getSamples(__outputBuffer);
						__ALAudioContext.bufferData(__buffers[a], __ALAudioContext.FORMAT_STEREO16, __bufferView, bufferSize * 4, 44100);						
					} else {
						dispatchEvent(__sampleData);
						@:privateAccess __sampleData.getSamples(__outputBuffer);
						__ALAudioContext.bufferData(__buffers[a], __ALAudioContext.FORMAT_STEREO16, __bufferView, bufferSize * 4, 44100);						
					}
				}

				__ALAudioContext.sourceQueueBuffers(__source, __numberOFBuffers, __buffers);

				__ALAudioContext.sourcePlay(__source);
				lime.app.Application.current.onUpdate.add(watchBuffers);

			}		
		#end
		return new SoundChannel (source, sndTransform);
		
	}
	
	
	#if (js && html5)	
	private function onSample(event:js.html.audio.AudioProcessingEvent):Void {
		if(__firstRun) {
			__firstRun = false;
		} else {
				dispatchEvent(__sampleData);
				}
		@:privateAccess __sampleData.getSamples(event);
	}
	
	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		super.removeEventListener(type, listener, useCapture);	
		if (type == SampleDataEvent.SAMPLE_DATA && __processor != null) {
			__processor.disconnect();
			__processor.onaudioprocess = null;
			__processor = null;
		}
	}
	
	private function get_sampleRate ():Int {
		return Std.int(__audioContext.sampleRate);
	}	
	#end
	#if lime_openal
	private function watchBuffers(i:Int):Void
	{
		var bufferState = __ALAudioContext.getSourcei(__source, __ALAudioContext.BUFFERS_PROCESSED);

		if(bufferState > 0) {
			__emptyBuffers = __ALAudioContext.sourceUnqueueBuffers(__source, bufferState);
			for (a in 0...__emptyBuffers.length) {
				dispatchEvent(__sampleData);
				@:privateAccess __sampleData.getSamples(__outputBuffer);
				__ALAudioContext.bufferData(__emptyBuffers[a], __ALAudioContext.FORMAT_STEREO16, __bufferView, @:privateAccess __sampleData.getBufferSize() * 4, 44100);
				__ALAudioContext.sourceQueueBuffer(__source,  __emptyBuffers[a]);	
			}
			
			if (__ALAudioContext.getSourcei(__source, __ALAudioContext.SOURCE_STATE) != __ALAudioContext.PLAYING) {
				__ALAudioContext.sourcePlay(__source);
			}
		}	
		if (__listenerRemoved) {
			lime.app.Application.current.onUpdate.remove(watchBuffers);
			__ALAudioContext.sourceStop((__source));
			__ALAudioContext.deleteSource(__source);
			__ALAudioContext.deleteBuffers(__buffers);
			__ALAudioContext = null;
			__ALCAudioContext = null;
			__emptyBuffers = null;
			__source = null;
			__buffer = null;
		}
	}
	
	private function get_sampleRate ():Int {
		return 44100;
	}	
	
	override public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void {
		super.removeEventListener(type, listener, useCapture);	
		if (type == SampleDataEvent.SAMPLE_DATA && __ALAudioContext != null) {
			__listenerRemoved = true;
		}
	}	
	#end	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_id3 ():ID3Info {
		
		return new ID3Info ();
		
	}
	
	
	private function get_length ():Int {
		
		if (__buffer != null) {
			
			#if (js && html5 && howlerjs)
			
			return Std.int(__buffer.src.duration() * 1000);
			
			#else
			
			var samples = (__buffer.data.length * 8) / (__buffer.channels * __buffer.bitsPerSample);
			return Std.int (samples / __buffer.sampleRate * 1000);
			
			#end
			
		}
		
		return 0;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function AudioBuffer_onURLLoad (buffer:AudioBuffer):Void {
		
		if (buffer == null) {
			
			dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
			
		} else {
			
			__buffer = buffer;
			
			dispatchEvent (new Event (Event.COMPLETE));
			
		}
		
	}
	
	
}