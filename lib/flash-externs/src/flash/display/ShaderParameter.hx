package flash.display;

#if flash
@:final extern class ShaderParameter<T> implements Dynamic
{
	#if (haxe_ver < 4.3)
	public var index(default, never):Int;
	public var type(default, never):ShaderParameterType;
	public var value:Array<T>;
	#else
	@:flash.property var index(get, never):Int;
	@:flash.property var type(get, never):ShaderParameterType;
	@:flash.property var value(get, set):Array<T>;
	#end

	public function new();

	#if (haxe_ver >= 4.3)
	private function get_index():Int;
	private function get_type():ShaderParameterType;
	private function get_value():Array<T>;
	private function set_value(value:Array<T>):Array<T>;
	#end
}
#else
typedef ShaderParameter<T> = openfl.display.ShaderParameter<T>;
#end
