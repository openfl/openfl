namespace openfl._internal.bindings.howlerjs;

#if openfl_html5
import haxe.Constraints.Function;

#if commonjs
@: jsRequire("howler", "Howl")
#else
@: native("Howl")
#end
extern class Howl
{
	public new(options: HowlOptions);
	public duration(?id: number): number;
	public fade(from: number, to: number, len: number, ?id: number): Howl;
	public load(): Howl;
	@: overload(function (id: number): boolean { })
@: overload(function (loop: boolean): Howl { })
@: overload(function (loop: boolean, id: number): Howl { })
	public loop() : boolean;
	public mute(muted : boolean, ?id : number): Howl;
	public off(event: string, fn: Function, ?id : number): Howl;
	public on(event: string, fn: Function, ?id : number): Howl;
	public once(event: string, fn: Function, ?id : number): Howl;
	public pause(?id : number): Howl;
@: overload(function (id: number): number { })
	public play(?sprite: string) : number;
	public playing(?id : number) : boolean;
@: overload(function (id: number): number { })
@: overload(function (rate: number): Howl { })
@: overload(function (rate: number, id: number): Howl { })
	public rate() : number;
	public state(): string;
@: overload(function (id: number): number { })
@: overload(function (seek: number): Howl { })
@: overload(function (seek: number, id: number): Howl { })
	public seek() : number;
	public stop(?id : number): Howl;
	public unload(): void;
@: overload(function (id: number): number { })
@: overload(function (vol: number): Howl { })
@: overload(function (vol: number, id: number): Howl { })
	public volume() : number;
@: overload(function (pan: number): Howl { })
@: overload(function (pan: number, id: number): Howl { })
	public stereo() : number;
@: overload(function (x: number): Howl { })
@: overload(function (x: number, y: number): Howl { })
@: overload(function (x: number, y: number, z: number): Howl { })
@: overload(function (x: number, y: number, z: number, id: number): Howl { })
	public pos(): Array<Float>;
}

typedef HowlOptions =
{
	src: Array < String >,
	?volume: number,
	?html5: boolean,
	?loop: boolean,
	?preload: boolean,
	?autoplay: boolean,
	?mute: boolean,
	?sprite: Dynamic,
	?rate: number,
	?pool: number,
	?format: Array < String >,
	?onload: Function,
	?onloaderror: Function,
	?onplay: Function,
	?onend: Function,
	?onpause: Function,
	?onstop: Function,
	?onmute: Function,
	?onvolume: Function,
	?onrate: Function,
	?onseek: Function,
	?onfade: Function
}
#end
