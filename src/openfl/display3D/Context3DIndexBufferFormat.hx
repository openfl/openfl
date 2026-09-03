package openfl.display3D;

#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying the buffer format.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DIndexBufferFormat(Null<Int>)
{
	/**
		Indicates the buffer will contain UInt8 values
	**/
	public var UINT8 = 0;

	/**
		Indicates the buffer will contain UInt16 values

		This type is the default value for buffers in `Stage3D`.
	**/
	public var UINT16 = 1;

	/**
		Indicates the buffer will contain UInt8 values
	**/
	public var UINT32 = 2;

	@:from private static function fromString(value:String):Context3DIndexBufferFormat
	{
		return switch (value)
		{
			case "uint8": UINT8;
			case "uint16": UINT16;
			case "uint32": UINT32;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DIndexBufferFormat)
		{
			case Context3DIndexBufferFormat.UINT8: "uint8";
			case Context3DIndexBufferFormat.UINT16: "uint16";
			case Context3DIndexBufferFormat.UINT32: "uint32";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DIndexBufferFormat, b:Context3DIndexBufferFormat):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DIndexBufferFormat, b:Context3DIndexBufferFormat):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment") #if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DIndexBufferFormat(String) from String to String
{
	public var UINT8 = "uint8";
	public var UINT16 = "uint16";
	public var UINT32 = "uint32";
}
#end
