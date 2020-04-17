import GraphicsDataType from "../_internal/renderer/GraphicsDataType";
import GraphicsFillType from "../_internal/renderer/GraphicsFillType";
import IGraphicsFill from "../display/IGraphicsFill";
import IGraphicsData from "../display/IGraphicsData";

/**
	Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
	`Graphics.drawGraphicsData()` method.

	Drawing a GraphicsEndFill object is the equivalent of calling the
	`Graphics.endFill()` method.
**/
export default class GraphicsEndFill implements IGraphicsData, IGraphicsFill
{
	protected __graphicsDataType: GraphicsDataType;
	protected __graphicsFillType: GraphicsFillType;

	/**
		Creates an object to use with the `Graphics.drawGraphicsData()`
		method to end the fill, explicitly.
	**/
	public constructor()
	{
		this.__graphicsDataType = GraphicsDataType.END;
		this.__graphicsFillType = GraphicsFillType.END_FILL;
	}
}
