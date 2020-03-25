import GraphicsDataType from "openfl/_internal/renderer/GraphicsDataType";
import GraphicsFillType from "openfl/_internal/renderer/GraphicsFillType";

namespace openfl.display
{
	/**
		Indicates the end of a graphics fill. Use a GraphicsEndFill object with the
		`Graphics.drawGraphicsData()` method.

		Drawing a GraphicsEndFill object is the equivalent of calling the
		`Graphics.endFill()` method.
	**/
	export class GraphicsEndFill implements IGraphicsData implements IGraphicsFill
	{
		protected __graphicsDataType(default , null): GraphicsDataType;
		protected __graphicsFillType(default , null): GraphicsFillType;

		/**
			Creates an object to use with the `Graphics.drawGraphicsData()`
			method to end the fill, explicitly.
		**/
		public constructor()
		{
			this.__graphicsDataType = END;
			this.__graphicsFillType = END_FILL;
		}
	}
}

export default openfl.display.GraphicsEndFill;
