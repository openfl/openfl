package openfl.display;

#if !flash
import openfl.display._internal.GraphicsFillType;

/**
	This interface is used to define objects that can be used as fill parameters
	in the `openfl.display.Graphics` methods and drawing classes. Use the
	implementor classes of this interface to create and manage fill property
	data, and to reuse the same data for different instances.

	@see `openfl.display.Graphics.drawGraphicsData()`
	@see `openfl.display.GraphicsStroke.fill`
**/
interface IGraphicsFill
{
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;
}
#else
typedef IGraphicsFill = flash.display.IGraphicsFill;
#end
