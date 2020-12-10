package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;
import openfl.display._internal.GraphicsFillType;

/**
	Defines a solid fill.

	Use a GraphicsSolidFill object with the
	`Graphics.drawGraphicsData()` method. Drawing a
	GraphicsSolidFill object is the equivalent of calling the
	`Graphics.beginFill()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsSolidFill implements IGraphicsData implements IGraphicsFill
{
	/**
		Indicates the alpha transparency value of the fill. Valid values are 0
		(fully transparent) to 1(fully opaque). The default value is 1. Display
		objects with alpha set to 0 are active, even though they are invisible.
	**/
	public var alpha:Float;

	/**
		The color of the fill. Valid values are in the hexadecimal format
		0xRRGGBB. The default value is 0xFF0000(or the uint 0).
	**/
	public var color:UInt;

	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;

	/**
		Creates a new GraphicsSolidFill object.

		@param color The color value. Valid values are in the hexadecimal format
					 0xRRGGBB.
		@param alpha The alpha transparency value. Valid values are 0(fully
					 transparent) to 1(fully opaque).
	**/
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
