package flash.display3D;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DTextureFormat(String) from String to String

{
	public var BGR_PACKED = "bgrPacked565";
	public var BGRA = "bgra";
	public var BGRA_PACKED = "bgraPacked4444";
	public var COMPRESSED = "compressed";
	public var COMPRESSED_ALPHA = "compressedAlpha";
	public var RGBA_HALF_FLOAT = "rgbaHalfFloat";
}
#else
typedef Context3DTextureFormat = openfl.display3D.Context3DTextureFormat;
#end
