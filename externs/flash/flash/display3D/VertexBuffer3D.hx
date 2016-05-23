package flash.display3D; #if (!display && flash)


import openfl.utils.ByteArray;
import openfl.Vector;


extern class VertexBuffer3D {
	
	
	public function dispose ():Void;
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void;
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void;
	
	
}


#else
typedef VertexBuffer3D = openfl.display3D.VertexBuffer3D;
#end