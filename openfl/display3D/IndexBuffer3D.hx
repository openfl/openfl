package openfl.display3D;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.WebGLContext;
import lime.utils.ArrayBufferView;
import lime.utils.Int16Array;
import openfl._internal.stage3D.GLUtils;
import openfl.errors.RangeError;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class IndexBuffer3D {
	
	
	private var __context:Context3D;
	private var __elementType:Int;
	private var __id:GLBuffer;
	private var __memoryUsage:Int;
	private var __tempInt16Array:Int16Array;
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
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, byteLength: Int = -1):Void {
		
		if (data == null) return;
		
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, __id);
		GLUtils.CheckGLError ();
		
		if (byteLength == -1) {
			byteLength = data.byteLength;
		}
		#if (js && html5)
		(GL:WebGLContext).bufferData (GL.ELEMENT_ARRAY_BUFFER, data, __usage);
		#else
		GL.bufferData (GL.ELEMENT_ARRAY_BUFFER, byteLength, data, __usage);
		#end
		GLUtils.CheckGLError ();
		
		if (byteLength != __memoryUsage) {
			
			__context.__statsAdd (Context3D.Context3DTelemetry.MEM_INDEX_BUFFER, byteLength - __memoryUsage);
			__memoryUsage = byteLength;
			
		}
		
	}
	
	
	public function uploadFromVector (data:Vector<UInt>, startOffset:Int, count:Int):Void {
		
		// TODO: Optimize more
		
		var length = startOffset + count;
		var byteLength = count * 2;
		
		var existingInt16Array: Int16Array = __tempInt16Array;
		
		if (__tempInt16Array == null || __tempInt16Array.length < count) {
			
			__tempInt16Array = new Int16Array(count);
			
			if (existingInt16Array != null) {
				
				__tempInt16Array.set(existingInt16Array);
				
			}
			
		}
		
		for (i in startOffset...length) {
			
			__tempInt16Array[i - startOffset] = data[i];
			
		}
		
		uploadFromTypedArray (__tempInt16Array, byteLength);
		
	}
	
	
}