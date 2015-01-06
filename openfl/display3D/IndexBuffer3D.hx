package openfl.display3D; #if !flash


import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Int16Array;
import openfl.utils.ByteArray;
import openfl.Vector;


class IndexBuffer3D {
	
	
	public var glBuffer:GLBuffer;
	public var numIndices:Int;
	
	
	public function new (glBuffer:GLBuffer, numIndices:Int) {
		
		this.glBuffer = glBuffer;
		this.numIndices = numIndices;
		
	}
	
	
	public function dispose ():Void {
		
		GL.deleteBuffer (glBuffer);
		
	}
	
	
	public function uploadFromByteArray (byteArray:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {
		
		var bytesPerIndex = 2;
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, glBuffer);
		
		var length:Int = count * bytesPerIndex;
		var offset:Int = byteArrayOffset + startOffset * bytesPerIndex;
		var indices:Int16Array;
		
		#if html5
		indices = new Int16Array (length);
		byteArray.position = offset;
		
		var i:Int = 0;
		
		while (byteArray.position < length + offset) {
			
			indices[i] = byteArray.readUnsignedByte ();
			i++;
			
		}
		#else
		indices = new Int16Array (byteArray, offset, length);
		#end
		
		GL.bufferData (GL.ELEMENT_ARRAY_BUFFER, indices, GL.STATIC_DRAW);
		
	}
	
	
	public function uploadFromVector (data:Vector<UInt>, startOffset:Int, count:Int):Void {
		
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, glBuffer);
		var indices:Int16Array;
		
		#if html5
		indices = new Int16Array (count);
		
		for (i in startOffset...(startOffset + count)) {
			
			indices[i] = data[i];
			
		}
		#else
		indices = new Int16Array (data, startOffset, count);
		#end
		
		GL.bufferData (GL.ELEMENT_ARRAY_BUFFER, indices, GL.STATIC_DRAW);
		
	}
	
	
}


#else
typedef IndexBuffer3D = flash.display3D.IndexBuffer3D;
#end