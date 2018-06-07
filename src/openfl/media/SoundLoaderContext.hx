package openfl.media;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class SoundLoaderContext {
	
	
	public var bufferTime:Float;
	public var checkPolicyFile:Bool;
	
	
	public function new (bufferTime:Float = 1000, checkPolicyFile:Bool = false) {
		
		this.bufferTime = bufferTime;
		this.checkPolicyFile = checkPolicyFile;
		
	}
	
	
}