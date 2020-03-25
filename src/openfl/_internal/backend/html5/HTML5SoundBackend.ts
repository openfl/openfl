namespace openfl._internal.backend.html5;

#if openfl_html5
import haxe.io.Bytes;
import openfl._internal.backend.lime_standalone.Base64;
import openfl._internal.bindings.howlerjs.Howl;
import openfl._internal.utils.Log;
import Event from "openfl/events/Event";
import openfl.events.IOErrorEvent;
import openfl.media.ID3Info;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundLoaderContext;
import openfl.media.SoundMixer;
import SoundTransform from "openfl/media/SoundTransform";
import openfl.net.URLRequest;
import ByteArray from "openfl/utils/ByteArray";
import openfl.utils.Future;
import openfl.utils.Promise;

@: access(openfl.media.Sound)
@: access(openfl.media.SoundChannel.new)
@: access(openfl.media.SoundMixer)
class HTML5SoundBackend
{
	private parent: Sound;
	private srcHowl: Howl;

	public new(parent: Sound)
	{
		this.parent = parent;
	}

	public close(): void { }

	public static fromFile(path: string): Sound
	{
		var sound = new Sound();
		sound.__backend.srcHowl = new Howl({ src: [path], #if force_html5_audio html5: true, #end preload: false});
		return sound;
	}

	private getCodec(bytes: Bytes): string
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

	public getID3(): ID3Info
	{
		return new ID3Info();
	}

	public getLength(): number
	{
		if (srcHowl != null)
		{
			return Std.int(srcHowl.duration() * 1000);
		}

		return 0;
	}

	public load(stream: URLRequest, context: SoundLoaderContext = null): void
	{
		srcHowl = new Howl({ src: [parent.url], #if force_html5_audio html5: true, #end preload: false});

		srcHowl.on("load", ()
		{
			parent.dispatchEvent(new Event(Event.COMPLETE));
		});

		srcHowl.on("loaderror", (id, msg)
		{
			srcHowl = null;
			parent.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		});
	}

	public loadCompressedDataFromByteArray(bytes: ByteArray, bytesLength: number): void
	{
		if (bytes.position > 0 || bytes.length > bytesLength)
		{
			var copy = new ByteArray(bytesLength);
			copy.writeBytes(bytes, bytes.position, bytesLength);
			bytes = copy;
		}

		srcHowl = new Howl({ src: ["data:" + getCodec(bytes) + ";base64," + Base64.encode(bytes)], html5: true, preload: false });
		parent.dispatchEvent(new Event(Event.COMPLETE));
	}

	public static loadFromFile(path: string): Future<Sound>
	{
		return loadFromFiles([path]);
	}

	public static loadFromFiles(paths: Array<string>): Future<Sound>
	{
		var sound = new Sound();
		sound.__backend.srcHowl = new Howl({ src: paths, #if force_html5_audio html5: true, #end preload: false});
		var promise = new Promise<Sound>();

		sound.__backend.srcHowl.on("load", ()
		{
			promise.complete(sound);
		});

		sound.__backend.srcHowl.on("loaderror", (id, msg)
		{
			sound.__backend.srcHowl = null;
			promise.error(msg);
		});

		sound.__backend.srcHowl.load();
		return promise.future;
	}

	public loadPCMFromByteArray(bytes: ByteArray, samples: number, format: string = "float", stereo: boolean = true, sampleRate: number = 44100): void
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

	public play(startTime: number = 0.0, loops: number = 0, sndTransform: SoundTransform = null): SoundChannel
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
