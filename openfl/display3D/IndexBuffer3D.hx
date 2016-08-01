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
	
	
	private static var __shortData:Int16Array;
	
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
		
		__elementType = GL.UNSIGNED_SHORT;
		
		var ba:ByteArray = new ByteArray ();
		data.readBytes (ba, byteArrayOffset);
		var sData = new Int16Array (ba.length, ba.toArrayBuffer ());
		
		uploadFromTypedArray (sData, Std.int (data.length - byteArrayOffset), startOffset, count);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, dataLength:Int, startOffset:Int, count:Int):Void {
		
		var elementSize:Int = 2;
		var byteCount:Int = count * elementSize;
		
		if (byteCount > dataLength) {
			
			throw new RangeError ("data buffer is not big enough for upload");
			
		}
		
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, __id);
		GLUtils.CheckGLError ();
		
		if (startOffset == 0) {
			
			GL.bufferData (GL.ELEMENT_ARRAY_BUFFER, data, __usage);
			GLUtils.CheckGLError ();
			
			if (byteCount != __memoryUsage) {
				
				__context.__statsAdd (Context3D.Context3DTelemetry.MEM_INDEX_BUFFER, byteCount - __memoryUsage);
				__memoryUsage = byteCount;
				
			}
			
		} else {
			
			GL.bufferSubData (GL.ELEMENT_ARRAY_BUFFER, startOffset * elementSize, data);
			GLUtils.CheckGLError ();
			
		}
		
	}
	
	
	public function uploadFromVector (data:Vector<UInt>, startOffset:Int, count:Int):Void {
		
		__elementType = GL.UNSIGNED_SHORT;
		var length:Int = data.length;
		
		if ((__shortData == null) || (__shortData.length < length)) {
			
			__shortData = new Int16Array (Std.int (data.length * 1.2));
			
		}
		
		for (i in 0...length) {
			
			__shortData[i] = data[i];
			
		}
		
		uploadFromTypedArray (__shortData, length * 2, startOffset, count);
		
	}
	
	
}