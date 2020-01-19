package openfl._internal.backend.dummy;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummySoundChannelBackend
{
	public function new(parent:SoundChannel, sound:Sound = null, startTime:Float = 0, loops:Int = 0) {}

	public function dispose():Void {}

	public function getPosition():Float
	{
		return 0;
	}

	public function setPosition(value:Float):Void {}

	public function setSoundTransform(value:SoundTransform):Void {}

	public function stop():Void {}
}
