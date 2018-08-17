package openfl._internal.renderer.opengl;


import haxe.io.Bytes;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import openfl._internal.renderer.opengl.GLUtils;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.Context3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.OpenGLRenderer;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl.display.DisplayObjectRenderer)


class GLVertexBuffer3D {
	
	
	public static function create (vertexBuffer:VertexBuffer3D, bufferUsage:Context3DBufferUsage) {
		
		var context = vertexBuffer.__context;
		var gl = context.__gl;
		
		vertexBuffer.__id = gl.createBuffer ();
		GLUtils.CheckGLError ();
		
		vertexBuffer.__stride = vertexBuffer.__vertexSize * 4;
		// __memoryUsage = 0;
		
		vertexBuffer.__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? gl.DYNAMIC_DRAW : gl.STATIC_DRAW;
		
		// __context.__statsIncrement (Context3D.Context3DTelemetry.COUNT_VERTEX_BUFFER);
		
	}
	
	
	public static function dispose (vertexBuffer:VertexBuffer3D):Void {
		
		var context = vertexBuffer.__context;
		var gl = context.__gl;
		
		gl.deleteBuffer (vertexBuffer.__id);
		
		// __context.__statsDecrement (Context3D.Context3DTelemetry.COUNT_VERTEX_BUFFER);
		// __context.__statsSubtract (Context3D.Context3DTelemetry.MEM_VERTEX_BUFFER, __memoryUsage);
		// __memoryUsage = 0;
		
	}
	
	
	public static function uploadFromByteArray (vertexBuffer:VertexBuffer3D, data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void {
		
		var offset = byteArrayOffset + startVertex * vertexBuffer.__stride;
		var length = numVertices * vertexBuffer.__vertexSize;
		
		uploadFromTypedArray (vertexBuffer, new Float32Array (data, offset, length));
		
	}
	
	
	public static function uploadFromTypedArray (vertexBuffer:VertexBuffer3D, data:ArrayBufferView):Void {
		
		if (data == null) return;
		var context = vertexBuffer.__context;
		var gl = context.__gl;
		
		context.__bindBuffer (gl.ARRAY_BUFFER, vertexBuffer.__id);
		GLUtils.CheckGLError ();
		
		gl.bufferData (gl.ARRAY_BUFFER, data, vertexBuffer.__usage);
		GLUtils.CheckGLError ();
		
		// if (data.byteLength != __memoryUsage) {
			
		// 	__context.__statsAdd (Context3D.Context3DTelemetry.MEM_VERTEX_BUFFER, data.byteLength - __memoryUsage);
		// 	__memoryUsage = data.byteLength;
			
		// }
		
	}
	
	
	public static function uploadFromVector (vertexBuffer:VertexBuffer3D, data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		if (data == null) return;
		var context = vertexBuffer.__context;
		var gl = context.__gl;
		
		// TODO: Optimize more
		
		var start = startVertex * vertexBuffer.__vertexSize;
		var count = numVertices * vertexBuffer.__vertexSize;
		var length = start + count;
		
		var existingFloat32Array = vertexBuffer.__tempFloat32Array;
		
		if (vertexBuffer.__tempFloat32Array == null || vertexBuffer.__tempFloat32Array.length < count) {
			
			vertexBuffer.__tempFloat32Array = new Float32Array (count);
			
			if (existingFloat32Array != null) {
				
				vertexBuffer.__tempFloat32Array.set (existingFloat32Array);
				
			}
			
		}
		
		for (i in start...length) {
			
			vertexBuffer.__tempFloat32Array[i - start] = data[i];
			
		}
		
		uploadFromTypedArray (vertexBuffer, vertexBuffer.__tempFloat32Array);
		
	}
	
	
}