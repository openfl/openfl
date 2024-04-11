package flash.display;

#if flash
import openfl.Vector;

@:final extern class GraphicsTrianglePath implements IGraphicsData implements IGraphicsPath
{
	#if (haxe_ver < 4.3)
	public var culling:TriangleCulling;
	#else
	@:flash.property var culling(get, set):TriangleCulling;
	#end

	public var indices:Vector<Int>;
	public var uvtData:Vector<Float>;
	public var vertices:Vector<Float>;

	public function new(?vertices:Vector<Float>, ?indices:Vector<Int>, ?uvtData:Vector<Float>, ?culling:TriangleCulling);

	#if (haxe_ver >= 4.3)
	private function get_culling():TriangleCulling;
	private function set_culling(value:TriangleCulling):TriangleCulling;
	#end
}
#else
typedef GraphicsTrianglePath = openfl.display.GraphicsTrianglePath;
#end
