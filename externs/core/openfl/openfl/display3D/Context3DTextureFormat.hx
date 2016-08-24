package openfl.display3D; #if (display || !flash)


@:enum abstract Context3DTextureFormat(Null<Int>) {
	
	public var BGR_PACKED = 0;
	public var BGRA = 1;
	public var BGRA_PACKED = 2;
	public var COMPRESSED = 3;
	public var COMPRESSED_ALPHA = 4;
	public var RGBA_HALF_FLOAT = 5;
	
	@:from private static function fromString (value:String):Context3DTextureFormat {
		
		return switch (value) {
			
			case "bgrPacked565": BGR_PACKED;
			case "bgra": BGRA;
			case "bgraPacked4444": BGRA_PACKED;
			case "compressed": COMPRESSED;
			case "compressedAlpha": COMPRESSED_ALPHA;
			case "rgbaHalfFloat": RGBA_HALF_FLOAT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DTextureFormat.BGR_PACKED: "bgrPacked565";
			case Context3DTextureFormat.BGRA: "bgra";
			case Context3DTextureFormat.BGRA_PACKED: "bgraPacked4444";
			case Context3DTextureFormat.COMPRESSED: "compressed";
			case Context3DTextureFormat.COMPRESSED_ALPHA: "compressedAlpha";
			case Context3DTextureFormat.RGBA_HALF_FLOAT: "rgbaHalfFloat";
			default: null;
			
		}
		
	}
	
}


#else
typedef Context3DTextureFormat = flash.display3D.Context3DTextureFormat;
#end