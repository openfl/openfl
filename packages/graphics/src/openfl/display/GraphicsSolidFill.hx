package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;
import openfl.display._internal.GraphicsFillType;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsSolidFill implements IGraphicsData implements IGraphicsFill
{
	public var alpha:Float;
	public var color:UInt;

	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;

	public function new(color:UInt = 0, alpha:Float = 1)
	{
		this.alpha = alpha;
		this.color = color;
		this.__graphicsDataType = SOLID;
		this.__graphicsFillType = SOLID_FILL;
	}
}
#else
typedef GraphicsSolidFill = flash.display.GraphicsSolidFill;
#end
