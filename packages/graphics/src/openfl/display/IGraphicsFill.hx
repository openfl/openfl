package openfl.display;

#if !flash
import openfl.display._internal.GraphicsFillType;

interface IGraphicsFill
{
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;
}
#else
typedef IGraphicsFill = flash.display.IGraphicsFill;
#end
