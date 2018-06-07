package openfl.display;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class JPEGEncoderOptions {
	
	
	public var quality:Int;
	
	
	public function new (quality:Int = 80) {
		
		this.quality = quality;
		
	}
	
	
}