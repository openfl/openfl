package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying a texture format.
**/
@:enum abstract Context3DTextureFormat(Null<Int>)
{
	/**
		16 bit, bgr packed as 5:6:5
	**/
	public var BGR_PACKED = 0;

	/**
		32 bit
	**/
	public var BGRA = 1;

	/**
		16 bit, bgra packed as 4:4:4:4
	**/
	public var BGRA_PACKED = 2;

	/**
		ATF (Adobe Texture Format)
	**/
	public var COMPRESSED = 3;

	/**
		ATF (Adobe Texture Format), with alpha
	**/
	public var COMPRESSED_ALPHA = 4;

	/**
		64 bit, rgba as 16:16:16:16
	**/
	public var RGBA_HALF_FLOAT = 5;

	@:from private static function fromString(value:String):Context3DTextureFormat
	{
		return switch (value)
		{
			case "bgrPacked565": BGR_PACKED;
			case "bgra": BGRA;
			case "bgraPacked4444": BGRA_PACKED;
			case "compressed": COMPRESSED;
			case "compressedAlpha": COMPRESSED_ALPHA;
			case "rgbaHalfFloat": RGBA_HALF_FLOAT;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DTextureFormat)
		{
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
	@:noCompletion @:op(A == B) private static function equals(a:Context3DTextureFormat, b:Context3DTextureFormat):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DTextureFormat, b:Context3DTextureFormat):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DTextureFormat(String) from String to String
{
	public var BGR_PACKED = "bgrPacked565";
	public var BGRA = "bgra";
	public var BGRA_PACKED = "bgraPacked4444";
	public var COMPRESSED = "compressed";
	public var COMPRESSED_ALPHA = "compressedAlpha";
	public var RGBA_HALF_FLOAT = "rgbaHalfFloat";
}
#end
#else
typedef Context3DTextureFormat = flash.display3D.Context3DTextureFormat;
#end
