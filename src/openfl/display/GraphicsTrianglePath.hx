package openfl.display;


import openfl.display.IGraphicsData;
import openfl.Vector;


@:final class GraphicsTrianglePath implements IGraphicsData implements IGraphicsPath {
	
	
	public var culling:TriangleCulling;
	public var indices:Vector<Int>;
	public var uvtData:Vector<Float>;
	public var vertices:Vector<Float>;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	
	
	public function new (vertices:Vector<Float> = null, indices:Vector<Int> = null, uvtData:Vector<Float> = null, culling:TriangleCulling = NONE) {
		
		this.vertices = vertices;
		this.indices = indices;
		this.uvtData = uvtData;
		this.culling = culling;
		__graphicsDataType = TRIANGLE_PATH;
		
	}
	
	
}