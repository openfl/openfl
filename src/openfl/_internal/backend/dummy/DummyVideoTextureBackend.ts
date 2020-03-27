namespace openfl._internal.backend.dummy;

import openfl.display3D.textures.VideoTexture;
import openfl.net.NetStream;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyVideoTextureBackend extends DummyTextureBaseBackend
{
	public constructor(parent: VideoTexture)
	{
		super(parent);
	}

	public attachNetStream(netStream: NetStream): void { }
}
