namespace openfl._internal.backend.dummy;

import Context3D from "../display3D/Context3D";
import openfl.display.Shader;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyShaderBackend
{
	public constructor(parent: Shader) { }

	public init(context3D: Context3D = null): void { }

	public update(): void { }
}
