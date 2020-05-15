package openfl.display;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Shape extends _DisplayObject
{
	public var graphics(get, never):Graphics;

	private var shape:Shape;

	public function new(shape:Shape)
	{
		this.shape = shape;

		super(shape);

		__type = SHAPE;
	}

	// Get & Set Methods

	private function get_graphics():Graphics
	{
		if (__graphics == null)
		{
			__graphics = new Graphics(this.shape);
		}

		return __graphics;
	}
}
