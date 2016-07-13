package openfl.display3D;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import openfl.utils.ByteArray;
import openfl.Vector;

@:access(openfl.display3D.Context3D)


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
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void {
		
		var bytesPerVertex = __data32PerVertex * 4;
		var offset = byteArrayOffset + startVertex * bytesPerVertex;
		var length = numVertices * __data32PerVertex;
		
		uploadFromTypedArray (new Float32Array (data, offset, length));
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		GL.bindBuffer (GL.ARRAY_BUFFER, __glBuffer);
		GL.bufferData (GL.ARRAY_BUFFER, data, __bufferUsage);
		
	}
	
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		var bytesPerVertex = __data32PerVertex * 4;
		var offset = startVertex * bytesPerVertex;
		var length = numVertices * __data32PerVertex;
		
		uploadFromTypedArray (new Float32Array (data, offset, length));
		
	}
	
	
}