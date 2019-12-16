package flash.display3D.textures;

#if flash
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

@:final extern class RectangleTexture extends TextureBase
{
	public function uploadFromBitmapData(source:BitmapData):Void;
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void;
}
#else
typedef RectangleTexture = openfl.display3D.textures.RectangleTexture;
#end
