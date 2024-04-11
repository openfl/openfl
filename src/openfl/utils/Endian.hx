package openfl.utils;

#if !flash
#if lime
import lime.system.Endian as LimeEndian;
#end

#if !openfljs
/**
	The Endian class contains values that denote the byte order used to
	represent multibyte numbers. The byte order is either bigEndian (most
	significant byte first) or littleEndian (least significant byte first).

	OpenFL content can interface with a server by using the binary protocol of
	that server, directly. Some servers use the bigEndian byte order and some
	servers use the littleEndian byte order. Most servers on the Internet use
	the bigEndian byte order because "network byte order" is bigEndian. The
	littleEndian byte order is popular because the Intel x86 architecture uses
	it. Use the endian byte order that matches the protocol of the server that
	is sending or receiving data.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Endian(Null<Int>)

{
	/**
		Indicates the most significant byte of the multibyte number
		appears first in the sequence of bytes.

		The hexadecimal number 0x12345678 has 4 bytes (2 hexadecimal
		digits per byte). The most significant byte is 0x12. The
		least significant byte is 0x78. (For the equivalent decimal
		number, 305419896, the most significant digit is 3, and the
		least significant digit is 6).

		A stream using the bigEndian byte order (the most significant
		byte first) writes:

		```
		12 34 56 78
		```
	**/
	public var BIG_ENDIAN = 0;

	/**
		Indicates the least significant byte of the multibyte number
		appears first in the sequence of bytes.

		The hexadecimal number 0x12345678 has 4 bytes (2 hexadecimal
		digits per byte). The most significant byte is 0x12. The
		least significant byte is 0x78. (For the equivalent decimal
		number, 305419896, the most significant digit is 3, and the
		least significant digit is 6).

		A stream using the littleEndian byte order (the most
		significant byte first) writes:

		```
		78 56 34 12
		```
	**/
	public var LITTLE_ENDIAN = 1;

	#if lime
	@:from private static function fromLimeEndian(value:LimeEndian):Endian
	{
		return switch (value)
		{
			case LimeEndian.BIG_ENDIAN: BIG_ENDIAN;
			case LimeEndian.LITTLE_ENDIAN: LITTLE_ENDIAN;
			default: null;
		}
	}
	#end

	@:from private static function fromString(value:String):Endian
	{
		return switch (value)
		{
			case "bigEndian": BIG_ENDIAN;
			case "littleEndian": LITTLE_ENDIAN;
			default: null;
		}
	}

	#if lime
	@:to private function toLimeEndian():LimeEndian
	{
		return switch (cast this : Endian)
		{
			case Endian.BIG_ENDIAN: LimeEndian.BIG_ENDIAN;
			case Endian.LITTLE_ENDIAN: LimeEndian.LITTLE_ENDIAN;
			default: null;
		}
	}
	#end

	@:to private function toString():String
	{
		return switch (cast this : Endian)
		{
			case Endian.BIG_ENDIAN: "bigEndian";
			case Endian.LITTLE_ENDIAN: "littleEndian";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Endian(String) from String to String

{
	public var BIG_ENDIAN = "bigEndian";
	public var LITTLE_ENDIAN = "littleEndian";

	#if lime
	@:from private static function fromLimeEndian(value:LimeEndian):Endian
	{
		return switch (value)
		{
			case LimeEndian.BIG_ENDIAN: BIG_ENDIAN;
			case LimeEndian.LITTLE_ENDIAN: LITTLE_ENDIAN;
			default: null;
		}
	}

	@:to private function toLimeEndian():LimeEndian
	{
		return switch (cast this : Endian)
		{
			case Endian.BIG_ENDIAN: LimeEndian.BIG_ENDIAN;
			case Endian.LITTLE_ENDIAN: LimeEndian.LITTLE_ENDIAN;
			default: null;
		}
	}
	#end
}
#end
#else
typedef Endian = flash.utils.Endian;
#end
