package openfl.media;


@:final class SoundTransform {
	
	
	public var leftToLeft:Float;
	public var leftToRight:Float;
	public var pan:Float;
	public var rightToLeft:Float;
	public var rightToRight:Float;
	public var volume:Float;
	
	
	public function new (vol:Float = 1, panning:Float = 0) {
		
		volume = vol;
		pan = panning;
		leftToLeft = 0;
		leftToRight = 0;
		rightToLeft = 0;
		rightToRight = 0;
		
	}
	
	
	public function clone ():SoundTransform {
		
		return new SoundTransform (volume, pan);
		
	}
	
	
}