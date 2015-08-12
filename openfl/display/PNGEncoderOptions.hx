package openfl.display; #if !flash


@:final class PNGEncoderOptions {
	
	
	public var fastCompression:Bool;
	
	
	public function new (fastCompression:Bool = false) {
		
		this.fastCompression = fastCompression;
		
	}
	
	
}


#else
typedef PNGEncoderOptions = flash.display.PNGEncoderOptions;
#end