package flash.display3D;

#if flash
import openfl.utils.ByteArray;
import openfl.Vector;

#if lime
import lime.utils.ArrayBufferView;
#end

@:final extern class IndexBuffer3D
{
	public function dispose():Void;
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void;
	#if lime
	public inline function uploadFromTypedArray(data:ArrayBufferView):Void
	{
		uploadFromByteArray(data.buffer, data.byteOffset, 0, data.byteLength);
	}
	#end
	public function uploadFromVector(data:Vector<UInt>, startOffset:Int, count:Int):Void;
}
#else
typedef IndexBuffer3D = openfl.display3D.IndexBuffer3D;
#end
