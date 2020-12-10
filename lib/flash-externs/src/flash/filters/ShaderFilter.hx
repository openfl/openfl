package flash.filters;

#if flash
import openfl.display.Shader;

extern class ShaderFilter extends BitmapFilter
{
	public var bottomExtension:Int;
	public var leftExtension:Int;
	public var rightExtension:Int;
	public var shader:Shader;
	public var topExtension:Int;
	public function new(shader:Shader);
}
#else
typedef ShaderFilter = openfl.filters.ShaderFilter;
#end
