package openfl.display3D;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import openfl._internal.stage3D.GLUtils;
import openfl.errors.RangeError;
import openfl.utils.ByteArray;
import openfl.Vector;
import haxe.io.Bytes;


class VertexBuffer3D {
	
	
	private var __context:Context3D;
	private var __data:Vector<Float>;
	private var __id:GLBuffer;
	private var __memoryUsage:Int;
	private var __numVertices:Int;
	private var __stride:Int;
	private var __usage:Int;
	private var __vertexSize:Int;
	
	
	private function new (context3D:Context3D, numVertices:Int, dataPerVertex:Int, bufferUsage:String) {
		
		__context = context3D;
		__numVertices = numVertices;
		__vertexSize = dataPerVertex;
		
		__id = GL.createBuffer ();
		GLUtils.CheckGLError ();
		
		__stride = __vertexSize * 4;
		__memoryUsage = 0;
		
		__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;
		
		__context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_VERTEX_BUFFER);
		
	}
	
	
	public function dispose ():Void {
		
		GL.deleteBuffer (__id);
		
		__context.__statsDecrement (Context3D.Context3DTelemetry.COUNT_VERTEX_BUFFER);
		__context.__statsSubtract (Context3D.Context3DTelemetry.MEM_VERTEX_BUFFER, __memoryUsage);
		__memoryUsage = 0;
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void {
		
		// TODO: prevent copy
		
		data.position = 0;
		var ptr:Bytes = Bytes.alloc (data.length - byteArrayOffset);
		
		data.position = byteArrayOffset;
		var i = 0;
		while (data.bytesAvailable > 0) {
			
			ptr.set(i++, data.readByte ());
			
		}
		
		uploadFromTypedArray (ptr, (data.length - byteArrayOffset), startVertex, numVertices);
		
	}
	
	
	// TODO: Must be a better way to handle buffer uploading. Copying and
	// transcoding data back and forth. Not good.
	
	public function uploadFromTypedArray (data:Bytes, dataLength:Int, startVertex:Int, numVertices:Int):Void {
		
		GL.bindBuffer (GL.ARRAY_BUFFER, __id);
		
		var byteStart = startVertex * __vertexSize * 4;
		var byteCount = numVertices * __vertexSize * 4;
		var dataView = Float32Array.fromBytes (data, 0, Std.int (byteCount / 4));
		
		if (byteCount > dataLength) {
			
			throw new RangeError ("data buffer is not big enough for upload");
			
		}
		
		if (byteStart == 0) {
			
			GL.bufferData (GL.ARRAY_BUFFER, dataView, __usage);
			
			if (byteCount != __memoryUsage) {
				
				__context.__statsAdd (Context3D.Context3DTelemetry.MEM_VERTEX_BUFFER, byteCount - __memoryUsage);
				__memoryUsage = byteCount;
				
			}
			
		} else {
			
			GL.bufferSubData (GL.ARRAY_BUFFER, byteStart, dataView);
			
		}
		
	}
	
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		// TODO: prevent copy
		
		var bytes = Bytes.alloc (data.length * 4);
		
		for (i in 0...data.length) {
			
			bytes.setFloat (i * 4, data[i]);
			
		}
		
		uploadFromTypedArray (bytes, data.length * 4, startVertex, numVertices);
		
	}
	
	
}