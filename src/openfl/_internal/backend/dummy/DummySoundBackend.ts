namespace openfl._internal.backend.dummy;

import openfl.media.ID3Info;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundLoaderContext;
import SoundTransform from "../media/SoundTransform";
import openfl.net.URLRequest;
import ByteArray from "../utils/ByteArray";
import openfl.utils.Future;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummySoundBackend
{
	public constructor(parent: Sound) { }

	public close(): void { }

	public static fromFile(path: string): Sound
	{
		return null;
	}

	public getID3(): ID3Info
	{
		return new ID3Info();
	}

	public getLength(): number
	{
		return 0;
	}

	public load(stream: URLRequest, context: SoundLoaderContext = null): void { }

	public loadCompressedDataFromByteArray(bytes: ByteArray, bytesLength: number): void { }

	public static loadFromFile(path: string): Future<Sound>
	{
		return cast Future.withError("");
	}

	public static loadFromFiles(paths: Array<string>): Future<Sound>
	{
		return cast Future.withError("");
	}

	public loadPCMFromByteArray(bytes: ByteArray, samples: number, format: string = "float", stereo: boolean = true, sampleRate: number = 44100): void { }

	public play(startTime: number = 0.0, loops: number = 0, sndTransform: SoundTransform = null): SoundChannel
	{
		return null;
	}
}
