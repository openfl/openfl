package openfl._internal.backend.dummy;

import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl.display3D.textures.CubeTexture;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyCubeTextureBackend extends DummyTextureBaseBackend
{
	public function new(parent:CubeTexture)
	{
		super(parent);
	}

	public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void {}

	public function uploadFromBitmapData(source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void {}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void {}

	public function uploadFromTypedArray(data:ArrayBufferView, side:UInt, miplevel:UInt = 0):Void {}
}
