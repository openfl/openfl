package openfl.media;

import haxe.Int64;
import lime.media.AudioBuffer;
import lime.utils.UInt8Array;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events._EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.media.ID3Info;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundLoaderContext;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import openfl.utils.Future;
import openfl.events.EventDispatcher;
import openfl.events.IOErrorEvent;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import openfl.utils.Future;
#if lime
import lime.media.AudioBuffer;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class _Sound extends _EventDispatcher
{
	public var bytesLoaded(default, null):Int;
	public var bytesTotal(default, null):Int;
	public var id3(get, never):ID3Info;
	public var isBuffering(default, null):Bool;
	public var length(get, never):Float;
	public var url(default, null):String;

	public var buffer:AudioBuffer;

	private var sound:Sound;

	public function new(sound:Sound, stream:URLRequest = null, context:SoundLoaderContext = null)
	{
		this.sound = sound;

		super(sound);

		bytesLoaded = 0;
		bytesTotal = 0;
		isBuffering = false;
		url = null;

		if (stream != null)
		{
			load(stream, context);
		}
	}

	public function close():Void
	{
		if (buffer != null)
		{
			buffer.dispose();
			buffer = null;
		}
	}

	#if lime
	@:dox(hide) public static function fromAudioBuffer(buffer:AudioBuffer):Sound
	{
		var sound = new Sound();
		(sound._ : _Sound).buffer = buffer;
		return sound;
	}
	#end

	public static function fromFile(path:String):Sound
	{
		if (path == null) return null;

		return fromAudioBuffer(AudioBuffer.fromFile(path));
	}

	public function load(stream:URLRequest, context:SoundLoaderContext = null):Void
	{
		url = stream.url;
		if (url != null)
		{
			#if openfl_html5
			var defaultLibrary = Assets.getLibrary("default"); // TODO: Improve this

			if (defaultLibrary != null && defaultLibrary.cachedAudioBuffers.exists(url))
			{
				AudioBuffer_onURLLoad(defaultLibrary.cachedAudioBuffers.get(url));
			}
			else
			{
				AudioBuffer.loadFromFile(url).onComplete(AudioBuffer_onURLLoad).onError(function(_)
				{
					AudioBuffer_onURLLoad(null);
				});
			}
			#else
			AudioBuffer.loadFromFile(url).onComplete(AudioBuffer_onURLLoad).onError(function(_)
			{
				AudioBuffer_onURLLoad(null);
			});
			#end
		}
		else
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
	}

	public function loadCompressedDataFromByteArray(bytes:ByteArray, bytesLength:Int):Void
	{
		if (bytes == null || bytesLength <= 0)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			return;
		}

		if (bytes.position > 0 || bytes.length > bytesLength)
		{
			var copy = new ByteArray(bytesLength);
			copy.writeBytes(bytes, bytes.position, bytesLength);
			bytes = copy;
		}

		buffer = AudioBuffer.fromBytes(bytes);

		if (buffer == null)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		else
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	public static function loadFromFile(path:String):Future<Sound>
	{
		return AudioBuffer.loadFromFile(path).then(function(audioBuffer)
		{
			return Future.withValue(fromAudioBuffer(audioBuffer));
		});
	}

	public static function loadFromFiles(paths:Array<String>):Future<Sound>
	{
		if (paths == null) return cast Future.withError("");

		return AudioBuffer.loadFromFiles(paths).then(function(audioBuffer)
		{
			return Future.withValue(fromAudioBuffer(audioBuffer));
		});
	}

	public function loadPCMFromByteArray(bytes:ByteArray, samples:Int, format:String = "float", stereo:Bool = true, sampleRate:Float = 44100):Void
	{
		if (bytes == null)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			return;
		}

		var bitsPerSample = (format == "float" ? 32 : 16); // "short"
		var channels = (stereo ? 2 : 1);
		var bytesLength = Std.int(samples * channels * (bitsPerSample / 8));

		if (bytes.position > 0 || bytes.length > bytesLength)
		{
			var copy = new ByteArray(bytesLength);
			copy.writeBytes(bytes, bytes.position, bytesLength);
			bytes = copy;
		}

		var audioBuffer = new AudioBuffer();
		audioBuffer.bitsPerSample = bitsPerSample;
		audioBuffer.channels = channels;
		audioBuffer.data = new UInt8Array(bytes);
		audioBuffer.sampleRate = Std.int(sampleRate);

		buffer = audioBuffer;

		dispatchEvent(new Event(Event.COMPLETE));
	}

	public function play(startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel
	{
		if (buffer == null) return null;

		if (_SoundMixer.__soundChannels.length >= _SoundMixer.MAX_ACTIVE_CHANNELS)
		{
			return null;
		}

		return new SoundChannel(this.sound, startTime, loops, sndTransform);
	}

	// Event Handlers

	private function AudioBuffer_onURLLoad(buffer:AudioBuffer):Void
	{
		if (buffer == null)
		{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		else
		{
			this.buffer = buffer;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	// Get & Set Methods

	private function get_id3():ID3Info
	{
		return new ID3Info();
	}

	private function get_length():Int
	{
		if (buffer != null)
		{
			#if (openfl_html5 && howlerjs)
			return Std.int(buffer.src.duration() * 1000);
			#else
			if (buffer.data != null)
			{
				var samples = (buffer.data.length * 8) / (buffer.channels * buffer.bitsPerSample);
				return Std.int(samples / buffer.sampleRate * 1000);
			}
			else if (@:privateAccess buffer.__srcVorbisFile != null)
			{
				var samples = Int64.toInt(@:privateAccess buffer.__srcVorbisFile.pcmTotal());
				return Std.int(samples / buffer.sampleRate * 1000);
			}
			else
			{
				return 0;
			}
			#end
		}

		return 0;
	}
}
