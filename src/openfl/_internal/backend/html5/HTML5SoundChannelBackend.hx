package openfl._internal.backend.html5;

#if openfl_html5
import openfl._internal.bindings.howlerjs.Howl;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;

@:access(openfl.media.Sound)
@:access(openfl.media.SoundChannel)
@:access(openfl.media.SoundMixer)
class HTML5SoundChannelBackend
{
	private var howlID:Int;
	private var parent:SoundChannel;
	private var srcHowl:Howl;

	public function new(parent:SoundChannel, sound:Sound = null, startTime:Float = 0, loops:Int = 0)
	{
		this.parent = parent;

		var pan = SoundMixer.__soundTransform.pan + parent.__soundTransform.pan;

		if (pan > 1) pan = 1;
		if (pan < -1) pan = -1;

		var volume = SoundMixer.__soundTransform.volume * parent.__soundTransform.volume;

		srcHowl = @:privateAccess sound.__backend.srcHowl;

		var cacheVolume = untyped srcHowl._volume;
		untyped srcHowl._volume = volume;

		howlID = srcHowl.play();

		untyped srcHowl._volume = cacheVolume;

		if (srcHowl.pos != null)
		{
			srcHowl.pos(pan, 0, -1 * Math.sqrt(1 - Math.pow(pan, 2)), howlID);
			// There are more settings to the position of the sound on the "pannerAttr()" function of howler.
			// Maybe somebody who understands sound should look into it?
		}

		srcHowl.on("end", parent.__onComplete, howlID);

		if (startTime > 0)
		{
			srcHowl.seek(startTime, howlID);
		}
	}

	public function dispose():Void
	{
		srcHowl.off("end", parent.__onComplete, howlID);
		srcHowl = null;
	}

	public function getPosition():Float
	{
		return srcHowl.seek(howlID) * 1000;
	}

	public function setPosition(value:Float):Void
	{
		srcHowl.seek(value < 0 ? 0 : value, howlID);
	}

	public function setSoundTransform(value:SoundTransform):Void
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

	public function stop():Void
	{
		srcHowl.stop(howlID);
	}
}
#else
typedef SoundChannel = flash.media.SoundChannel;
#end
