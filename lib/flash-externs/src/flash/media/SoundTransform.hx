package flash.media;

#if flash
@:final extern class SoundTransform
{
	#if (haxe_ver < 4.3)
	public var leftToLeft:Float;
	public var leftToRight:Float;
	public var pan:Float;
	public var rightToLeft:Float;
	public var rightToRight:Float;
	public var volume:Float;
	#else
	@:flash.property var leftToLeft(get, set):Float;
	@:flash.property var leftToRight(get, set):Float;
	@:flash.property var pan(get, set):Float;
	@:flash.property var rightToLeft(get, set):Float;
	@:flash.property var rightToRight(get, set):Float;
	@:flash.property var volume(get, set):Float;
	#end

	public function new(vol:Float = 1, panning:Float = 0);
	public function clone():SoundTransform;

	#if (haxe_ver >= 4.3)
	private function get_leftToLeft():Float;
	private function get_leftToRight():Float;
	private function get_pan():Float;
	private function get_rightToLeft():Float;
	private function get_rightToRight():Float;
	private function get_volume():Float;
	private function set_leftToLeft(value:Float):Float;
	private function set_leftToRight(value:Float):Float;
	private function set_pan(value:Float):Float;
	private function set_rightToLeft(value:Float):Float;
	private function set_rightToRight(value:Float):Float;
	private function set_volume(value:Float):Float;
	#end
}
#else
typedef SoundTransform = openfl.media.SoundTransform;
#end
