package flash.display3D.textures;

#if flash
import openfl.net.NetStream;

@:final extern class VideoTexture extends TextureBase
{
	#if (haxe_ver < 4.3)
	public var videoHeight(default, never):Int;
	public var videoWidth(default, never):Int;
	#else
	@:flash.property var videoHeight(get, never):Int;
	@:flash.property var videoWidth(get, never):Int;
	#end

	public function attachCamera(theCamera:flash.media.Camera):Void;
	public function attachNetStream(netStream:NetStream):Void;

	#if (haxe_ver >= 4.3)
	private function get_videoHeight():Int;
	private function get_videoWidth():Int;
	#end
}
#else
typedef VideoTexture = openfl.display3D.textures.VideoTexture;
#end
