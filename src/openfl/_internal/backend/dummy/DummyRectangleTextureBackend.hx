package openfl._internal.backend.dummy;

import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl.display3D.textures.RectangleTexture;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyRectangleTextureBackend extends DummyTextureBaseBackend
{
	public function new(parent:RectangleTexture)
	{
		super(parent);
	}

	public function uploadFromBitmapData(source:BitmapData):Void {}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void {}

	public function uploadFromTypedArray(data:ArrayBufferView):Void {}
}
