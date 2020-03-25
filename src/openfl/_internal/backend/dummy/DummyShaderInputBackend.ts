namespace openfl._internal.backend.dummy;

import openfl.display.ShaderInput;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyShaderInputBackend<T> /*implements Dynamic*/
{
	public new(parent: ShaderInput<T>) { }
}
