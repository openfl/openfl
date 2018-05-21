package openfl.display3D.textures; #if (display || !flash)


import openfl.net.NetStream;

@:jsRequire("openfl/display3D/textures/VideoTexture", "default")


@:final extern class VideoTexture extends TextureBase {
	
	
	public var videoHeight (default, null):Int;
	public var videoWidth (default, null):Int;
	
	//public function attachCamera (theCamera:Camera):Void;
	public function attachNetStream (netStream:NetStream):Void;
	
	
}


#else
typedef VideoTexture = flash.display3D.textures.VideoTexture;
#end