package openfl.display3D;

#if (display || !flash)
import js.lib.ArrayBufferView;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_global
@:jsRequire("openfl/display3D/VertexBuffer3D", "default")
#end
extern class VertexBuffer3D
{
	public function dispose():Void;
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void;
	public function uploadFromTypedArray(data:ArrayBufferView):Void;
	public function uploadFromVector(data:Vector<Float>, startVertex:Int, numVertices:Int):Void;
}
#else
typedef VertexBuffer3D = flash.display3D.VertexBuffer3D;
#end
