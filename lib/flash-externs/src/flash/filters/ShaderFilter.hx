package flash.filters;

#if flash
import openfl.display.Shader;

extern class ShaderFilter extends BitmapFilter
{
	#if (haxe_ver < 4.3)
	public var bottomExtension:Int;
	public var leftExtension:Int;
	public var rightExtension:Int;
	public var shader:Shader;
	public var topExtension:Int;
	#else
	@:flash.property var bottomExtension(get, set):Int;
	@:flash.property var leftExtension(get, set):Int;
	@:flash.property var rightExtension(get, set):Int;
	@:flash.property var shader(get, set):Shader;
	@:flash.property var topExtension(get, set):Int;
	#end

	public function new(shader:Shader);

	#if (haxe_ver >= 4.3)
	private function get_bottomExtension():Int;
	private function get_leftExtension():Int;
	private function get_rightExtension():Int;
	private function get_shader():Shader;
	private function get_topExtension():Int;
	private function set_bottomExtension(value:Int):Int;
	private function set_leftExtension(value:Int):Int;
	private function set_rightExtension(value:Int):Int;
	private function set_shader(value:Shader):Shader;
	private function set_topExtension(value:Int):Int;
	#end
}
#else
typedef ShaderFilter = openfl.filters.ShaderFilter;
#end
