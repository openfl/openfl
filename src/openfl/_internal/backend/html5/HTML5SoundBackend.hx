package openfl._internal.backend.html5;

#if openfl_html5
import haxe.io.Bytes;
import openfl._internal.backend.lime_standalone.Base64;
import openfl._internal.bindings.howlerjs.Howl;
import openfl._internal.utils.Log;
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
import openfl.utils.Promise;

@:access(openfl.media.Sound)
@:access(openfl.media.SoundChannel.new)
@:access(openfl.media.SoundMixer)
class HTML5SoundBackend
{
	private var parent:Sound;
	private var srcHowl:Howl;

	public function new(parent:Sound)
	{
		this.parent = parent;
	}

	public function close():Void {}

	public static function fromFile(path:String):Sound
	{
		var sound = new Sound();
		sound.__backend.srcHowl = new Howl({src: [path], #if force_html5_audio html5: true, #end preload: false});
		return sound;
	}

	private function getCodec(bytes:Bytes):String
	{
		var signature = bytes.getString(0, 4);

		switch (signature)
		{
			case "OggS":
				return "audio/ogg";
			case "fLaC":
				return "audio/flac";
			case "RIFF" if (bytes.getString(8, 4) == "WAVE"):
				return "audio/wav";
			default:
				switch ([bytes.get(0), bytes.get(1), bytes.get(2)])
				{
					case [73, 68, 51] | [255, 251, _] | [255, 250, _] | [255, 243, _]: return "audio/mp3";
					default:
				}
		}

		Log.error("Unsupported sound format");
		return null;
	}

	public function getID3():ID3Info
	{
		return new ID3Info();
	}

	public function getLength():Int
	{
		if (srcHowl != null)
		{
			return Std.int(srcHowl.duration() * 1000);
		}

		return 0;
	}

	public function load(stream:URLRequest, context:SoundLoaderContext = null):Void
	{
		srcHowl = new Howl({src: [parent.url], #if force_html5_audio html5: true, #end preload: false});

		srcHowl.on("load", function()
		{
			parent.dispatchEvent(new Event(Event.COMPLETE));
		});

		srcHowl.on("loaderror", function(id, msg)
		{
			srcHowl = null;
			parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		});
	}

	public function loadCompressedDataFromByteArray(bytes:ByteArray, bytesLength:Int):Void
	{
		if (bytes.position > 0 || bytes.length > bytesLength)
		{
			var copy = new ByteArray(bytesLength);
			copy.writeBytes(bytes, bytes.position, bytesLength);
			bytes = copy;
		}

		srcHowl = new Howl({src: ["data:" + getCodec(bytes) + ";base64," + Base64.encode(bytes)], html5: true, preload: false});
		parent.dispatchEvent(new Event(Event.COMPLETE));
	}

	public static function loadFromFile(path:String):Future<Sound>
	{
		return loadFromFiles([path]);
	}

	public static function loadFromFiles(paths:Array<String>):Future<Sound>
	{
		var sound = new Sound();
		sound.__backend.srcHowl = new Howl({src: paths, #if force_html5_audio html5: true, #end preload: false});
		var promise = new Promise<Sound>();

		sound.__backend.srcHowl.on("load", function()
		{
			promise.complete(sound);
		});

		sound.__backend.srcHowl.on("loaderror", function(id, msg)
		{
			sound.__backend.srcHowl = null;
			promise.error(msg);
		});

		sound.__backend.srcHowl.load();
		return promise.future;
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

		// TODO
		parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
	}

	public function play(startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel
	{
		if (srcHowl == null) return null;

		if (SoundMixer.__soundChannels.length >= SoundMixer.MAX_ACTIVE_CHANNELS)
		{
			return null;
		}

		return new SoundChannel(parent, startTime, loops, sndTransform);
	}
}
#end
