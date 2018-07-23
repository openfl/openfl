package openfl.display3D; #if !flash


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
	
	
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __elementType:Int;
	@:noCompletion private var __id:GLBuffer;
	@:noCompletion private var __memoryUsage:Int;
	@:noCompletion private var __numIndices:Int;
	@:noCompletion private var __tempInt16Array:Int16Array;
	@:noCompletion private var __usage:Int;
	
	
	@:noCompletion private function new (context3D:Context3D, numIndices:Int, bufferUsage:Context3DBufferUsage) {
		
		__context = context3D;
		__numIndices = numIndices;
		
		GLIndexBuffer3D.create (this, cast __context.__renderer, bufferUsage);
		
	}
	
	
	public function dispose ():Void {
		
		GLIndexBuffer3D.dispose (this, cast __context.__renderer);
		
	}
	
	
	public function uploadFromByteArray (data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void {
		
		GLIndexBuffer3D.uploadFromByteArray (this, cast __context.__renderer, data, byteArrayOffset, startOffset, count);
		
	}
	
	
	public function uploadFromTypedArray (data:ArrayBufferView, byteLength: Int = -1):Void {
		
		GLIndexBuffer3D.uploadFromTypedArray (this, cast __context.__renderer, data);
		
	}
	
	
	public function uploadFromVector (data:Vector<UInt>, startOffset:Int, count:Int):Void {
		
		GLIndexBuffer3D.uploadFromVector (this, cast __context.__renderer, data, startOffset, count);
		
	}
	
	
}


#else
typedef IndexBuffer3D = flash.display3D.IndexBuffer3D;
#end