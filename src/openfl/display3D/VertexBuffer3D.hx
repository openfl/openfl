package openfl.display3D; #if !flash


import haxe.io.Bytes;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)


class VertexBuffer3D {
	
	
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __data:Vector<Float>;
	@:noCompletion private var __id:GLBuffer;
	@:noCompletion private var __memoryUsage:Int;
	@:noCompletion private var __numVertices:Int;
	@:noCompletion private var __stride:Int;
	@:noCompletion private var __tempFloat32Array:Float32Array;
	@:noCompletion private var __usage:Int;
	@:noCompletion private var __vertexSize:Int;
	
	
	@:noCompletion private function new (context3D:Context3D, numVertices:Int, dataPerVertex:Int, bufferUsage:String) {
		
		__context = context3D;
		__numVertices = numVertices;
		__vertexSize = dataPerVertex;
		
		var gl = __context.__gl;
		
		__id = gl.createBuffer ();
		// GLUtils.CheckGLError ();
		
		__stride = __vertexSize * 4;
		
		// __memoryUsage = 0;
		
		__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? gl.DYNAMIC_DRAW : gl.STATIC_DRAW;
		
		// __context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_VERTEX_BUFFER);
		
	}
	
	
	public function dispose ():Void {
		
		var gl = __context.__gl;
		
		gl.deleteBuffer (__id);
		
		// __context.__statsDecrement (Context3D.Context3DTelemetry.COUNT_VERTEX_BUFFER);
		// __context.__statsSubtract (Context3D.Context3DTelemetry.MEM_VERTEX_BUFFER, __memoryUsage);
		// __memoryUsage = 0;
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void {
		
		var offset = byteArrayOffset + startVertex * __stride;
		var length = numVertices * __vertexSize;
		
		uploadFromTypedArray (new Float32Array (data, offset, length));
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, byteLength:Int = -1):Void {
		
		if (data == null) return;
		var gl = __context.__gl;
		
		__context.__bindBuffer (gl.ARRAY_BUFFER, __id);
		// GLUtils.CheckGLError ();
		
		gl.bufferData (gl.ARRAY_BUFFER, data, __usage);
		// GLUtils.CheckGLError ();
		
		// if (data.byteLength != __memoryUsage) {
			
		// 	__context.__statsAdd (Context3D.Context3DTelemetry.MEM_VERTEX_BUFFER, data.byteLength - __memoryUsage);
		// 	__memoryUsage = data.byteLength;
			
		// }
		
	}
	
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		if (data == null) return;
		var gl = __context.__gl;
		
		// TODO: Optimize more
		
		var start = startVertex * __vertexSize;
		var count = numVertices * __vertexSize;
		var length = start + count;
		
		var existingFloat32Array = __tempFloat32Array;
		
		if (__tempFloat32Array == null || __tempFloat32Array.length < count) {
			
			__tempFloat32Array = new Float32Array (count);
			
			if (existingFloat32Array != null) {
				
				__tempFloat32Array.set (existingFloat32Array);
				
			}
			
		}
		
		for (i in start...length) {
			
			__tempFloat32Array[i - start] = data[i];
			
		}
		
		uploadFromTypedArray (__tempFloat32Array);
		
	}
	
	
}


#else
typedef VertexBuffer3D = flash.display3D.VertexBuffer3D;
#end