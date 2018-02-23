package openfl.display;


import openfl.display.IGraphicsData;
import openfl.Vector;


@:final class GraphicsTilePath implements IGraphicsData implements IGraphicsPath {
	
	
	public var attributeOptions:UInt;
	public var attributes:Vector<Float>;
	public var rectIDs:Vector<Int>;
	public var sourceRects:Vector<Float>;
	public var transforms:Vector<Float>;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	
	
	public function new (transforms:Vector<Float> = null, sourceRects:Vector<Float> = null, rectIDs:Vector<Int> = null, attributes:Vector<Float> = null, attributeOptions:UInt = 0) {
		
		this.transforms = transforms;
		this.sourceRects = sourceRects;
		this.rectIDs = rectIDs;
		this.attributes = attributes;
		this.attributeOptions = attributeOptions;
		__graphicsDataType = TILE_PATH;
		
	}
	
	
}