package openfl.display;


import openfl.display.IGraphicsData;
import openfl.Vector;


@:final class GraphicsTilePath implements IGraphicsData implements IGraphicsPath {
	
	
	public var attributeOptions:UInt;
	public var attributes:Vector<Float>;
	public var ids:Vector<Int>;
	public var rects:Vector<Float>;
	public var transforms:Vector<Float>;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	
	
	public function new (transforms:Vector<Float> = null, rects:Vector<Float> = null, ids:Vector<Int> = null, attributes:Vector<Float> = null, attributeOptions:UInt = 0) {
		
		this.transforms = transforms;
		this.rects = rects;
		this.ids = ids;
		this.attributes = attributes;
		this.attributeOptions = attributeOptions;
		__graphicsDataType = TILE_PATH;
		
	}
	
	
}