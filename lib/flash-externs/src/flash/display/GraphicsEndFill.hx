package flash.display;

#if flash
@:final extern class GraphicsEndFill implements IGraphicsData implements IGraphicsFill
{
	public function new();
}
#else
typedef GraphicsEndFill = openfl.display.GraphicsEndFill;
#end
