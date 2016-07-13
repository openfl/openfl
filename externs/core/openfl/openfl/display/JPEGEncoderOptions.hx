package openfl.display; #if (display || !flash)


@:final extern class JPEGEncoderOptions {
	
	
	public var quality:UInt;
	
	
	public function new (quality:UInt = 80);
	
	
}


#else
typedef JPEGEncoderOptions = flash.display.JPEGEncoderOptions;
#end