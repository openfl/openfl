package flash.display3D; #if (!display && flash)


import lime.utils.Int16Array;
import openfl.utils.ByteArray;
import openfl.Vector;


@:final extern class IndexBuffer3D {
	
	
	public function dispose ():Void;
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void;
	
	public inline function uploadFromInt16Array (data:Int16Array):Void {
		
		uploadFromByteArray (data.buffer, data.byteOffset, 0, data.length);
		
	}
	
	public function uploadFromVector (data:Vector<UInt>, startOffset:Int, count:Int):Void;
	
	
}


#else
typedef IndexBuffer3D = openfl.display3D.IndexBuffer3D;
#end