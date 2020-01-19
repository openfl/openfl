package openfl._internal.backend.dummy;

import openfl.display.ShaderParameter;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyShaderParameterBackend<T> /*implements Dynamic*/
{
	public function new(parent:ShaderParameter<T>) {}

	public function setName(value:String):Void {}
}
