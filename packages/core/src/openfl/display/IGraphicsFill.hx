package openfl.display;

#if !flash
import openfl._internal.renderer.GraphicsFillType;

interface IGraphicsFill
{
	@:allow(openfl) @:noCompletion private var _:Any;
}
#else
typedef IGraphicsFill = flash.display.IGraphicsFill;
#end
