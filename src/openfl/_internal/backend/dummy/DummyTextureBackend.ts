namespace openfl._internal.backend.dummy;

import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl.display3D.textures.Texture;
import openfl.display.BitmapData;
import ByteArray from "openfl/utils/ByteArray";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyTextureBackend extends DummyTextureBaseBackend
{
	public new(parent: Texture)
	{
		super(parent);
	}

	public uploadCompressedTextureFromByteArray(data: ByteArray, byteArrayOffset: UInt, async: boolean = false): void { }

	public uploadFromBitmapData(source: BitmapData, miplevel: UInt = 0, generateMipmap: boolean = false): void { }

	public uploadFromByteArray(data: ByteArray, byteArrayOffset: UInt, miplevel: UInt = 0): void { }

	public uploadFromTypedArray(data: ArrayBufferView, miplevel: UInt = 0): void { }
}
