package flash.geom;

#if flash
extern class ColorTransform
{
	#if (haxe_ver < 4.3)
	public var color:UInt;
	#else
	@:flash.property var color(get, set):UInt;
	#end

	public var alphaMultiplier:Float;
	public var alphaOffset:Float;
	public var blueMultiplier:Float;
	public var blueOffset:Float;
	public var greenMultiplier:Float;
	public var greenOffset:Float;
	public var redMultiplier:Float;
	public var redOffset:Float;
	public function new(redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redOffset:Float = 0,
		greenOffset:Float = 0, blueOffset:Float = 0, alphaOffset:Float = 0):Void;
	public function concat(second:ColorTransform):Void;
	public function toString():String;

	#if (haxe_ver >= 4.3)
	private function get_color():UInt;
	private function set_color(value:UInt):UInt;
	#end
}
#else
typedef ColorTransform = openfl.geom.ColorTransform;
#end
