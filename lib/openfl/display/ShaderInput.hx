package openfl.display;

#if (display || !flash)
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;

@:jsRequire("openfl/display/ShaderInput", "default")
#if !js
@:generic
#end
@:final extern class ShaderInput<T> /*implements Dynamic*/
{
	public var channels(default, null):Int;
	public var filter:Context3DTextureFilter;
	public var height:Int;
	public var index(default, null):Int;
	public var input:T;
	public var mipFilter:Context3DMipFilter;
	public var width:Int;
	public var wrap:Context3DWrapMode;
	public function new();
}
#else
typedef ShaderInput<T> = flash.display.ShaderInput<T>;
#end
