package openfl.display3D;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.Int16Array;
import openfl._internal.stage3D.GLUtils;
import openfl.errors.RangeError;
import openfl.utils.ByteArray;
import openfl.Vector;


@:final class IndexBuffer3D {
	
	
	private var __context:Context3D;
	private var __elementType:Int;
	private var __id:GLBuffer;
	private var __memoryUsage:Int;
	private var __numIndices:Int;
	private var __usage:Int;
	
	
	private function new (context3D:Context3D, numIndices:Int, bufferUsage:String) {
		
		__context = context3D;
		__numIndices = numIndices;
		__elementType = GL.UNSIGNED_SHORT;
		
		__id = GL.createBuffer ();
		GLUtils.CheckGLError ();
		
		__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;
		
		__context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_INDEX_BUFFER);
		__memoryUsage = 0;
		
	}
	
	
	public function dispose ():Void {
		
		GL.deleteBuffer (__id);
		
		__context.__statsDecrement(Context3D.Context3DTelemetry.COUNT_INDEX_BUFFER);
		__context.__statsSubtract(Context3D.Context3DTelemetry.MEM_INDEX_BUFFER, __memoryUsage);
		__memoryUsage = 0;
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {
		
		var offset = byteArrayOffset + startOffset * 2;
		
		uploadFromTypedArray (new Int16Array (data.toArrayBuffer (), offset, count));
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView):Void {
		
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, __id);
		GLUtils.CheckGLError ();
		
		GL.bufferData (GL.ELEMENT_ARRAY_BUFFER, data, __usage);
		GLUtils.CheckGLError ();
		
		if (data.byteLength != __memoryUsage) {
			
			__context.__statsAdd (Context3D.Context3DTelemetry.MEM_INDEX_BUFFER, data.byteLength - __memoryUsage);
			__memoryUsage = data.byteLength;
			
		}
		
	}
	
	
	public function uploadFromVector (data:Vector<UInt>, startOffset:Int, count:Int):Void {
		
		// TODO: Optimize more
		
		var length = startOffset + count;
		var buffer = new Int16Array (count);
		
		for (i in startOffset...length) {
			
			buffer[i - startOffset] = data[i];
			
		}
		
		uploadFromTypedArray (buffer);
		
	}
	
	
}