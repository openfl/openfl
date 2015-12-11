package openfl.display3D.textures; #if (display || !flash)


import openfl.display.BitmapData;
import openfl.utils.ByteArray;


@:final extern class CubeTexture extends TextureBase {
	
	
	public function uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void;
	public function uploadFromBitmapData (source:BitmapData, side:UInt, miplevel:UInt = 0):Void;
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void;
	
	
}


#else
typedef CubeTexture = flash.display3D.textures.CubeTexture;
#end