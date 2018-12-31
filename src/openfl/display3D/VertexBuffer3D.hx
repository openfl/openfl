package openfl.display3D; #if !flash


import haxe.io.Bytes;
import openfl.utils.ByteArray;
import openfl.Vector;

#if lime
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)


class VertexBuffer3D {
	
	
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __data:Vector<Float>;
	@:noCompletion private var __id:#if lime GLBuffer #else Dynamic #end;
	@:noCompletion private var __memoryUsage:Int;
	@:noCompletion private var __numVertices:Int;
	@:noCompletion private var __stride:Int;
	@:noCompletion private var __tempFloat32Array:#if lime Float32Array #else Dynamic #end;
	@:noCompletion private var __usage:Int;
	@:noCompletion private var __vertexSize:Int;
	
	
	@:noCompletion private function new (context3D:Context3D, numVertices:Int, dataPerVertex:Int, bufferUsage:String) {
		
		__context = context3D;
		__numVertices = numVertices;
		__vertexSize = dataPerVertex;
		
		var gl = __context.gl;
		
		__id = gl.createBuffer ();
		__stride = __vertexSize * 4;
		__usage = (bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? gl.DYNAMIC_DRAW : gl.STATIC_DRAW;
		
	}
	
	
	public function dispose ():Void {
		
		var gl = __context.gl;
		gl.deleteBuffer (__id);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void {
		
		#if lime
		var offset = byteArrayOffset + startVertex * __stride;
		var length = numVertices * __vertexSize;
		
		uploadFromTypedArray (new Float32Array (data, offset, length));
		#end
		
	}
	
	
	public function uploadFromTypedArray (data:#if lime ArrayBufferView #else Dynamic #end, byteLength:Int = -1):Void {
		
		if (data == null) return;
		var gl = __context.gl;
		
		__context.__bindGLArrayBuffer (__id);
		gl.bufferData (gl.ARRAY_BUFFER, data, __usage);
		
	}
	
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		#if lime
		if (data == null) return;
		var gl = __context.gl;
		
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
		#end
		
	}
	
	
}


#else
typedef VertexBuffer3D = flash.display3D.VertexBuffer3D;
#end