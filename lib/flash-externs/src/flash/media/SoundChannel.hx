package flash.media;

#if flash
import openfl.events.EventDispatcher;

@:final extern class SoundChannel extends EventDispatcher
{
	#if (haxe_ver < 4.3)
	public var leftPeak(default, never):Float;
	public var position(default, never):Float;
	public var rightPeak(default, never):Float;
	public var soundTransform:SoundTransform;
	#else
	@:flash.property var leftPeak(get, never):Float;
	@:flash.property var position(get, never):Float;
	@:flash.property var rightPeak(get, never):Float;
	@:flash.property var soundTransform(get, set):SoundTransform;
	#end

	public function new();
	public function stop():Void;

	#if (haxe_ver >= 4.3)
	private function get_leftPeak():Float;
	private function get_position():Float;
	private function get_rightPeak():Float;
	private function get_soundTransform():SoundTransform;
	private function set_soundTransform(value:SoundTransform):SoundTransform;
	#end
}
#else
typedef SoundChannel = openfl.media.SoundChannel;
#end
