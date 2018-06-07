package openfl.display3D.textures; #if (display || !flash)


import openfl.display.BitmapData;
import openfl.utils.ByteArray;

@:jsRequire("openfl/display3D/textures/RectangleTexture", "default")


@:final extern class RectangleTexture extends TextureBase {
	
	
	public function uploadFromBitmapData (source:BitmapData):Void;
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt):Void;
	
	
}


#else
typedef RectangleTexture = flash.display3D.textures.RectangleTexture;
#end