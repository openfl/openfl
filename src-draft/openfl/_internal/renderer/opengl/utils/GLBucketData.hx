package openfl._internal.renderer.opengl.utils;

import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl.display3D.Context3D;

@SuppressWarnings("checkstyle:FieldDocComment")
class GLBucketData
{
	public var type:BucketDataType;

	public var context3D:Context3D;
	public var drawMode:Int;
	public var glLength:Int = 0;
	public var glStart:Int = 0;

	public var vertexArray:VertexArray;
	public var glVerts:Float32Array;
	public var lastVertsSize:Int = 0;
	public var verts:Array<Float>;
	public var rawVerts:Bool = false;
	public var stride:Int = 0;

	public var indexBuffer:GLBuffer;
	public var glIndices:UInt16Array;
	public var indices:Array<Int>;
	public var rawIndices:Bool = false;

	public var available:Bool = false;

	public var parent:GLBucket;

	public function new(context3D:Context3D)
	{
		this.context3D = context3D;

		var gl = @:privateAccess context3D.__backend.gl;

		drawMode = gl.TRIANGLE_STRIP;
		verts = [];
		indices = [];
		vertexArray = new VertexArray([]);
	}

	public function reset():Void
	{
		available = true;
		verts = [];
		indices = [];
		glLength = 0;
		glStart = 0;
		stride = 0;
		rawVerts = false;
		rawIndices = false;
	}

	public function upload():Void
	{
		var gl = @:privateAccess context3D.__backend.gl;

		// only upload a verts buffer if verts has anything inside
		if ((rawVerts && glVerts != null && glVerts.length > 0) || verts.length > 0)
		{
			if (!rawVerts) glVerts = new Float32Array(verts);

			vertexArray.buffer = glVerts.buffer;

			if (glVerts.length <= lastVertsSize)
			{
				vertexArray.bind();
				var end = glLength * 4 * stride;
				if (glLength > 0 && lastVertsSize > end)
				{
					var view = glVerts.subarray(0, end);
					vertexArray.upload(view);
				}
				else
				{
					vertexArray.upload(glVerts);
				}
			}
			else
			{
				vertexArray.setContext(context3D, glVerts);
				lastVertsSize = glVerts.length;
			}
		}

		// only upload a index buffer is there is no length provided and indices has anything inside
		if (glLength == 0 && ((rawIndices && glIndices != null && glIndices.length > 0) || indices.length > 0))
		{
			if (indexBuffer == null)
			{
				indexBuffer = gl.createBuffer();
			}

			if (!rawIndices) glIndices = new UInt16Array(indices);
			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
			gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, glIndices, gl.STREAM_DRAW);
		}
	}
}
