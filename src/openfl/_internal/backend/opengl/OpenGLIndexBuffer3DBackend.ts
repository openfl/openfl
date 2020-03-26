namespace openfl._internal.backend.opengl;

#if openfl_gl
import openfl._internal.bindings.gl.GLBuffer;
import openfl._internal.bindings.gl.GL;
import openfl._internal.bindings.gl.WebGLRenderingContext;
import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl._internal.bindings.typedarray.UInt16Array;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.IndexBuffer3D;
import ByteArray from "openfl/utils/ByteArray";
import Vector from "openfl/Vector";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl._internal.backend.opengl)
@: access(openfl.display3D.Context3D)
@: access(openfl.display3D.IndexBuffer3D)
@: access(openfl.display.Stage)
class OpenGLIndexBuffer3DBackend
{
	private gl: WebGLRenderingContext;
	private glBufferID: GLBuffer;
	private glUsage: number;
	private memoryUsage: number;
	private parent: IndexBuffer3D;
	private tempUInt16Array: number16Array;

	public new(parent: IndexBuffer3D)
	{
		this.parent = parent;

		gl = parent.__context.__backend.gl;
		glBufferID = gl.createBuffer();

		glUsage = (parent.__bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;
	}

	public dispose(): void
	{
		gl.deleteBuffer(glBufferID);
	}

	public uploadFromByteArray(data: ByteArray, byteArrayOffset: number, startOffset: number, count: number): void
	{
		var offset = byteArrayOffset + startOffset * 2;
		uploadFromTypedArray(new UInt16Array(data.toArrayBuffer(), offset, count));
	}

	public uploadFromTypedArray(data: ArrayBufferView, byteLength: number = -1): void
	{
		if (data == null) return;
		parent.__context.__backend.bindGLElementArrayBuffer(glBufferID);
		gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, data, glUsage);
	}

	public uploadFromVector(data: Vector<UInt>, startOffset: number, count: number): void
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
