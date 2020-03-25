namespace openfl._internal.backend.dummy;

import openfl.display.ShaderParameter;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyShaderParameterBackend<T> /*implements Dynamic*/
{
	public new(parent: ShaderParameter<T>) { }

	public setName(value: string): void { }
}
