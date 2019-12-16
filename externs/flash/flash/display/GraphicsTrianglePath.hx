package flash.display;

#if flash
import openfl.Vector;

@:final extern class GraphicsTrianglePath implements IGraphicsData implements IGraphicsPath
{
	public var culling:TriangleCulling;
	public var indices:Vector<Int>;
	public var uvtData:Vector<Float>;
	public var vertices:Vector<Float>;
	public function new(?vertices:Vector<Float>, ?indices:Vector<Int>, ?uvtData:Vector<Float>, ?culling:TriangleCulling);
}
#else
typedef GraphicsTrianglePath = openfl.display.GraphicsTrianglePath;
#end
