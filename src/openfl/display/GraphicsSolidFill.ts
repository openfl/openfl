import GraphicsDataType from "openfl/_internal/renderer/GraphicsDataType";
import GraphicsFillType from "openfl/_internal/renderer/GraphicsFillType";

namespace openfl.display
{
	/**
		Defines a solid fill.

		Use a GraphicsSolidFill object with the
		`Graphics.drawGraphicsData()` method. Drawing a
		GraphicsSolidFill object is the equivalent of calling the
		`Graphics.beginFill()` method.
	**/
	export class GraphicsSolidFill implements IGraphicsData implements IGraphicsFill
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

		protected __graphicsDataType(default , null): GraphicsDataType;
		protected __graphicsFillType(default , null): GraphicsFillType;

		/**
			Creates a new GraphicsSolidFill object.

			@param color The color value. Valid values are in the hexadecimal format
						 0xRRGGBB.
			@param alpha The alpha transparency value. Valid values are 0(fully
						 transparent) to 1(fully opaque).
		**/
		public constructor(color: UInt = 0, alpha: number = 1)
		{
			this.alpha = alpha;
			this.color = color;
			this.__graphicsDataType = SOLID;
			this.__graphicsFillType = SOLID_FILL;
		}
	}
}

export default openfl.display.GraphicsSolidFill;
