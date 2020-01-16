package openfl._internal.backend.dummy;

import openfl._internal.bindings.gl.GLBuffer;
import openfl._internal.bindings.gl.GL;
import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl._internal.bindings.typedarray.Float32Array;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.VertexBuffer3D;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyVertexBuffer3DBackend
{
	public function new(parent:VertexBuffer3D) {}

	public function dispose():Void {}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void {}

	public function uploadFromTypedArray(data:ArrayBufferView, byteLength:Int = -1):Void {}

	public function uploadFromVector(data:Vector<Float>, startVertex:Int, numVertices:Int):Void {}
}
