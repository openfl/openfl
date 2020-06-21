package openfl.utils;

#if !flash
import openfl.net.ObjectEncoding;

/**
	The IDataOutput interface provides a set of methods for writing binary data. This
	interface is the I/O counterpart to the IDataInput interface, which reads binary data. The IDataOutput interface is implemented by the FileStream, Socket and ByteArray
	classes.

	All IDataInput and IDataOutput operations are "bigEndian" by default (the most
	significant byte in the sequence is stored at the lowest or first storage address),
	and are nonblocking.

	Sign extension matters only when you read data, not when you write it. Therefore, you
	do not need separate write methods to work with `IDataInput.readUnsignedByte()` and `IDataInput.readUnsignedShort()`. In other words:

	* Use `IDataOutput.writeByte()` with `IDataInput.readUnsignedByte()` and
	`IDataInput.readByte()`.
	* Use `IDataOutput.writeShort()` with `IDataInput.readUnsignedShort()` and
	`IDataInput.readShort()`.
**/
interface IDataOutput
{
	/**
		The byte order for the data, either the `BIG_ENDIAN` or `LITTLE_ENDIAN` constant
		from the Endian class.
	**/
	public var endian(get, set):Endian;

	/**
		Used to determine whether the `AMF3` or `AMF0` format is used when writing or
		reading binary data using the `writeObject()` method. The value is a constant from
		the ObjectEncoding class.
	**/
	public var objectEncoding:ObjectEncoding;

	/**
		Writes a Boolean value. A single byte is written according to the `value` parameter,
		either 1 if `true` or 0 if `false`.

		@param	value	A Boolean value determining which byte is written. If the parameter
		is `true`, 1 is written; if `false`, 0 is written.
	**/
	public function writeBoolean(value:Bool):Void;

	/**
		Writes a byte. The low 8 bits of the parameter are used; the high 24 bits are
		ignored.

		@param	value	A byte value as an integer.
	**/
	public function writeByte(value:Int):Void;

	/**
		Writes a sequence of bytes from the specified byte array, bytes, starting at the
		byte specified by `offset` (using a zero-based index) with a length specified by
		`length`, into the file stream, byte stream, or byte array.

		If the `length` parameter is omitted, the default length of 0 is used and the
		entire buffer starting at `offset` is written. If the `offset` parameter is also
		omitted, the entire buffer is written.

		If the `offset` or `length` parameter is out of range, they are clamped to the
		beginning and end of the bytes array.

		@param	bytes	The byte array to write.
		@param	offset	A zero-based index specifying the position into the array to begin
		writing.
		@param	length	An unsigned integer specifying how far into the buffer to write.
	**/
	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void;

	/**
		Writes an IEEE 754 double-precision (64-bit) floating point number.

		@param	value	A double-precision (64-bit) floating point number.
	**/
	public function writeDouble(value:Float):Void;

	/**
		Writes an IEEE 754 single-precision (32-bit) floating point number.

		@param	value	A single-precision (32-bit) floating point number.
	**/
	public function writeFloat(value:Float):Void;

	/**
		Writes a 32-bit signed integer.

		@param	value	A byte value as a signed integer.
	**/
	public function writeInt(value:Int):Void;

	/**
		Writes a multibyte string to the file stream, byte stream, or byte array, using
		the specified character set.

		@param	value	The string value to be written.
		@param	charSet	The string denoting the character set to use. Possible character
		set strings include "shift-jis", "cn-gb", "iso-8859-1", and others. For a complete
		list, see Supported Character Sets.
	**/
	public function writeMultiByte(value:String, charSet:String):Void;

	/**
		Writes an object to the file stream, byte stream, or byte array, in AMF
		serialized format.

		@param	object	The object to be serialized.
	**/
	public function writeObject(object:Dynamic):Void;

	/**
		Writes a 16-bit integer. The low 16 bits of the parameter are used; the high 16
		bits are ignored.

		@param	value	A byte value as an integer.
	**/
	public function writeShort(value:Int):Void;

	/**
		Writes a 32-bit unsigned integer.

		@param	value	A byte value as an unsigned integer.
	**/
	public function writeUnsignedInt(value:Int):Void;

	/**
		Writes a UTF-8 string to the file stream, byte stream, or byte array. The length
		of the UTF-8 string in bytes is written first, as a 16-bit integer, followed by
		the bytes representing the characters of the string.

		@param	value	The string value to be written.
		@throws	RangeError	If the `length` is larger than 65535.
	**/
	public function writeUTF(value:String):Void;

	/**
		Writes a UTF-8 string. Similar to `writeUTF()`, but does not prefix the string with
		a 16-bit `length` word.

		@param	value	The string value to be written.
	**/
	public function writeUTFBytes(value:String):Void;
}
#else
typedef IDataOutput = flash.utils.IDataOutput;
#end
