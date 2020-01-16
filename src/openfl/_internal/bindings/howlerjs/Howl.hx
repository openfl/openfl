package openfl._internal.bindings.howlerjs;

#if openfl_html5
import haxe.Constraints.Function;

#if commonjs
@:jsRequire("howler", "Howl")
#else
@:native("Howl")
#end
extern class Howl
{
	public function new(options:HowlOptions);
	public function duration(?id:Int):Int;
	public function fade(from:Float, to:Float, len:Int, ?id:Int):Howl;
	public function load():Howl;
	@:overload(function(id:Int):Bool {})
	@:overload(function(loop:Bool):Howl {})
	@:overload(function(loop:Bool, id:Int):Howl {})
	public function loop():Bool;
	public function mute(muted:Bool, ?id:Int):Howl;
	public function off(event:String, fn:Function, ?id:Int):Howl;
	public function on(event:String, fn:Function, ?id:Int):Howl;
	public function once(event:String, fn:Function, ?id:Int):Howl;
	public function pause(?id:Int):Howl;
	@:overload(function(id:Int):Int {})
	public function play(?sprite:String):Int;
	public function playing(?id:Int):Bool;
	@:overload(function(id:Int):Float {})
	@:overload(function(rate:Float):Howl {})
	@:overload(function(rate:Float, id:Int):Howl {})
	public function rate():Float;
	public function state():String;
	@:overload(function(id:Int):Float {})
	@:overload(function(seek:Float):Howl {})
	@:overload(function(seek:Float, id:Int):Howl {})
	public function seek():Float;
	public function stop(?id:Int):Howl;
	public function unload():Void;
	@:overload(function(id:Int):Float {})
	@:overload(function(vol:Float):Howl {})
	@:overload(function(vol:Float, id:Int):Howl {})
	public function volume():Float;
	@:overload(function(pan:Float):Howl {})
	@:overload(function(pan:Float, id:Int):Howl {})
	public function stereo():Float;
	@:overload(function(x:Float):Howl {})
	@:overload(function(x:Float, y:Float):Howl {})
	@:overload(function(x:Float, y:Float, z:Float):Howl {})
	@:overload(function(x:Float, y:Float, z:Float, id:Int):Howl {})
	public function pos():Array<Float>;
}

typedef HowlOptions =
{
	src:Array<String>,
	?volume:Float,
	?html5:Bool,
	?loop:Bool,
	?preload:Bool,
	?autoplay:Bool,
	?mute:Bool,
	?sprite:Dynamic,
	?rate:Float,
	?pool:Float,
	?format:Array<String>,
	?onload:Function,
	?onloaderror:Function,
	?onplay:Function,
	?onend:Function,
	?onpause:Function,
	?onstop:Function,
	?onmute:Function,
	?onvolume:Function,
	?onrate:Function,
	?onseek:Function,
	?onfade:Function
}
#end
