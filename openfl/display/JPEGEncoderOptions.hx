package openfl.display; #if !flash


class JPEGEncoderOptions {
	
	
	public var quality:Int;
	
	
	public function new (quality:Int = 80) {
		
		this.quality = quality;
		
	}
	
	
}


#else
typedef JPEGEncoderOptions = flash.display.JPEGEncoderOptions;
#end