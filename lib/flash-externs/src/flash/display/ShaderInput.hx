package flash.display;

#if flash
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;

@:final extern class ShaderInput<T> implements Dynamic
{
	#if (haxe_ver < 4.3)
	public var channels(default, never):Int;
	public var height:Int;
	public var index(default, never):Int;
	public var input:T;
	public var width:Int;
	#else
	@:flash.property var channels(get, never):Int;
	@:flash.property var height(get, set):Int;
	@:flash.property var index(get, never):Int;
	@:flash.property var input(get, set):T;
	@:flash.property var width(get, set):Int;
	#end

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

	#if (haxe_ver >= 4.3)
	private function get_channels():Int;
	private function get_height():Int;
	private function get_index():Int;
	private function get_input():T;
	private function get_width():Int;
	private function set_height(value:Int):Int;
	private function set_input(value:T):T;
	private function set_width(value:Int):Int;
	#end
}
#else
typedef ShaderInput<T> = openfl.display.ShaderInput<T>;
#end
