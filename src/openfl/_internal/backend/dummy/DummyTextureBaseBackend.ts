namespace openfl._internal.backend.dummy;

import openfl.display3D.textures.TextureBase;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyTextureBaseBackend
{
	public constructor(parent: TextureBase) { }

	public dispose(): void { }
}
