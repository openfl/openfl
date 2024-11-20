package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;

/**
	This interface is used to define objects that can be used as parameters in
	the `openfl.display.Graphics` methods, including fills, strokes, and paths.
	Use the implementor classes of this interface to create and manage drawing
	property data, and to reuse the same data for different instances. Then, use
	the methods of the Graphics class to render the drawing objects.

	@see `openfl.display.Graphics.drawGraphicsData()`
	@see `openfl.display.Graphics.readGraphicsData()`
	@see [Using graphics data classes](https://books.openfl.org/openfl-developers-guide/using-the-drawing-api/advanced-use-of-the-drawing-api/using-graphics-data-classes.html)
**/
interface IGraphicsData
{
	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
}
#else
typedef IGraphicsData = flash.display.IGraphicsData;
#end
