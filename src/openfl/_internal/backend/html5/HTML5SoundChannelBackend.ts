namespace openfl._internal.backend.html5;

#if openfl_html5
import openfl._internal.bindings.howlerjs.Howl;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundMixer;
import SoundTransform from "openfl/media/SoundTransform";

@: access(openfl.media.Sound)
@: access(openfl.media.SoundChannel)
@: access(openfl.media.SoundMixer)
class HTML5SoundChannelBackend
{
	private howlID: number;
	private parent: SoundChannel;
	private srcHowl: Howl;

	public new(parent: SoundChannel, sound: Sound = null, startTime: number = 0, loops: number = 0)
	{
		this.parent = parent;

		var pan = SoundMixer.__soundTransform.pan + parent.__soundTransform.pan;

		if (pan > 1) pan = 1;
		if (pan < -1) pan = -1;

		var volume = SoundMixer.__soundTransform.volume * parent.__soundTransform.volume;

		srcHowl = @: privateAccess sound.__backend.srcHowl;

		var cacheVolume = untyped srcHowl._volume;
		untyped srcHowl._volume = volume;

		howlID = srcHowl.play();

		untyped srcHowl._volume = cacheVolume;

		if (srcHowl.pos != null)
		{
			srcHowl.pos(pan, 0, -1 * Math.sqrt(1 - Math.pow(pan, 2)), howlID);
			// There are more settings to the position of the sound on the "pannerAttr()" of howler.
			// Maybe somebody who understands sound should look into it?
		}

		srcHowl.on("end", parent.__onComplete, howlID);

		if (startTime > 0)
		{
			srcHowl.seek(startTime, howlID);
		}
	}

	public dispose(): void
	{
		srcHowl.off("end", parent.__onComplete, howlID);
		srcHowl = null;
	}

	public getPosition(): number
	{
		return srcHowl.seek(howlID) * 1000;
	}

	public setPosition(value: number): void
	{
		srcHowl.seek(value < 0 ? 0 : value, howlID);
	}

	public setSoundTransform(value: SoundTransform): void
	{
		var pan = SoundMixer.__soundTransform.pan + value.pan;

		if (pan < -1) pan = -1;
		if (pan > 1) pan = 1;

		var volume = SoundMixer.__soundTransform.volume * value.volume;

		srcHowl.volume(volume, howlID);
		if (srcHowl.pos != null)
		{
			srcHowl.pos(pan, 0, -1 * Math.sqrt(1 - Math.pow(pan, 2)), howlID);
		}
	}

	public stop(): void
	{
		srcHowl.stop(howlID);
	}
}
#else
typedef SoundChannel = flash.media.SoundChannel;
#end
