package openfl.display;


import openfl.display.IGraphicsData;
import openfl.Vector;


@:final class GraphicsQuadPath implements IGraphicsData implements IGraphicsPath {
	
	
	public var matrices:Vector<Float>;
	public var rectIndices:Vector<Int>;
	public var sourceRects:Vector<Float>;
	
	#if !flash
	public var __graphicsDataType (default, null):GraphicsDataType;
	#end
	
	
	public function new (matrices:Vector<Float> = null, sourceRects:Vector<Float> = null, rectIndices:Vector<Int> = null) {
		
		this.matrices = matrices;
		this.sourceRects = sourceRects;
		this.rectIndices = rectIndices;
		
		#if !flash
		__graphicsDataType = QUAD_PATH;
		#end
		
	}
	
	
}