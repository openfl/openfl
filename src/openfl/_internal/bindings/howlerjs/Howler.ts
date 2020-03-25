namespace openfl._internal.bindings.howlerjs;

#if openfl_html5
import haxe.extern.EitherType;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;

#if commonjs
@: jsRequire("howler")
#else
@: native("Howler")
#end
extern class Howler
{
	public static autoSuspend: boolean;
	public static ctx: AudioContext;
	public static masterGain: GainNode;
	public static mobileAutoEnable: boolean;
	public static noAudio: boolean;
	public static usingWebAudio: boolean;
	public static codecs(ext: string): boolean;
	public static mute(muted: boolean): Howler;
	public static unload(): Howler;
	public static volume(?vol: number): EitherType<Int, Howler>;
}
#end
