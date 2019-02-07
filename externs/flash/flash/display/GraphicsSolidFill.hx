package flash.display;

#if flash
@:final extern class GraphicsSolidFill implements IGraphicsData implements IGraphicsFill
{
	public var alpha:Float;
	public var color:UInt;
	public function new(color:UInt = 0, alpha:Float = 1);
}
#else
typedef GraphicsSolidFill = openfl.display.GraphicsSolidFill;
#end
