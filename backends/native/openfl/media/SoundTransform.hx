package openfl.media;


class SoundTransform {
	
	
	public var pan:Float;
	public var volume:Float;
	
	
	public function new (volume:Float = 1.0, pan:Float = 0.0) {
		
		this.volume = volume;
		this.pan = pan;
		
	}
	
	
	public function clone ():SoundTransform {
		
		return new SoundTransform (volume, pan);
		
	}
	
	
}