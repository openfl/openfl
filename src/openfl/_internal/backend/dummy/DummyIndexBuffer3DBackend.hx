package openfl._internal.backend.dummy;

import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl.display3D.IndexBuffer3D;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyIndexBuffer3DBackend
{
	public function new(parent:IndexBuffer3D) {}

	public function dispose():Void {}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {}

	public function uploadFromTypedArray(data:ArrayBufferView, byteLength:Int = -1):Void {}

	public function uploadFromVector(data:Vector<UInt>, startOffset:Int, count:Int):Void {}
}
