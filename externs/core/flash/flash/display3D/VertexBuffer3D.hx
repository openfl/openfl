package flash.display3D; #if (!display && flash)


import lime.utils.Float32Array;
import openfl.utils.ByteArray;
import openfl.Vector;


extern class VertexBuffer3D {
	
	
	public function dispose ():Void;
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void;
	
	public inline function uploadFromFloat32Array (data:Float32Array):Void {
		
		uploadFromByteArray (data.buffer, data.byteOffset, 0, data.length);
		
	}
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void;
	
	
}


#else
typedef VertexBuffer3D = openfl.display3D.VertexBuffer3D;
#end