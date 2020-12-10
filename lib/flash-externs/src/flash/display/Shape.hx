package flash.display;

#if flash
extern class Shape extends DisplayObject
{
	public var graphics(default, never):Graphics;
	public function new();
}
#else
typedef Shape = openfl.display.Shape;
#end
