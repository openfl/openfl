package openfl.display;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/display/ShaderParameter", "default")
#end
#if !js
@:generic
#end
@:final extern class ShaderParameter<T> /*implements Dynamic*/
{
	public var index(default, null):Int;
	public var type(default, null):ShaderParameterType;
	public var value:Array<T>;
	public function new();
}
#else
typedef ShaderParameter<T> = flash.display.ShaderParameter<T>;
#end
