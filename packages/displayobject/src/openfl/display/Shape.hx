package openfl.display;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Graphics)
class Shape extends DisplayObject
{
	public var graphics(get, never):Graphics;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(Shape.prototype, "graphics", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_graphics (); }")
		});
	}
	#end

	public function new()
	{
		super();
	}

	// Get & Set Methods
	@:noCompletion private function get_graphics():Graphics
	{
		if (__graphics == null)
		{
			__graphics = new Graphics(this);
		}

		return __graphics;
	}
}
#else
typedef Shape = flash.display.Shape;
#end
