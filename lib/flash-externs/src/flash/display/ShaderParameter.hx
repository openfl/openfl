package flash.display;

#if flash
@:final extern class ShaderParameter<T> implements Dynamic
{
	public var index(default, never):Int;
	public var type(default, never):ShaderParameterType;
	public var value:Array<T>;
	public function new();
}
#else
typedef ShaderParameter<T> = openfl.display.ShaderParameter<T>;
#end
