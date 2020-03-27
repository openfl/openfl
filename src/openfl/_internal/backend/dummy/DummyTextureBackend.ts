namespace openfl._internal.backend.dummy;

import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl.display3D.textures.Texture;
import BitmapData from "../display/BitmapData";
import ByteArray from "../utils/ByteArray";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyTextureBackend extends DummyTextureBaseBackend
{
	public constructor(parent: Texture)
	{
		super(parent);
	}

	public uploadCompressedTextureFromByteArray(data: ByteArray, byteArrayOffset: number, async: boolean = false): void { }

	public uploadFromBitmapData(source: BitmapData, miplevel: number = 0, generateMipmap: boolean = false): void { }

	public uploadFromByteArray(data: ByteArray, byteArrayOffset: number, miplevel: number = 0): void { }

	public uploadFromTypedArray(data: ArrayBufferView, miplevel: number = 0): void { }
}
