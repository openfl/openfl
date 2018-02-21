package openfl.display3D; #if (display || !flash)


import lime.utils.ArrayBufferView;
import openfl.utils.ByteArray;
import openfl.Vector;


extern class VertexBuffer3D {
	
	
	public function dispose ():Void;
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void;
	public function uploadFromTypedArray (data:ArrayBufferView):Void;
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void;
	
	
}


#else
typedef VertexBuffer3D = flash.display3D.VertexBuffer3D;
#end