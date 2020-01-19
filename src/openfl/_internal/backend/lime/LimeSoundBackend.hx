package openfl._internal.backend.lime;

#if lime
import haxe.Int64;
import lime.media.AudioBuffer;
import lime.utils.UInt8Array;
import lime.utils.Assets;
import openfl.events.Event;
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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.media.AudioBuffer)
@:access(lime.utils.AssetLibrary)
@:access(openfl.media.Sound)
@:access(openfl.media.SoundChannel.new)
@:access(openfl.media.SoundMixer)
class LimeSoundBackend
{
	private var buffer:AudioBuffer;
	private var parent:Sound;

	public function new(parent:Sound)
	{
		this.parent = parent;
	}

	public function close():Void
	{
		if (buffer != null)
		{
			buffer.dispose();
			buffer = null;
		}
	}

	public static function fromAudioBuffer(buffer:AudioBuffer):Sound
	{
		var sound = new Sound();
		sound.__backend.buffer = buffer;
		return sound;
	}

	public static function fromFile(path:String):Sound
	{
		return fromAudioBuffer(AudioBuffer.fromFile(path));
	}

	public function getID3():ID3Info
	{
		return new ID3Info();
	}

	public function getLength():Int
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
			else if (buffer.__srcVorbisFile != null)
			{
				var samples = Int64.toInt(buffer.__srcVorbisFile.pcmTotal());
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

	public function load(stream:URLRequest, context:SoundLoaderContext = null):Void
	{
		#if openfl_html5
		var defaultLibrary = Assets.getLibrary("default"); // TODO: Improve this

		if (defaultLibrary != null && defaultLibrary.cachedAudioBuffers.exists(parent.url))
		{
			AudioBuffer_onURLLoad(defaultLibrary.cachedAudioBuffers.get(parent.url));
		}
		else
		{
			AudioBuffer.loadFromFile(parent.url).onComplete(AudioBuffer_onURLLoad).onError(function(_)
			{
				AudioBuffer_onURLLoad(null);
			});
		}
		#else
		AudioBuffer.loadFromFile(parent.url).onComplete(AudioBuffer_onURLLoad).onError(function(_)
		{
			AudioBuffer_onURLLoad(null);
		});
		#end
	}

	public function loadCompressedDataFromByteArray(bytes:ByteArray, bytesLength:Int):Void
	{
		if (bytes.position > 0 || bytes.length > bytesLength)
		{
			var copy = new ByteArray(bytesLength);
			copy.writeBytes(bytes, bytes.position, bytesLength);
			bytes = copy;
		}

		buffer = AudioBuffer.fromBytes(bytes);

		if (buffer == null)
		{
			parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		else
		{
			parent.dispatchEvent(new Event(Event.COMPLETE));
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

		parent.dispatchEvent(new Event(Event.COMPLETE));
	}

	public function play(startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel
	{
		if (buffer == null) return null;

		if (SoundMixer.__soundChannels.length >= SoundMixer.MAX_ACTIVE_CHANNELS)
		{
			return null;
		}

		return new SoundChannel(parent, startTime, loops, sndTransform);
	}

	// Event Handlers
	private function AudioBuffer_onURLLoad(buffer:AudioBuffer):Void
	{
		if (buffer == null)
		{
			parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		else
		{
			this.buffer = buffer;
			parent.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
#end
