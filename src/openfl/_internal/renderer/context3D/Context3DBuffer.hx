package openfl._internal.renderer.context3D;


import lime.utils.Float32Array;
import lime.utils.Int16Array;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;


class Context3DBuffer {
	
	
	private static inline var MAX_INDEX_BUFFER_LENGTH = 0xFFFF;
	private static inline var MAX_QUADS_PER_INDEX_BUFFER = 0x2AAA;
	private static inline var MAX_QUAD_INDEX_BUFFER_LENGTH = 0xFFFC;
	
	public var dataPerVertex:Int;
	public var elementCount:Int;
	public var elementType:Context3DElementType;
	public var indexBufferData:Array<Int16Array>;
	public var indexBuffers:Array<IndexBuffer3D>;
	public var indexCount:Int;
	public var vertexBuffer:VertexBuffer3D;
	public var vertexBufferData:Float32Array;
	public var vertexCount:Int;
	
	private var context3D:Context3D;
	
	
	public function new (context3D:Context3D, elementType:Context3DElementType, elementCount:Int, dataPerVertex:Int) {
		
		this.context3D = context3D;
		this.elementType = elementType;
		this.dataPerVertex = dataPerVertex;
		
		indexCount = 0;
		vertexCount = 0;
		
		resize (elementCount);
		
	}
	
	
	public function drawElements (start:Int, length:Int = -1):Void {
		
		if (indexCount == 0 || vertexCount == 0) return;
		
		switch (elementType) {
			
			case QUADS:
				
				if (length == -1) length = (elementCount * 2);
				
				if (false && start < MAX_QUADS_PER_INDEX_BUFFER && length - start < MAX_QUADS_PER_INDEX_BUFFER) {
					
					context3D.drawTriangles (indexBuffers[0], start * 2, length * 2);
					
				} else {
					
					var end = start + length;
					
					while (start < end) {
						
						var arrayBufferIndex = Math.floor (start / MAX_QUADS_PER_INDEX_BUFFER);
						
						length = Std.int (Math.min (end - start, MAX_QUADS_PER_INDEX_BUFFER));
						if (length <= 0) break;
						
						context3D.drawTriangles (indexBuffers[arrayBufferIndex], (start - (arrayBufferIndex * MAX_QUADS_PER_INDEX_BUFFER)) * 2, length * 2);
						start += length;
						
					}
					
				}
			
			default:
			
		}
		
	}
	
	
	public function flushVertexBufferData ():Void {
		
		if (vertexBufferData.length > vertexCount) {
			
			vertexBuffer = context3D.createVertexBuffer (vertexCount, dataPerVertex, DYNAMIC_DRAW);
			vertexCount = vertexBufferData.length;
			
		}
		
		vertexBuffer.uploadFromTypedArray (vertexBufferData);
		
	}
	
	
	public function resize (elementCount:Int, dataPerVertex:Int = -1):Void {
		
		this.elementCount = elementCount;
		
		if (dataPerVertex == -1) dataPerVertex = this.dataPerVertex;
		
		if (dataPerVertex != this.dataPerVertex) {
			
			vertexBuffer = null;
			vertexCount = 0;
			
			this.dataPerVertex = dataPerVertex;
			
		}
		
		var numVertices = 0;
		
		switch (elementType) {
			
			case QUADS:
				
				while (indexCount < elementCount * 6) {
					
					__createQuadIndexBuffer ();
					
				}
				
				numVertices = elementCount * 4;
			
			case TRIANGLES:
				
				numVertices = elementCount * 6;
			
			case TRIANGLE_INDICES:
				
				// TODO: Different index/triangle buffer lengths
				numVertices = elementCount * 6;
			
			default:
			
		}
		
		var vertexLength = numVertices * dataPerVertex;
		
		if (vertexBufferData == null) {
			
			vertexBufferData = new Float32Array (vertexLength);
			
		} else if (vertexLength > vertexBufferData.length) {
			
			vertexBufferData = new Float32Array (vertexLength);
			vertexBufferData.set (vertexBufferData);
			
		}
		
	}
	
	
	private function __createQuadIndexBuffer ():Void {
		
		var indexData = new Int16Array (MAX_QUAD_INDEX_BUFFER_LENGTH);
		var vertexIndex = Std.int (indexCount * (4 / 6));
		var indexPosition = 0;
		
		while (indexPosition < MAX_QUAD_INDEX_BUFFER_LENGTH) {
			
			indexData[indexPosition] = vertexIndex;
			indexData[indexPosition + 1] = vertexIndex + 1;
			indexData[indexPosition + 2] = vertexIndex + 2;
			indexData[indexPosition + 3] = vertexIndex + 2;
			indexData[indexPosition + 4] = vertexIndex + 1;
			indexData[indexPosition + 5] = vertexIndex + 3;
			indexPosition += 6;
			vertexIndex += 4;
			
		}
		
		var indexBuffer = context3D.createIndexBuffer (MAX_QUAD_INDEX_BUFFER_LENGTH, STATIC_DRAW);
		indexBuffer.uploadFromTypedArray (indexData);
		
		if (indexBuffers == null) indexBuffers = new Array ();
		indexBuffers.push (indexBuffer);
		indexCount += MAX_QUAD_INDEX_BUFFER_LENGTH;
		
	}
	
	
}


enum Context3DElementType {
	
	QUADS;
	TRIANGLES;
	TRIANGLE_INDICES;
	
}