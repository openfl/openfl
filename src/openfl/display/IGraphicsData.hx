package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;

interface IGraphicsData
{
	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
}
#else
typedef IGraphicsData = flash.display.IGraphicsData;
#end
