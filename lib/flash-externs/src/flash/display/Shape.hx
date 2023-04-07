package flash.display;

#if flash
extern class Shape extends DisplayObject
{
	#if (haxe_ver < 4.3)
	public var graphics(default, never):Graphics;
	#else
	@:flash.property var graphics(get, never):Graphics;
	#end

	public function new();

	#if (haxe_ver >= 4.3)
	private function get_graphics():Graphics;
	#end
}
#else
typedef Shape = openfl.display.Shape;
#end
