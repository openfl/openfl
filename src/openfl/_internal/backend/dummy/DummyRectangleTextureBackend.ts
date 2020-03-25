namespace openfl._internal.backend.dummy;

import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl.display3D.textures.RectangleTexture;
import openfl.display.BitmapData;
import ByteArray from "openfl/utils/ByteArray";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyRectangleTextureBackend extends DummyTextureBaseBackend
{
	public new(parent: RectangleTexture)
	{
		super(parent);
	}

	public uploadFromBitmapData(source: BitmapData): void { }

	public uploadFromByteArray(data: ByteArray, byteArrayOffset: UInt): void { }

	public uploadFromTypedArray(data: ArrayBufferView): void { }
}
