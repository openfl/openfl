package openfl.utils;

#if !flash
import openfl.net.ObjectEncoding;

/**
	The IDataInput interface provides a set of methods for reading binary data. This
	interface is the I/O counterpart to the IDataOutput interface, which writes binary data.

	All IDataInput and IDataOutput operations are "bigEndian" by default (the most
	significant byte in the sequence is stored at the lowest or first storage address), and
	are nonblocking. If insufficient data is available, an `EOFError` exception is thrown.
	Use the `IDataInput.bytesAvailable` property to determine how much data is available
	to read.

	Sign extension matters only when you read data, not when you write it. Therefore you
	do not need separate write methods to work with `IDataInput.readUnsignedByte()` and
	`IDataInput.readUnsignedShort()`. In other words:

	* Use `IDataOutput.writeByte()` with `IDataInput.readUnsignedByte()` and
	`IDataInput.readByte()`.
	* Use `IDataOutput.writeShort()` with `IDataInput.readUnsignedShort()` and
	`IDataInput.readShort()`.
**/
interface IDataInput
{
	/**
		Returns the number of bytes of data available for reading in the input buffer.
		User code must call `bytesAvailable` to ensure that sufficient data is available
		before trying to read it with one of the read methods.
	**/
	public var bytesAvailable(get, never):UInt;

	/**
		The byte order for the data, either the `BIG_ENDIAN` or `LITTLE_ENDIAN` constant
		from the Endian class.
	**/
	public var endian(get, set):Endian;

	/**
		Used to determine whether the `AMF3` or `AMF0` format is used when writing or
		reading binary data using the `readObject()` method. The value is a constant from
		the ObjectEncoding class.
	**/
	public var objectEncoding:ObjectEncoding;

	/**
		Reads a Boolean value from the file stream, byte stream, or byte array. A single
		byte is read and `true` is returned if the byte is nonzero, `false` otherwise.

		@returns	A Boolean value, `true` if the byte is nonzero, `false` otherwise.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readBoolean():Bool;

	/**
		Reads a signed byte from the file stream, byte stream, or byte array.

		@returns	The returned value is in the range -128 to 127.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readByte():Int;

	/**
		Reads the number of data bytes, specified by the `length` parameter, from the file
		stream, byte stream, or byte array. The bytes are read into the ByteArray objected
		specified by the `bytes` parameter, starting at the position specified by `offset`.

		@param	bytes	The ByteArray object to read data into.
		 		@param	offset	The offset into the `bytes` parameter at which data read should
		begin.
		@param	length	The number of bytes to read. The default value of 0 causes all
		available data to be read.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void;

	/**
		Reads an IEEE 754 double-precision floating point number from the file stream, byte
		stream, or byte array.

		@returns	An IEEE 754 double-precision floating point number.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readDouble():Float;

	/**
		Reads an IEEE 754 single-precision floating point number from the file stream, byte
		stream, or byte array.

		@returns	An IEEE 754 single-precision floating point number.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readFloat():Float;

	/**
		Reads a signed 32-bit integer from the file stream, byte stream, or byte array.

		@returns	The returned value is in the range -2147483648 to 2147483647.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readInt():Int;

	/**
		Reads a multibyte string of specified length from the file stream, byte stream, or
		byte array using the specified character set.

		@param	length	The number of bytes from the byte stream to read.
		@param	charSet	The string denoting the character set to use to interpret the
		bytes. Possible character set strings include "shift-jis", "cn-gb", "iso-8859-1",
		and others. For a complete list, see Supported Character Sets.

		**Note:** If the value for the `charSet` parameter is not recognized by the current
		system, then Adobe® Flash® Player or Adobe® AIR® uses the system's default code page
		as the character set. For example, a value for the `charSet` parameter, as in
		`myTest.readMultiByte(22, "iso-8859-01")`, that uses `01` instead of `1` might work
		on your development system, but not on another system. On the other system, Flash
		Player or the AIR runtime will use the system's default code page.
		@returns	UTF-8 encoded string.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readMultiByte(length:UInt, charSet:String):String;

	/**
		Reads an object from the file stream, byte stream, or byte array, encoded in AMF
		serialized format.

		@returns	The deserialized object
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readObject():Dynamic;

	/**
		Reads a signed 16-bit integer from the file stream, byte stream, or byte array.

		@returns	The returned value is in the range -32768 to 32767.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readShort():Int;

	/**
		Reads an unsigned byte from the file stream, byte stream, or byte array.

		@returns	The returned value is in the range 0 to 255.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readUnsignedByte():Int;

	/**
		Reads an unsigned 32-bit integer from the file stream, byte stream, or byte array.

		@returns	The returned value is in the range 0 to 4294967295.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readUnsignedInt():Int;

	/**
		Reads an unsigned 16-bit integer from the file stream, byte stream, or byte array.

		@returns	The returned value is in the range 0 to 65535.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readUnsignedShort():Int;

	/**
		Reads a UTF-8 string from the file stream, byte stream, or byte array. The string
		is assumed to be prefixed with an unsigned short indicating the length in bytes.

		This method is similar to the `readUTF()` method in the Java® IDataInput interface.

		@returns	A UTF-8 string produced by the byte representation of characters.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readUTF():String;

	/**
		Reads a sequence of UTF-8 bytes from the byte stream or byte array and returns a
		string.

		@param	length	The number of bytes to read.
		@returns	A UTF-8 string produced by the byte representation of characters of
		the specified length.
		@throws	EOFError	There is not sufficient data available to read.
	**/
	public function readUTFBytes(length:Int):String;
}
#else
typedef IDataInput = flash.utils.IDataInput;
#end
