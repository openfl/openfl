package openfl.display; #if (display || !flash)


import openfl.Vector;

@:jsRequire("openfl/display/GraphicsTrianglePath", "default")


@:final extern class GraphicsTrianglePath implements IGraphicsData implements IGraphicsPath {
	
	
	public var culling:TriangleCulling;
	public var indices:Vector<Int>;
	public var uvtData:Vector<Float>;
	public var vertices:Vector<Float>;
	
	public function new (vertices:Vector<Float> = null, indices:Vector<Int> = null, uvtData:Vector<Float> = null, culling:TriangleCulling = NONE);
	
}


#else
typedef GraphicsTrianglePath = flash.display.GraphicsTrianglePath;
#end