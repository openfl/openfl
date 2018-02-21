package openfl.display; #if (display || !flash)


@:jsRequire("openfl/display/JPEGEncoderOptions", "default")

@:final extern class JPEGEncoderOptions {
	
	
	public var quality:UInt;
	
	
	public function new (quality:UInt = 80);
	
	
}


#else
typedef JPEGEncoderOptions = flash.display.JPEGEncoderOptions;
#end