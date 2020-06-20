package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;
import openfl.display._internal.GraphicsFillType;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsBitmapFill implements IGraphicsData implements IGraphicsFill
{
	public var bitmapData:BitmapData;
	public var matrix:Matrix;
	public var repeat:Bool;
	public var smooth:Bool;

	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;

	public function new(bitmapData:BitmapData = null, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false)
	{
		this.bitmapData = bitmapData;
		this.matrix = matrix;
		this.repeat = repeat;
		this.smooth = smooth;

		this.__graphicsDataType = BITMAP;
		this.__graphicsFillType = BITMAP_FILL;
	}
}
#else
typedef GraphicsBitmapFill = flash.display.GraphicsBitmapFill;
#end
