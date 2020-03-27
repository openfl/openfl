namespace openfl._internal.backend.dummy;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import SoundTransform from "../media/SoundTransform";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummySoundChannelBackend
{
	public constructor(parent: SoundChannel, sound: Sound = null, startTime: number = 0, loops: number = 0) { }

	public dispose(): void { }

	public getPosition(): number
	{
		return 0;
	}

	public setPosition(value: number): void { }

	public setSoundTransform(value: SoundTransform): void { }

	public stop(): void { }
}
