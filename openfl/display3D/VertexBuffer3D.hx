package openfl.display3D; #if !flash


import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;
import openfl.utils.ByteArray;
import openfl.Vector;

class VertexBuffer3D {
	
	
	public var data32PerVertex:Int;
	public var glBuffer:GLBuffer;
	public var numVertices:Int;
	
	
	public function new (glBuffer:GLBuffer, numVertices:Int, data32PerVertex:Int) {
		
		this.glBuffer = glBuffer;
		this.numVertices = numVertices;
		this.data32PerVertex = data32PerVertex;
		
	}
	
	
	public function dispose ():Void {
		
		GL.deleteBuffer (glBuffer);
		
	}
	
	
	public function uploadFromByteArray (byteArray:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {
		
		var bytesPerVertex = data32PerVertex * 4;
		
		GL.bindBuffer (GL.ARRAY_BUFFER, glBuffer);
		
		var length:Int = count * bytesPerVertex;
		var offset:Int = byteArrayOffset + startOffset * bytesPerVertex;
		var float32Array:Float32Array;
		
		#if html5
		float32Array = new Float32Array (length);
		byteArray.position = offset;
		
		var i:Int = 0;
		
		while (byteArray.position < length + offset) {
			
			float32Array[i] = byteArray.readUnsignedByte ();
			i++;
			
		}
		#else
		float32Array = new Float32Array (byteArray, offset, length);
		#end
		
		GL.bufferData (GL.ARRAY_BUFFER, float32Array, GL.STATIC_DRAW);
		
	}
	
	
	#if js
	public function uploadFromFloat32Array (data:Float32Array, startVertex:Int, numVertices:Int):Void {
		
		GL.bindBuffer (GL.ARRAY_BUFFER, glBuffer);
		GL.bufferData (GL.ARRAY_BUFFER, data, GL.STATIC_DRAW);
		
	}
	#end
	
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		var bytesPerVertex = data32PerVertex * 4;
		
		GL.bindBuffer (GL.ARRAY_BUFFER, glBuffer);
		
		var length:Int = numVertices * data32PerVertex;
		var offset:Int = startVertex;
		var float32Array:Float32Array;
		
		#if html5
		float32Array = new Float32Array (length);
		
		for (i in startVertex...(startVertex + length)) {
			
			float32Array[i] = data[i];
			
		}
		#else
		float32Array = new Float32Array (data, offset, length);
		#end
		
		GL.bufferData (GL.ARRAY_BUFFER, float32Array, GL.STATIC_DRAW);
		
		float32Array = null;
		
	}
	
	
}


#else
typedef VertexBuffer3D = flash.display3D.VertexBuffer3D;
#end