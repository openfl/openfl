namespace openfl._internal.backend.lime;

#if lime
import lime.media.AudioSource;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundMixer;
import SoundTransform from "openfl/media/SoundTransform";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl.media.SoundChannel)
@: access(openfl.media.SoundMixer)
class LimeSoundChannelBackend
{
	private parent: SoundChannel;
	private source: AudioSource;

	public new(parent: SoundChannel, sound: Sound = null, startTime: number = 0, loops: number = 0)
	{
		this.parent = parent;

		var pan = SoundMixer.__soundTransform.pan + parent.__soundTransform.pan;

		if (pan > 1) pan = 1;
		if (pan < -1) pan = -1;

		var volume = SoundMixer.__soundTransform.volume * parent.__soundTransform.volume;

		source = new AudioSource(@: privateAccess sound.__backend.buffer);
		source.offset = Std.int(startTime);
		if (loops > 1) source.loops = loops - 1;

		source.gain = volume;

		var position = source.position;
		position.x = pan;
		position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
		source.position = position;

		source.onComplete.add(parent.__onComplete);
		source.play();
	}

	public dispose(): void
	{
		source.onComplete.remove(parent.__onComplete);
		source.dispose();
		source = null;
	}

	public getPosition(): number
	{
		return source.currentTime + source.offset;
	}

	public setPosition(value: number): void
	{
		source.currentTime = Std.int(value < 0 ? 0 : value) - source.offset;
	}

	public setSoundTransform(value: SoundTransform): void
	{
		var pan = SoundMixer.__soundTransform.pan + value.pan;

		if (pan < -1) pan = -1;
		if (pan > 1) pan = 1;

		var volume = SoundMixer.__soundTransform.volume * value.volume;

		source.gain = volume;
		var position = source.position;
		position.x = pan;
		position.z = -1 * Math.sqrt(1 - Math.pow(pan, 2));
		source.position = position;
	}

	public stop(): void
	{
		source.stop();
	}
}
#end
