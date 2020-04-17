package openfl.display3D;

#if openfl_gl
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GL;
import lime.graphics.WebGLRenderContext;
import lime.utils.ArrayBufferView;
import lime.utils.UInt16Array;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.IndexBuffer3D;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D._IndexBuffer3D)
@:access(openfl.display.Stage)
@:noCompletion
class _IndexBuffer3D
{
	private var gl:WebGLRenderContext;
	private var glBufferID:GLBuffer;
	private var glUsage:Int;
	private var memoryUsage:Int;
	private var parent:IndexBuffer3D;
	private var tempUInt16Array:UInt16Array;

	public function new(parent:IndexBuffer3D)
	{
		this.parent = parent;

		gl = parent.__context._.gl;
		glBufferID = gl.createBuffer();

		glUsage = (parent.__bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;
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
		parent.__context._.bindGLElementArrayBuffer(glBufferID);
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
#end
