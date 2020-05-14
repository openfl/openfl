package openfl.display3D;

import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GL;
import lime.graphics.WebGLRenderContext;
import lime.utils.ArrayBufferView;
import lime.utils.UInt16Array;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.IndexBuffer3D;
import openfl.utils.ByteArray;
import openfl.Vector;
import lime.utils.ArrayBufferView;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _IndexBuffer3D
{
	public var gl:WebGLRenderContext;
	public var glBufferID:GLBuffer;
	public var glUsage:Int;
	public var memoryUsage:Int;
	public var tempUInt16Array:UInt16Array;

	public var __bufferUsage:Context3DBufferUsage;
	public var __context:Context3D;
	public var __numIndices:Int;

	private var indexBuffer3D:IndexBuffer3D;

	public function new(indexBuffer3D:IndexBuffer3D, context3D:Context3D, numIndices:Int, bufferUsage:Context3DBufferUsage)
	{
		this.indexBuffer3D = indexBuffer3D;

		__context = context3D;
		__numIndices = numIndices;
		__bufferUsage = bufferUsage;

		gl = (__context._ : _Context3D).gl;
		glBufferID = gl.createBuffer();

		glUsage = (__bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;
	}

	public function dispose():Void
	{
		gl.deleteBuffer(glBufferID);
	}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startOffset:Int, count:Int):Void
	{
		var offset = byteArrayOffset + startOffset * 2;
		uploadFromTypedArray(new UInt16Array(data.toArrayBuffer(), offset, count));
	}

	public function uploadFromTypedArray(data:ArrayBufferView, byteLength:Int = -1):Void
	{
		if (data == null) return;
		(__context._ : _Context3D).bindGLElementArrayBuffer(glBufferID);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, data, glUsage);
	}

	public function uploadFromVector(data:Vector<UInt>, startOffset:Int, count:Int):Void
	{
		// TODO: Optimize more

		if (data == null) return;

		var length = startOffset + count;
		var existingUInt16Array = tempUInt16Array;

		if (tempUInt16Array == null || tempUInt16Array.length < count)
		{
			tempUInt16Array = new UInt16Array(count);

			if (existingUInt16Array != null)
			{
				tempUInt16Array.set(existingUInt16Array);
			}
		}

		for (i in startOffset...length)
		{
			tempUInt16Array[i - startOffset] = data[i];
		}

		uploadFromTypedArray(tempUInt16Array);
	}
}
