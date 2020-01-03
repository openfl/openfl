package openfl._internal.bindings.howlerjs;

#if openfl_html5
import haxe.extern.EitherType;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;

#if commonjs
@:jsRequire("howler")
#else
@:native("Howler")
#end
extern class Howler
{
	public static var autoSuspend:Bool;
	public static var ctx:AudioContext;
	public static var masterGain:GainNode;
	public static var mobileAutoEnable:Bool;
	public static var noAudio:Bool;
	public static var usingWebAudio:Bool;
	public static function codecs(ext:String):Bool;
	public static function mute(muted:Bool):Howler;
	public static function unload():Howler;
	public static function volume(?vol:Float):EitherType<Int, Howler>;
}
#end
