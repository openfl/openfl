package openfl.display;

import openfl._internal.renderer.GraphicsDataType;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _GraphicsTrianglePath implements _IGraphicsData
{
	public var culling:TriangleCulling;
	public var indices:Vector<Int>;
	public var uvtData:Vector<Float>;
	public var vertices:Vector<Float>;

	public var __graphicsDataType(default, null):GraphicsDataType;

	private var graphicsTrianglePath:GraphicsTrianglePath;

	public function new(graphicsTrianglePath:GraphicsTrianglePath, vertices:Vector<Float> = null, indices:Vector<Int> = null, uvtData:Vector<Float> = null,
			culling:TriangleCulling = NONE)
	{
		this.graphicsTrianglePath = graphicsTrianglePath;

		this.vertices = vertices;
		this.indices = indices;
		this.uvtData = uvtData;
		this.culling = culling;
		__graphicsDataType = TRIANGLE_PATH;
	}
}
