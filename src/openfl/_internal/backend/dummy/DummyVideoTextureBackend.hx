package openfl._internal.backend.dummy;

import openfl.display3D.textures.VideoTexture;
import openfl.net.NetStream;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyVideoTextureBackend extends DummyTextureBaseBackend
{
	public function new(parent:VideoTexture)
	{
		super(parent);
	}

	public function attachNetStream(netStream:NetStream):Void {}
}
