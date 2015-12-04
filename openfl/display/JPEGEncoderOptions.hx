package openfl.display; #if (!display && !flash)


@:final class JPEGEncoderOptions {
	
	
	public var quality:Int;
	
	
	public function new (quality:Int = 80) {
		
		this.quality = quality;
		
	}
	
	
}


#else


#if flash
@:native("flash.display.JPEGEncoderOptions")
#end

@:final extern class JPEGEncoderOptions {
	
	
	public var quality:UInt;
	
	
	public function new (quality:UInt = 80);
	
	
}


#end