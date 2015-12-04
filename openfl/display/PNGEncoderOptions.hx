package openfl.display; #if (!display && !flash)


@:final class PNGEncoderOptions {
	
	
	public var fastCompression:Bool;
	
	
	public function new (fastCompression:Bool = false) {
		
		this.fastCompression = fastCompression;
		
	}
	
	
}


#else


#if flash
@:native("flash.display.PNGEncoderOptions")
#end

@:final extern class PNGEncoderOptions {
	
	
	public var fastCompression:Bool;
	
	
	public function new (fastCompression:Bool = false):Void;
	
	
}


#end