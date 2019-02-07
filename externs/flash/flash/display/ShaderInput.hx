package flash.display;

#if flash
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;

@:final extern class ShaderInput<T> implements Dynamic
{
	public var channels(default, never):Int;
	public var height:Int;
	public var index(default, never):Int;
	public var input:T;
	public var filter(get, set):Context3DTextureFilter;
	@:noCompletion private inline function get_filter():Context3DTextureFilter
	{
		return Context3DTextureFilter.NEAREST;
	}
	@:noCompletion private inline function set_filter(value:Context3DTextureFilter):Context3DTextureFilter
	{
		return value;
	}
	public var mipFilter(get, set):Context3DMipFilter;
	@:noCompletion private inline function get_mipFilter():Context3DMipFilter
	{
		return Context3DMipFilter.MIPNONE;
	}
	@:noCompletion private inline function set_mipFilter(value:Context3DMipFilter):Context3DMipFilter
	{
		return value;
	}
	public var width:Int;
	public var wrap(get, set):Context3DWrapMode;
	@:noCompletion private inline function get_wrap():Context3DWrapMode
	{
		return Context3DWrapMode.CLAMP;
	}
	@:noCompletion private inline function set_wrap(value:Context3DWrapMode):Context3DWrapMode
	{
		return value;
	}
	public function new();
}
#else
typedef ShaderInput<T> = openfl.display.ShaderInput<T>;
#end
