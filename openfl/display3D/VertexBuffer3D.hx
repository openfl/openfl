package openfl.display3D;


import lime.utils.ArrayBuffer;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;
import openfl.utils.ByteArray;
import openfl.Vector;


class VertexBuffer3D {
	
	
	private var __context:Context3D;
	private var __data32PerVertex:Int;
	private var __glBuffer:GLBuffer;
	private var __numVertices:Int;
	private var __bufferUsage:Int;
	
	
	private function new (context:Context3D, glBuffer:GLBuffer, numVertices:Int, data32PerVertex:Int, bufferUsage:Int) {
		
		__context = context;
		__glBuffer = glBuffer;
		__numVertices = numVertices;
		__data32PerVertex = data32PerVertex;
		__bufferUsage = bufferUsage;
		
	}
	
	
	public function dispose ():Void {
		
		__context.__deleteVertexBuffer (this);
		
	}
	
	
	public function uploadFromByteArray (byteArray:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void {
		
		var bytesPerVertex = __data32PerVertex * 4;
		var offset = byteArrayOffset + (startVertex * bytesPerVertex);
		var length = numVertices * __data32PerVertex;
		
		var array = new Float32Array (byteArray, offset, length);
		GL.bindBuffer (GL.ARRAY_BUFFER, __glBuffer);
		GL.bufferData (GL.ARRAY_BUFFER, array, __bufferUsage);
		
	}
	
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		var offset = startVertex * __data32PerVertex;
		var length = numVertices * __data32PerVertex;
		
		var array = new Float32Array (data, offset, length);
		GL.bindBuffer (GL.ARRAY_BUFFER, __glBuffer);
		GL.bufferData (GL.ARRAY_BUFFER, array, __bufferUsage);
		
	}
	
	
}