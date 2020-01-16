package flash.media;

#if flash
extern class SoundLoaderContext
{
	public var bufferTime:Float;
	public var checkPolicyFile:Bool;
	public function new(bufferTime:Float = 1000, checkPolicyFile:Bool = false);
}
#else
typedef SoundLoaderContext = openfl.media.SoundLoaderContext;
#end
