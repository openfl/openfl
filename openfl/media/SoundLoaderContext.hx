package openfl.media; #if !flash


class SoundLoaderContext {
	
	
	public var bufferTime:Float;
	public var checkPolicyFile:Bool;
	
	
	public function new (bufferTime:Float = 0, checkPolicyFile:Bool = false) {
		
		this.bufferTime = bufferTime;
		this.checkPolicyFile = checkPolicyFile;
		
	}
	
	
}


#else
typedef SoundLoaderContext = flash.media.SoundLoaderContext;
#end