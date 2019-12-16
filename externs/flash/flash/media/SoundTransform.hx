package flash.media;

#if flash
@:final extern class SoundTransform
{
	public var leftToLeft:Float;
	public var leftToRight:Float;
	public var pan:Float;
	public var rightToLeft:Float;
	public var rightToRight:Float;
	public var volume:Float;
	public function new(vol:Float = 1, panning:Float = 0);
	public function clone():SoundTransform;
}
#else
typedef SoundTransform = openfl.media.SoundTransform;
#end
