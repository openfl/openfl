package openfl.display;


import openfl.display.IGraphicsData;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class GraphicsQuadPath implements IGraphicsData implements IGraphicsPath {
	
	
	public var indices:Vector<Int>;
	public var rects:Vector<Float>;
	public var transforms:Vector<Float>;
	
	#if !flash
	public var __graphicsDataType (default, null):GraphicsDataType;
	#end
	
	
	public function new (rects:Vector<Float> = null, indices:Vector<Int> = null, transforms:Vector<Float> = null) {
		
		this.rects = rects;
		this.indices = indices;
		this.transforms = transforms;
		
		#if !flash
		__graphicsDataType = QUAD_PATH;
		#end
		
	}
	
	
}