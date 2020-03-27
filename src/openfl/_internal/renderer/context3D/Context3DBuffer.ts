namespace openfl._internal.renderer.context3D;

#if openfl_gl
import openfl._internal.bindings.typedarray.Float32Array;
import openfl._internal.bindings.typedarray.UInt16Array;
import Context3D from "../display3D/Context3D";
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;

@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DBuffer
{
	private static readonly MAX_INDEX_BUFFER_LENGTH: number = 0xFFFF;
	private static readonly MAX_QUADS_PER_INDEX_BUFFER: number = 0x2AAA;
	private static readonly MAX_QUAD_INDEX_BUFFER_LENGTH: number = 0xFFFC;

	public dataPerVertex: number;
	public elementCount: number;
	public elementType: Context3DElementType;
	public indexBufferData: Array<UInt16Array>;
	public indexBuffers: Array<IndexBuffer3D>;
	public indexCount: number;
	public vertexBuffer: VertexBuffer3D;
	public vertexBufferData: Float32Array;
	public vertexCount: number;

	private context3D: Context3D;

	public constructor(context3D: Context3D, elementType: Context3DElementType, elementCount: number, dataPerVertex: number)
	{
		this.context3D = context3D;
		this.elementType = elementType;
		this.dataPerVertex = dataPerVertex;

		indexCount = 0;
		vertexCount = 0;

		resize(elementCount);
	}

	public drawElements(start: number, length: number = -1): void
	{
		if (indexCount == 0 || vertexCount == 0) return;

		switch (elementType)
		{
			case QUADS:
				if (length == -1) length = (elementCount * 2);

				if (start < MAX_QUADS_PER_INDEX_BUFFER && length - start < MAX_QUADS_PER_INDEX_BUFFER)
				{
					context3D.drawTriangles(indexBuffers[0], start, length * 2);
				}
				else
				{
					var end = start + length;

					while (start < end)
					{
						var arrayBufferIndex = Math.floor(start / MAX_QUADS_PER_INDEX_BUFFER);

						length = Std.int(Math.min(end - start, MAX_QUADS_PER_INDEX_BUFFER));
						if (length <= 0) break;

						// TODO: Need to advance all vertex buffer bindings past start of 0xFFFF

						context3D.drawTriangles(indexBuffers[arrayBufferIndex], (start - (arrayBufferIndex * MAX_QUADS_PER_INDEX_BUFFER)) * 3, length * 2);
						start += length;
					}
				}

			default:
		}
	}

	public flushVertexBufferData(): void
	{
		if (vertexBufferData.length > vertexCount)
		{
			vertexCount = vertexBufferData.length;
			vertexBuffer = context3D.createVertexBuffer(vertexCount, dataPerVertex, DYNAMIC_DRAW);
		}

		vertexBuffer.uploadFromTypedArray(vertexBufferData);
	}

	public resize(elementCount: number, dataPerVertex: number = -1): void
	{
		this.elementCount = elementCount;

		if (dataPerVertex == -1) dataPerVertex = this.dataPerVertex;

		if (dataPerVertex != this.dataPerVertex)
		{
			vertexBuffer = null;
			vertexCount = 0;

			this.dataPerVertex = dataPerVertex;
		}

		var numVertices = 0;

		switch (elementType)
		{
			case QUADS:
				numVertices = elementCount * 4;

			case TRIANGLES:
				numVertices = elementCount * 3;

			case TRIANGLE_INDICES:
				// TODO: Different index/triangle buffer lengths
				numVertices = elementCount * 3;

			default:
		}

		var vertexLength = numVertices * dataPerVertex;

		if (vertexBufferData == null)
		{
			vertexBufferData = new Float32Array(vertexLength);
		}
		else if (vertexLength > vertexBufferData.length)
		{
			var cacheBufferData = vertexBufferData;
			vertexBufferData = new Float32Array(vertexLength);
			vertexBufferData.set(cacheBufferData);
		}
	}
}

enum Context3DElementType
{
	QUADS;
	TRIANGLES;
	TRIANGLE_INDICES;
}
#end
