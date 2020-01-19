package openfl._internal.backend.dummy;

import openfl.display.ShaderInput;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyShaderInputBackend<T> /*implements Dynamic*/
{
	public function new(parent:ShaderInput<T>) {}
}
