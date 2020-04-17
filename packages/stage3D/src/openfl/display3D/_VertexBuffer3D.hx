package openfl.display3D;

#if openfl_gl
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GL;
import lime.graphics.WebGLRenderContext;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.VertexBuffer3D;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl.display3D._VertexBuffer3D)
@:access(openfl.display.Stage)
@:noCompletion
class _VertexBuffer3D
{
	private var data:Vector<Float>;
	private var gl:WebGLRenderContext;
	private var glBufferID:GLBuffer;
	private var glUsage:Int;
	// private var memoryUsage:Int;
	private var parent:VertexBuffer3D;
	private var stride:Int;
	private var tempFloat32Array:Float32Array;

	public function new(parent:VertexBuffer3D)
	{
		this.parent = parent;
		gl = parent.__context._.gl;

		glBufferID = gl.createBuffer();
		stride = parent.__dataPerVertex * 4;
		glUsage = (parent.__bufferUsage == Context3DBufferUsage.DYNAMIC_DRAW) ? GL.DYNAMIC_DRAW : GL.STATIC_DRAW;
	}

	public function dispose():Void
	{
		gl.deleteBuffer(glBufferID);
	}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:Int, startVertex:Int, numVertices:Int):Void
	{
		var offset = byteArrayOffset + startVertex * stride;
		var length = numVertices * parent.__dataPerVertex;

		uploadFromTypedArray(new Float32Array(data, offset, length));
	}

	public function uploadFromTypedArray(data:ArrayBufferView, byteLength:Int = -1):Void
	{
		if (data == null) return;

		parent.__context._.bindGLArrayBuffer(glBufferID);
		gl.bufferData(GL.ARRAY_BUFFER, data, glUsage);
	}

	public function uploadFromVector(data:Vector<Float>, startVertex:Int, numVertices:Int):Void
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
