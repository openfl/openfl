import GraphicsDataType from "../_internal/renderer/GraphicsDataType";
import GraphicsFillType from "../_internal/renderer/GraphicsFillType";
import IGraphicsFill from "../display/IGraphicsFill";
import IGraphicsData from "../display/IGraphicsData";

/**
	Defines a solid fill.

	Use a GraphicsSolidFill object with the
	`Graphics.drawGraphicsData()` method. Drawing a
	GraphicsSolidFill object is the equivalent of calling the
	`Graphics.beginFill()` method.
**/
export default class GraphicsSolidFill implements IGraphicsData, IGraphicsFill
{
	/**
		Indicates the alpha transparency value of the fill. Valid values are 0
		(fully transparent) to 1(fully opaque). The default value is 1. Display
		objects with alpha set to 0 are active, even though they are invisible.
	**/
	public alpha: number;

	/**
		The color of the fill. Valid values are in the hexadecimal format
		0xRRGGBB. The default value is 0xFF0000(or the uint 0).
	**/
	public color: number;

	protected __graphicsDataType: GraphicsDataType;
	protected __graphicsFillType: GraphicsFillType;

	/**
		Creates a new GraphicsSolidFill object.

		@param color The color value. Valid values are in the hexadecimal format
					 0xRRGGBB.
		@param alpha The alpha transparency value. Valid values are 0(fully
					 transparent) to 1(fully opaque).
	**/
	public constructor(color: number = 0, alpha: number = 1)
	{
		this.alpha = alpha;
		this.color = color;
		this.__graphicsDataType = GraphicsDataType.SOLID;
		this.__graphicsFillType = GraphicsFillType.SOLID_FILL;
	}
}
