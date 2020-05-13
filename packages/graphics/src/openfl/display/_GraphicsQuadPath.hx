package openfl.display;

#if !flash
import openfl._internal.renderer.GraphicsDataType;
#end
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _GraphicsQuadPath implements _IGraphicsData
{
	public var indices:Vector<Int>;
	public var rects:Vector<Float>;
	public var transforms:Vector<Float>;

	#if !flash
	public var __graphicsDataType(default, null):GraphicsDataType;
	#end

	public function new(rects:Vector<Float> = null, indices:Vector<Int> = null, transforms:Vector<Float> = null)
	{
		this.rects = rects;
		this.indices = indices;
		this.transforms = transforms;

		#if !flash
		__graphicsDataType = QUAD_PATH;
		#end
	}
}
