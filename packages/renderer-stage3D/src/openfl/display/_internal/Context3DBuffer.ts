import Context3D from "../../../display3D/Context3D";
import Context3DBufferUsage from "../../../display3D/Context3DBufferUsage";
import IndexBuffer3D from "../../../display3D/IndexBuffer3D";
import VertexBuffer3D from "../../../display3D/VertexBuffer3D";

export default class Context3DBuffer
{
	private static readonly MAX_INDEX_BUFFER_LENGTH: number = 0xFFFF;
	private static readonly MAX_QUADS_PER_INDEX_BUFFER: number = 0x2AAA;
	private static readonly MAX_QUAD_INDEX_BUFFER_LENGTH: number = 0xFFFC;

	public dataPerVertex: number;
	public elementCount: number;
	public elementType: Context3DElementType;
	public indexBufferData: Array<Uint16Array>;
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

		this.indexCount = 0;
		this.vertexCount = 0;

		this.resize(elementCount);
	}

	public drawElements(start: number, length: number = -1): void
	{
		if (this.indexCount == 0 || this.vertexCount == 0) return;

		switch (this.elementType)
		{
			case Context3DElementType.QUADS:
				if (length == -1) length = (this.elementCount * 2);

				if (start < Context3DBuffer.MAX_QUADS_PER_INDEX_BUFFER && length - start < Context3DBuffer.MAX_QUADS_PER_INDEX_BUFFER)
				{
					this.context3D.drawTriangles(this.indexBuffers[0], start, length * 2);
				}
				else
				{
					var end = start + length;

					while (start < end)
					{
						var arrayBufferIndex = Math.floor(start / Context3DBuffer.MAX_QUADS_PER_INDEX_BUFFER);

						length = Math.floor(Math.min(end - start, Context3DBuffer.MAX_QUADS_PER_INDEX_BUFFER));
						if (length <= 0) break;

						// TODO: Need to advance all vertex buffer bindings past start of 0xFFFF

						this.context3D.drawTriangles(this.indexBuffers[arrayBufferIndex], (start - (arrayBufferIndex * Context3DBuffer.MAX_QUADS_PER_INDEX_BUFFER)) * 3, length * 2);
						start += length;
					}
				}
				break;

			default:
		}
	}

	public flushVertexBufferData(): void
	{
		if (this.vertexBufferData.length > this.vertexCount)
		{
			this.vertexCount = this.vertexBufferData.length;
			this.vertexBuffer = this.context3D.createVertexBuffer(this.vertexCount, this.dataPerVertex, Context3DBufferUsage.DYNAMIC_DRAW);
		}

		this.vertexBuffer.uploadFromTypedArray(this.vertexBufferData);
	}

	public resize(elementCount: number, dataPerVertex: number = -1): void
	{
		this.elementCount = elementCount;

		if (dataPerVertex == -1) dataPerVertex = this.dataPerVertex;

		if (dataPerVertex != this.dataPerVertex)
		{
			this.vertexBuffer = null;
			this.vertexCount = 0;

			this.dataPerVertex = dataPerVertex;
		}

		var numVertices = 0;

		switch (this.elementType)
		{
			case Context3DElementType.QUADS:
				numVertices = elementCount * 4;
				break;

			case Context3DElementType.TRIANGLES:
				numVertices = elementCount * 3;
				break;

			case Context3DElementType.TRIANGLE_INDICES:
				// TODO: Different index/triangle buffer lengths
				numVertices = elementCount * 3;
				break;

			default:
		}

		var vertexLength = numVertices * dataPerVertex;

		if (this.vertexBufferData == null)
		{
			this.vertexBufferData = new Float32Array(vertexLength);
		}
		else if (vertexLength > this.vertexBufferData.length)
		{
			var cacheBufferData = this.vertexBufferData;
			this.vertexBufferData = new Float32Array(vertexLength);
			this.vertexBufferData.set(cacheBufferData);
		}
	}
}

export enum Context3DElementType
{
	QUADS,
	TRIANGLES,
	TRIANGLE_INDICES,
}
