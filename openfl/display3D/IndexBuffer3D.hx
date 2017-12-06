package openfl.display3D;


import lime.graphics.opengl.GLBuffer;
import lime.utils.ArrayBufferView;
import lime.utils.Int16Array;
import openfl._internal.stage3D.opengl.GLIndexBuffer3D;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)


@:final class IndexBuffer3D {
	
	
	private var __context:Context3D;
	private var __elementType:Int;
	private var __id:GLBuffer;
	private var __memoryUsage:Int;
	private var __numIndices:Int;
	private var __tempInt16Array:Int16Array;
	private var __usage:Int;
	
	
	private function new (context3D:Context3D, numIndices:Int, bufferUsage:Context3DBufferUsage) {
		
		__context = context3D;
		__numIndices = numIndices;
		
		GLIndexBuffer3D.create (this, __context.__renderSession, bufferUsage);
		
	}
	
	
	public function dispose ():Void {
		
		GLIndexBuffer3D.dispose (this, __context.__renderSession);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {
		
		GLIndexBuffer3D.uploadFromByteArray (this, __context.__renderSession, data, byteArrayOffset, startOffset, count);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, byteLength: Int = -1):Void {
		
		GLIndexBuffer3D.uploadFromTypedArray (this, __context.__renderSession, data);
		
	}
	
	
	public function uploadFromVector (data:Vector<UInt>, startOffset:Int, count:Int):Void {
		
		GLIndexBuffer3D.uploadFromVector (this, __context.__renderSession, data, startOffset, count);
		
	}
	
	
}