package openfl._internal.backend.dummy;

import openfl.media.ID3Info;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundLoaderContext;
import openfl.media.SoundTransform;
import openfl.net.URLRequest;
import openfl.utils.ByteArray;
import openfl.utils.Future;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummySoundBackend
{
	public function new(parent:Sound) {}

	public function close():Void {}

	public static function fromFile(path:String):Sound
	{
		return null;
	}

	public function getID3():ID3Info
	{
		return new ID3Info();
	}

	public function getLength():Int
	{
		return 0;
	}

	public function load(stream:URLRequest, context:SoundLoaderContext = null):Void {}

	public function loadCompressedDataFromByteArray(bytes:ByteArray, bytesLength:Int):Void {}

	public static function loadFromFile(path:String):Future<Sound>
	{
		return cast Future.withError("");
	}

	public static function loadFromFiles(paths:Array<String>):Future<Sound>
	{
		return cast Future.withError("");
	}

	public function loadPCMFromByteArray(bytes:ByteArray, samples:Int, format:String = "float", stereo:Bool = true, sampleRate:Float = 44100):Void {}

	public function play(startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):SoundChannel
	{
		return null;
	}
}
