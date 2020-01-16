package openfl.display;

import openfl.Vector;

#if !openfl_global
@:jsRequire("openfl/display/GraphicsQuadPath", "default")
#end
@:final extern class GraphicsQuadPath implements IGraphicsData implements IGraphicsPath
{
	public var indices:Vector<Int>;
	public var rects:Vector<Float>;
	public var transforms:Vector<Float>;
	public function new(rects:Vector<Float> = null, indices:Vector<Int> = null, transforms:Vector<Float> = null);
}
