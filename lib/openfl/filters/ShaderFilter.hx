package openfl.filters;

#if (display || !flash)
import openfl.display.BlendMode;
import openfl.display.Shader;

@:jsRequire("openfl/filters/ShaderFilter", "default")
extern class ShaderFilter extends BitmapFilter
{
	@:beta public var blendMode:BlendMode;
	public var bottomExtension:Int;
	public var leftExtension:Int;
	public var rightExtension:Int;
	public var shader:Shader;
	public var topExtension:Int;
	public function new(shader:Shader);
}
#else
typedef ShaderFilter = flash.filters.ShaderFilter;
#end
