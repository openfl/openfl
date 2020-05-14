package openfl.display;

import openfl._internal.renderer.GraphicsDataType;
import openfl._internal.renderer.GraphicsFillType;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _GraphicsSolidFill implements _IGraphicsData implements _IGraphicsFill
{
	public var alpha:Float;
	public var color:UInt;

	public var __graphicsDataType(default, null):GraphicsDataType;
	public var __graphicsFillType(default, null):GraphicsFillType;

	private var graphicsSolidFill:GraphicsSolidFill;

	public function new(graphicsSolidFill:GraphicsSolidFill, color:UInt = 0, alpha:Float = 1)
	{
		this.graphicsSolidFill = graphicsSolidFill;

		this.alpha = alpha;
		this.color = color;
		this.__graphicsDataType = SOLID;
		this.__graphicsFillType = SOLID_FILL;
	}
}
