package flash.display3D.textures;

#if flash
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

@:final extern class Texture extends TextureBase
{
	public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void;
	public function uploadFromBitmapData(source:BitmapData, miplevel:UInt = 0):Void;
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void;
}
#else
typedef Texture = openfl.display3D.textures.Texture;
#end
