package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


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
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DTextureFormat, b:Context3DTextureFormat):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DTextureFormat, b:Context3DTextureFormat):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DTextureFormat(String) from String to String {
	
	public var BGR_PACKED = "bgrPacked565";
	public var BGRA = "bgra";
	public var BGRA_PACKED = "bgraPacked4444";
	public var COMPRESSED = "compressed";
	public var COMPRESSED_ALPHA = "compressedAlpha";
	public var RGBA_HALF_FLOAT = "rgbaHalfFloat";
	
}


#end