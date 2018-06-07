package openfl.display3D;


import haxe.io.Bytes;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import openfl._internal.stage3D.opengl.GLVertexBuffer3D;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)


class VertexBuffer3D {
	
	
	private var __context:Context3D;
	private var __data:Vector<Float>;
	private var __id:GLBuffer;
	private var __memoryUsage:Int;
	private var __numVertices:Int;
	private var __stride:Int;
	private var __tempFloat32Array:Float32Array;
	private var __usage:Int;
	private var __vertexSize:Int;
	
	
	private function new (context3D:Context3D, numVertices:Int, dataPerVertex:Int, bufferUsage:String) {
		
		__context = context3D;
		__numVertices = numVertices;
		__vertexSize = dataPerVertex;
		
		GLVertexBuffer3D.create (this, cast __context.__renderer, bufferUsage);
		
	}
	
	
	public function dispose ():Void {
		
		GLVertexBuffer3D.dispose (this, cast __context.__renderer);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void {
		
		GLVertexBuffer3D.uploadFromByteArray (this, cast __context.__renderer, data, byteArrayOffset, startVertex, numVertices);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, byteLength: Int = -1):Void {
		
		GLVertexBuffer3D.uploadFromTypedArray (this, cast __context.__renderer, data);
		
	}
	
	
	public function uploadFromVector (data:Vector<Float>, startVertex:Int, numVertices:Int):Void {
		
		GLVertexBuffer3D.uploadFromVector (this, cast __context.__renderer, data, startVertex, numVertices);
		
	}
	
	
}