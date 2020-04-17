package openfl.media;

#if lime
import lime.media.AudioSource;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.media.SoundChannel)
@:access(openfl.media.SoundMixer)
@:noCompletion
class _SoundChannel
{
	private var parent:SoundChannel;
	private var source:AudioSource;

	public function new(parent:SoundChannel, sound:Sound = null, startTime:Float = 0, loops:Int = 0)
	{
		this.parent = parent;

		var pan = SoundMixer.__soundTransform.pan + parent.__soundTransform.pan;

		if (pan > 1) pan = 1;
		if (pan < -1) pan = -1;

		var volume = SoundMixer.__soundTransform.volume * parent.__soundTransform.volume;

		source = new AudioSource(@:privateAccess sound._.buffer);
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

	public function dispose():Void
	{
		source.onComplete.remove(parent.__onComplete);
		source.dispose();
		source = null;
	}

	public function getPosition():Float
	{
		return source.currentTime + source.offset;
	}

	public function setPosition(value:Float):Void
	{
		source.currentTime = Std.int(value < 0 ? 0 : value) - source.offset;
	}

	public function setSoundTransform(value:SoundTransform):Void
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

	public function stop():Void
	{
		source.stop();
	}
}
#end
