package openfl.display;

#if !flash
import openfl._internal.renderer.GraphicsDataType;

interface IGraphicsData
{
	@:allow(openfl) @:noCompletion private var _:Any;
}
#else
typedef IGraphicsData = flash.display.IGraphicsData;
#end
