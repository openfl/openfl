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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class VertexBuffer3D {
	
	
	private var __context:Context3D;
	private var __data:Vector<Float>;
	private var __id:GLBuffer;
	private var __memoryUsage:Int;
	private var __numVertices:Int;
	private var __stride:Int;
	private var __tempBytes:Bytes;
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
		
		var offset = byteArrayOffset + startVertex * __stride;
		var length = numVertices * __vertexSize;
		
		uploadFromTypedArray (new Float32Array (data, offset, length));
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		if (data == null) return;
		
		GL.bindBuffer (GL.ARRAY_BUFFER, __id);
		GLUtils.CheckGLError ();
		
		GL.bufferData (GL.ARRAY_BUFFER, data.byteLength, data, __usage);
		GLUtils.CheckGLError ();
		
		if (data.byteLength != __memoryUsage) {
			
			__context.__statsAdd (Context3D.Context3DTelemetry.MEM_VERTEX_BUFFER, data.byteLength - __memoryUsage);
			__memoryUsage = data.byteLength;
			
		}
		
	}
	
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		if (data == null) return;
		
		// TODO: Optimize more
		
		var start = startVertex * __vertexSize;
		var count = numVertices * __vertexSize;
		var length = start + count;
		
		#if (js && html5)
		
		var buffer = new Float32Array (count);
		
		for (i in start...length) {
			
			buffer[i - start] = data[i];
			
		}
		
		uploadFromTypedArray (buffer);
		
		#else
		
		var byteLength = length * 4;
		
		if (__tempBytes == null || __tempBytes.length < byteLength) {
			
			__tempBytes = Bytes.alloc (byteLength);
			
		}
		
		for (i in start...length) {
			
			__tempBytes.setFloat ((i - start) * 4, data[i]);
			
		}
		
		GL.bindBuffer (GL.ARRAY_BUFFER, __id);
		GLUtils.CheckGLError ();
		
		GL.bufferData (GL.ARRAY_BUFFER, byteLength, __tempBytes, __usage);
		GLUtils.CheckGLError ();
		
		if (byteLength != __memoryUsage) {
			
			__context.__statsAdd (Context3D.Context3DTelemetry.MEM_VERTEX_BUFFER, byteLength - __memoryUsage);
			__memoryUsage = byteLength;
			
		}
		
		#end
		
	}
	
	
}