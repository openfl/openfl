package flash.media;

#if flash
import openfl.events.EventDispatcher;

@:final extern class SoundChannel extends EventDispatcher
{
	public var leftPeak(default, never):Float;
	public var position(default, never):Float;
	public var rightPeak(default, never):Float;
	public var soundTransform:SoundTransform;
	#if flash
	public function new();
	#end
	public function stop():Void;
}
#else
typedef SoundChannel = openfl.media.SoundChannel;
#end
