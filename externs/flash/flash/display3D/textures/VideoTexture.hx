package flash.display3D.textures;

#if flash
import openfl.net.NetStream;

@:final extern class VideoTexture extends TextureBase
{
	public var videoHeight(default, never):Int;
	public var videoWidth(default, never):Int;
	#if flash
	public function attachCamera(theCamera:flash.media.Camera):Void;
	#end
	public function attachNetStream(netStream:NetStream):Void;
}
#else
typedef VideoTexture = openfl.display3D.textures.VideoTexture;
#end
