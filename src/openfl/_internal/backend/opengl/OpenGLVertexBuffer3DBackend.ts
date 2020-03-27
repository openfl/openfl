namespace openfl._internal.backend.opengl;

#if openfl_gl
import openfl._internal.bindings.gl.GLBuffer;
import openfl._internal.bindings.gl.GL;
import openfl._internal.bindings.gl.WebGLRenderingContext;
import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl._internal.bindings.typedarray.Float32Array;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.VertexBuffer3D;
import ByteArray from "../utils/ByteArray";
import Vector from "../Vector";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl._internal.backend.opengl)
@: access(openfl.display3D.Context3D)
@: access(openfl.display3D.VertexBuffer3D)
@: access(openfl.display.Stage)
class OpenGLVertexBuffer3DBackend
{
	private data: Vector<number>;
	private gl: WebGLRenderingContext;
	private glBufferID: GLBuffer;
	private glUsage: number;
	// private memoryUsage:Int;
	private parent: VertexBuffer3D;
	private stride: number;
	private tempFloat32Array: Float32Array;

	public constructor(parent: VertexBuffer3D)
	{
		this.parent = parent;
		gl = parent.__context.__backend.gl;

		glBufferID = gl.createBuffer();
		stride = parent.__dataPerVertex * 4;
		glUsage = (parent.__bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;
	}

	public dispose(): void
	{
		gl.deleteBuffer(glBufferID);
	}

	public uploadFromByteArray(data: ByteArray, byteArrayOffset: number, startVertex: number, numVertices: number): void
	{
		var offset = byteArrayOffset + startVertex * stride;
		var length = numVertices * parent.__dataPerVertex;

		uploadFromTypedArray(new Float32Array(data, offset, length));
	}

	public uploadFromTypedArray(data: ArrayBufferView, byteLength: number = -1): void
	{
		if (data == null) return;

		parent.__context.__backend.bindGLArrayBuffer(glBufferID);
		gl.bufferData(GL.ARRAY_BUFFER, data, glUsage);
	}

	public uploadFromVector(data: Vector<number>, startVertex: number, numVertices: number): void
	{
		if (data == null) return;

		// TODO: Optimize more

		var start = startVertex * parent.__dataPerVertex;
		var count = numVertices * parent.__dataPerVertex;
		var length = start + count;

		var existingFloat32Array = tempFloat32Array;

		if (tempFloat32Array == null || tempFloat32Array.length < count)
		{
			tempFloat32Array = new Float32Array(count);

			if (existingFloat32Array != null)
			{
				tempFloat32Array.set(existingFloat32Array);
			}
		}

		for (i in start...length)
		{
			tempFloat32Array[i - start] = data[i];
		}

		uploadFromTypedArray(tempFloat32Array);
	}
}
#end
