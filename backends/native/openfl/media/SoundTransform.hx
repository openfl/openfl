package openfl.media;


class SoundTransform {
	
	
	public var leftToLeft:Float;
	public var leftToRight:Float;
	public var pan:Float;
	public var rightToLeft:Float;
	public var rightToRight:Float;
	public var volume:Float;
	
	
	public function new (volume:Float = 1.0, pan:Float = 0.0) {
		
		this.volume = volume;
		this.pan = pan;
		leftToLeft = 0;
		leftToRight = 0;
		rightToLeft = 0;
		rightToRight = 0;
		
	}
	
	
	public function clone ():SoundTransform {
		
		return new SoundTransform (volume, pan);
		
	}
	
	
}