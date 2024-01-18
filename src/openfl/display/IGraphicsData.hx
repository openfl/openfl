package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;

/**
	@see [Using graphics data classes](https://books.openfl.org/openfl-developers-guide/using-the-drawing-api/advanced-use-of-the-drawing-api/using-graphics-data-classes.html)
**/
interface IGraphicsData
{
	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
}
#else
typedef IGraphicsData = flash.display.IGraphicsData;
#end
