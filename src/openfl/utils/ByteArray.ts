import EOFError from "../errors/EOFError";
import ObjectEncoding from "../net/ObjectEncoding";
import CompressionAlgorithm from "../utils/CompressionAlgorithm";
import Endian from "../utils/Endian";
import Future from "../utils/Future";
import IDataInput from "../utils/IDataInput";
import IDataOutput from "../utils/IDataOutput";
import * as pako from "pako";

/**
	The ByteArray class provides methods and properties to optimize reading,
	writing, and working with binary data.

	_Note:_ The ByteArray class is for advanced developers who need to
	access data on the byte level.

	In-memory data is a packed array (the most compact representation for
	the data type) of bytes, but an instance of the ByteArray class can be
	manipulated with the standard `[]`(array access) operators. It
	also can be read and written to as an in-memory file, using methods similar
	to those in the URLStream and Socket classes.

	On the Flash and AIR targets, the ByteArray type is a real class, but on
	other platforms, ByteArray is a Haxe abstract over a hidden `ByteArrayData`
	type. To check if an object is a ByteArray at runtime, import the ByteArray
	type, then compare with ByteArrayData, such as `Std.is (ba, ByteArrayData)`.

	In addition, all platforms support zlib compression and decompression, as
	well as additional formats for object serialization.

	Possible uses of the ByteArray class include the following:

	* Creating a custom protocol to connect to a server.
	* Writing your own URLEncoder/URLDecoder.
	* Writing your own AMF/Remoting packet.
	* Optimizing the size of your data by using data types.
	* Working with binary data loaded from a local file.
	* Supporting new binary file formats.
**/
export default class ByteArray implements IDataInput, IDataOutput
{
	/**
		Denotes the default object encoding for the ByteArray class to use for a
		new ByteArray instance. When you create a new ByteArray instance, the
		encoding on that instance starts with the value of
		`defaultObjectEncoding`. The `defaultObjectEncoding`
		property is initialized to `ObjectEncoding.DEFAULT`. This value varies
		between platforms.

		When an object is written to or read from binary data, the
		`objectEncoding` value is used to determine whether the
		Haxe, JavaScript, ActionScript 3.0, ActionScript 2.0 or ActionScript 1.0
		format should be used. The value is a constant from the ObjectEncoding
		class.
	**/
	public static defaultObjectEncoding: ObjectEncoding = ObjectEncoding.DEFAULT;

	protected static __defaultEndian: Endian = null;
	protected static __helper: DataView = new DataView(new ArrayBuffer(8));

	/**
		Used to determine whether the ActionScript 3.0, ActionScript 2.0, or
		ActionScript 1.0 format should be used when writing to, or reading from, a
		ByteArray instance. The value is a constant from the ObjectEncoding class.

		On the Flash and AIR targets, support for Action Message Format (AMF) object
		serialization is included in the Flash runtime. For other targets, AMF
		serialization is supported if your project using built using the optional
		"format" library, such as `<haxelib name="format" />` in a project.xml file.

		Additional OpenFL targets support reading and writing of objects using
		Haxe Serialization Format (HXSF) and JavaScript Object Notation (JSON). These
		targets use HXSF by default.

		Since these additional object serialization formats are not internal to the
		Flash runtime, they are not supported by the `readObject` or `writeObject`
		functions on the Flash or AIR targets, but through `haxe.Serializer`,
		`haxe.Unserializer` or `haxe.JSON` if needed.
	**/
	public objectEncoding: ObjectEncoding;

	/**
		Moves, or returns the current position, in bytes, of the file pointer into
		the ByteArray object. This is the point at which the next call to a read
		method starts reading or a write method starts writing.
	**/
	public position: number;

	protected __buffer: ArrayBuffer;
	protected __length: number;
	protected __littleEndian: boolean;
	protected __view: DataView;

	/**
		Creates a ByteArray instance representing a packed array of bytes, so that
		you can use the methods and properties in this class to optimize your data
		storage and stream.
	**/
	public constructor(length: number = 0)
	{
		this.__buffer = new ArrayBuffer(length);
		this.__view = new DataView(this.__buffer);
		this.__length = length;

		this.__littleEndian = (ByteArray.defaultEndian == Endian.LITTLE_ENDIAN);
		this.objectEncoding = ByteArray.defaultObjectEncoding;
		this.position = 0;
	}

	/**
		Clears the contents of the byte array and resets the `length`
		and `position` properties to 0. Calling this method explicitly
		frees up the memory used by the ByteArray instance.
	**/
	public clear(): void
	{
		this.length = 0;
		this.position = 0;
	}

	/**
		Compresses the byte array. The entire byte array is compressed. For
		content running in Adobe AIR, you can specify a compression algorithm by
		passing a value(defined in the CompressionAlgorithm class) as the
		`algorithm` parameter. Flash Player supports only the default
		algorithm, zlib.

		After the call, the `length` property of the ByteArray is
		set to the new length. The `position` property is set to the
		end of the byte array.

		The zlib compressed data format is described at
		[http://www.ietf.org/rfc/rfc1950.txt](http://www.ietf.org/rfc/rfc1950.txt).

		The deflate compression algorithm is described at
		[http://www.ietf.org/rfc/rfc1951.txt](http://www.ietf.org/rfc/rfc1951.txt).

		The deflate compression algorithm is used in several compression
		formats, such as zlib, gzip, some zip implementations, and others. When
		data is compressed using one of those compression formats, in addition to
		storing the compressed version of the original data, the compression
		format data(for example, the .zip file) includes metadata information.
		Some examples of the types of metadata included in various file formats
		are file name, file modification date/time, original file size, optional
		comments, checksum data, and more.

		For example, when a ByteArray is compressed using the zlib algorithm,
		the resulting ByteArray is structured in a specific format. Certain bytes
		contain metadata about the compressed data, while other bytes contain the
		actual compressed version of the original ByteArray data. As defined by
		the zlib compressed data format specification, those bytes(that is, the
		portion containing the compressed version of the original data) are
		compressed using the deflate algorithm. Consequently those bytes are
		identical to the result of calling `compress(<ph
		outputclass="javascript">air.CompressionAlgorithm.DEFLATE)` on the
		original ByteArray. However, the result from `compress(<ph
		outputclass="javascript">air.CompressionAlgorithm.ZLIB)` includes
		the extra metadata, while the
		`compress(CompressionAlgorithm.DEFLATE)` result includes only
		the compressed version of the original ByteArray data and nothing
		else.

		In order to use the deflate format to compress a ByteArray instance's
		data in a specific format such as gzip or zip, you cannot simply call
		`compress(CompressionAlgorithm.DEFLATE)`. You must create a
		ByteArray structured according to the compression format's specification,
		including the appropriate metadata as well as the compressed data obtained
		using the deflate format. Likewise, in order to decode data compressed in
		a format such as gzip or zip, you can't simply call
		`uncompress(CompressionAlgorithm.DEFLATE)` on that data. First,
		you must separate the metadata from the compressed data, and you can then
		use the deflate format to decompress the compressed data.

	**/
	public compress(algorithm: CompressionAlgorithm = CompressionAlgorithm.ZLIB): void
	{
		var buffer = null;

		if (this.__buffer.byteLength > this.__length)
		{
			buffer = new ArrayBuffer(this.__length);
			new Uint8Array(buffer).set(new Uint8Array(this.__buffer));
			this.__buffer = buffer;
			this.__view = new DataView(this.__buffer);
		}

		switch (algorithm)
		{
			case CompressionAlgorithm.DEFLATE:
				buffer = pako.deflateRaw(this.__buffer);
				break;

			case CompressionAlgorithm.LZMA:
				// TODO
				break;

			default:
				buffer = pako.deflate(this.__buffer);
				break;
		}

		if (buffer != null)
		{
			this.__buffer = buffer;
			this.__view = new DataView(this.__buffer);
			this.__length = buffer.byteLength;
			this.position = this.__length;
		}
	}

	/**
		Compresses the byte array using the deflate compression algorithm. The
		entire byte array is compressed.

		After the call, the `length` property of the ByteArray is
		set to the new length. The `position` property is set to the
		end of the byte array.

		The deflate compression algorithm is described at
		[http://www.ietf.org/rfc/rfc1951.txt](http://www.ietf.org/rfc/rfc1951.txt).

		In order to use the deflate format to compress a ByteArray instance's
		data in a specific format such as gzip or zip, you cannot simply call
		`deflate()`. You must create a ByteArray structured according
		to the compression format's specification, including the appropriate
		metadata as well as the compressed data obtained using the deflate format.
		Likewise, in order to decode data compressed in a format such as gzip or
		zip, you can't simply call `inflate()` on that data. First, you
		must separate the metadata from the compressed data, and you can then use
		the deflate format to decompress the compressed data.
	**/
	public deflate(): void
	{
		this.compress(CompressionAlgorithm.DEFLATE);
	}

	/**
		Converts an ArrayBuffer into a ByteArray.

		@param	buffer	An ArrayBuffer instance
		@returns	A new ByteArray
	**/
	public static fromArrayBuffer(buffer: ArrayBuffer): ByteArray
	{
		if (buffer != null)
		{
			var byteArray = new ByteArray();
			byteArray.__buffer = buffer;
			byteArray.__length = buffer.byteLength;
			return byteArray;
		}
		else
		{
			return null;
		}
	}

	public get(pos: number): number
	{
		return this.__view.getUint8(pos);
	}

	/**
		Decompresses the byte array using the deflate compression algorithm. The
		byte array must have been compressed using the same algorithm.

		After the call, the `length` property of the ByteArray is
		set to the new length. The `position` property is set to 0.

		The deflate compression algorithm is described at
		[http://www.ietf.org/rfc/rfc1951.txt](http://www.ietf.org/rfc/rfc1951.txt).

		In order to decode data compressed in a format that uses the deflate
		compression algorithm, such as data in gzip or zip format, it will not
		work to simply call `inflate()` on a ByteArray containing the
		compression formation data. First, you must separate the metadata that is
		included as part of the compressed data format from the actual compressed
		data. For more information, see the `compress()` method
		description.

		@throws IOError The data is not valid compressed data; it was not
						compressed with the same compression algorithm used to
						compress.
	**/
	public inflate(): void
	{
		this.uncompress(CompressionAlgorithm.DEFLATE);
	}

	public static loadFromFile(path: string): Future<ByteArray>
	{
		// TODO
		return null;
	}

	/**
		Reads a Boolean value from the byte stream. A single byte is read, and
		`true` is returned if the byte is nonzero, `false`
		otherwise.

		@return Returns `true` if the byte is nonzero,
				`false` otherwise.
		@throws EOFError There is not sufficient data available to read.
	**/
	public readBoolean(): boolean
	{
		if (this.position < this.__length)
		{
			return (this.__view.getUint8(this.position++) != 0);
		}
		else
		{
			throw new EOFError();
			return false;
		}
	}

	/**
		Reads a signed byte from the byte stream.

		The returned value is in the range -128 to 127.

		@return An integer between -128 and 127.
		@throws EOFError There is not sufficient data available to read.
	**/
	public readByte(): number
	{
		var value = this.readUnsignedByte();

		if ((value & 0x80) != 0)
		{
			return value - 0x100;
		}
		else
		{
			return value;
		}
	}

	/**
			Reads the number of data bytes, specified by the `length`
			parameter, from the byte stream. The bytes are read into the ByteArray
			object specified by the `bytes` parameter, and the bytes are
			written into the destination ByteArray starting at the position specified
			by `offset`.

			@param bytes  The ByteArray object to read data into.
			@param offset The offset(this.position) in `bytes` at which the
						  read data should be written.
			@param length The number of bytes to read. The default value of 0 causes
						  all available data to be read.
			@throws EOFError   There is not sufficient data available to read.
			@throws RangeError The value of the supplied offset and length, combined,
							   is greater than the maximum for a uint.
		**/
	public readBytes(bytes: ByteArray, offset: number = 0, length: number = 0): void
	{
		if (length == 0) length = this.__length - this.position;

		if (this.position + length > this.__length)
		{
			throw new EOFError();
		}

		if (bytes.__length < offset + length)
		{
			bytes.__resize(offset + length);
		}

		if (bytes == this && offset > this.position)
		{
			var i = length;
			while (i > 0)
			{
				i--;
				this.__view.setUint8(i + offset, this.__view.getUint8(i + this.position));
			}
		}

		for (let i = 0; i < length; i++)
		{
			bytes.__view.setUint8(i + offset, this.__view.getUint8(i + this.position));
		}

		this.position += length;
	}

	/**
			Reads an IEEE 754 double-precision(64-bit) floating-point number from the
			byte stream.

			@return A double-precision(64-bit) floating-point number.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readDouble(): number
	{
		if (this.position + 8 > this.__length)
		{
			throw new EOFError();
			return 0;
		}

		this.position += 8;

		return this.__view.getFloat64(this.position - 8, this.__littleEndian);
	}

	/**
			Reads an IEEE 754 single-precision(32-bit) floating-point number from the
			byte stream.

			@return A single-precision(32-bit) floating-point number.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readFloat(): number
	{
		if (this.position + 4 > this.__length)
		{
			throw new EOFError();
			return 0;
		}

		this.position += 4;
		return this.__view.getFloat32(this.position - 4, this.__littleEndian);
	}

	/**
			Reads a signed 32-bit integer from the byte stream.

			The returned value is in the range -2147483648 to 2147483647.

			@return A 32-bit signed integer between -2147483648 and 2147483647.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readInt(): number
	{
		if (this.position + 4 > this.__length)
		{
			throw new EOFError();
			return 0;
		}

		this.position += 4;
		return this.__view.getInt32(this.position - 4, this.__littleEndian);
	}


	/**
		Reads a multibyte string of specified length from the byte stream using
		the specified character set.

		@param length  The number of bytes from the byte stream to read.
		@param charSet The string denoting the character set to use to interpret
					   the bytes. Possible character set strings include
					   `"shift-jis"`, `"cn-gb"`,
					   `"iso-8859-1"`, and others. For a complete list,
					   see <a href="../../charset-codes.html">Supported Character
					   Sets</a>.

					   **Note:** If the value for the `charSet`
					   parameter is not recognized by the current system, the
					   application uses the system's default code page as the
					   character set. For example, a value for the
					   `charSet` parameter, as in
					   `myTest.readMultiByte(22, "iso-8859-01")` that
					   uses `01` instead of `1` might work
					   on your development system, but not on another system. On
					   the other system, the application will use the system's
					   default code page.
		@return UTF-8 encoded string.
		@throws EOFError There is not sufficient data available to read.
	**/
	public readMultiByte(length: number, charSet: string): string
	{
		return this.readUTFBytes(length);
	}

	/**
			Reads an object from the byte array, encoded in AMF serialized format.

			@return The deserialized object.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readObject(): any
	{
		// TODO
		return null;
	}

	/**
		Reads a signed 16-bit integer from the byte stream.

		The returned value is in the range -32768 to 32767.

		@return A 16-bit signed integer between -32768 and 32767.
		@throws EOFError There is not sufficient data available to read.
	**/
	public readShort(): number
	{
		if (this.position + 2 > this.__length)
		{
			throw new EOFError();
			return 0;
		}

		this.position += 2;
		return this.__view.getInt16(this.position - 2, this.__littleEndian);
	}

	/**
			Reads an unsigned byte from the byte stream.

			The returned value is in the range 0 to 255.

			@return A 32-bit unsigned integer between 0 and 255.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readUnsignedByte(): number
	{
		if (this.position < this.__length)
		{
			return this.__view.getUint8(this.position++);
		}
		else
		{
			throw new EOFError();
			return 0;
		}
	}

	/**
			Reads an unsigned 32-bit integer from the byte stream.

			The returned value is in the range 0 to 4294967295.

			@return A 32-bit unsigned integer between 0 and 4294967295.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readUnsignedInt(): number
	{
		if (this.position + 4 > this.__length)
		{
			throw new EOFError();
			return 0;
		}

		this.position += 4;
		return this.__view.getUint32(this.position - 4, this.__littleEndian);
	}

	/**
			Reads an unsigned 16-bit integer from the byte stream.

			The returned value is in the range 0 to 65535.

			@return A 16-bit unsigned integer between 0 and 65535.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readUnsignedShort(): number
	{
		if (this.position + 2 > this.__length)
		{
			throw new EOFError();
			return 0;
		}

		this.position += 2;
		return this.__view.getUint16(this.position - 2, this.__littleEndian);
	}

	/**
			Reads a UTF-8 string from the byte stream. The string is assumed to be
			prefixed with an unsigned short indicating the length in bytes.

			@return UTF-8 encoded string.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readUTF(): string
	{
		var bytesCount = this.readUnsignedShort();
		return this.readUTFBytes(bytesCount);
	}

	/**
			Reads a sequence of UTF-8 bytes specified by the `length`
			parameter from the byte stream and returns a string.

			@param length An unsigned short indicating the length of the UTF-8 bytes.
			@return A string composed of the UTF-8 bytes of the specified length.
			@throws EOFError There is not sufficient data available to read.
		**/
	public readUTFBytes(length: number): string
	{
		if (this.position + length > this.__length)
		{
			throw new EOFError();
		}

		this.position += length;

		var decoder = new TextDecoder();
		return decoder.decode(new Uint8Array(this.__buffer, this.position - length, length));
	}

	public set(pos: number, v: number): void
	{
		this.__view.setUint8(pos, v & 0xFF);
	}

	/**
			Converts the byte array to a string. If the data in the array begins with
			a Unicode byte order mark, the application will honor that mark when
			converting to a string. If `System.useCodePage` is set to
			`true`, the application will treat the data in the array as
			being in the current system code page when converting.

			@return The string representation of the byte array.
		**/
	public toString(): string
	{
		var cachePosition = this.position;
		this.position = 0;
		var result = this.readUTFBytes(this.__length);
		this.position = cachePosition;
		return result;
	}

	/**
			Decompresses the byte array. For content running in Adobe AIR, you can
			specify a compression algorithm by passing a value(defined in the
			CompressionAlgorithm class) as the `algorithm` parameter. The
			byte array must have been compressed using the same algorithm. Flash
			Player supports only the default algorithm, zlib.

			After the call, the `length` property of the ByteArray is
			set to the new length. The `position` property is set to 0.

			The zlib compressed data format is described at
			[http://www.ietf.org/rfc/rfc1950.txt](http://www.ietf.org/rfc/rfc1950.txt).

			The deflate compression algorithm is described at
			[http://www.ietf.org/rfc/rfc1951.txt](http://www.ietf.org/rfc/rfc1951.txt).

			In order to decode data compressed in a format that uses the deflate
			compression algorithm, such as data in gzip or zip format, it will not
			work to call `uncompress(CompressionAlgorithm.DEFLATE)` on a
			ByteArray containing the compression formation data. First, you must
			separate the metadata that is included as part of the compressed data
			format from the actual compressed data. For more information, see the
			`compress()` method description.

			@throws IOError The data is not valid compressed data; it was not
							compressed with the same compression algorithm used to
							compress.
		**/
	public uncompress(algorithm: CompressionAlgorithm = CompressionAlgorithm.ZLIB): void
	{
		var buffer = null;

		if (this.__buffer.byteLength > this.__length)
		{
			buffer = new ArrayBuffer(this.__length);
			new Uint8Array(buffer).set(new Uint8Array(this.__buffer));
			this.__buffer = buffer;
			this.__view = new DataView(this.__buffer);
		}

		switch (algorithm)
		{
			case CompressionAlgorithm.DEFLATE:
				buffer = pako.inflateRaw(this.__buffer);
				break;

			case CompressionAlgorithm.LZMA:
				// TODO
				break;

			default:
				buffer = pako.inflate(this.__buffer);
				break;
		};

		if (buffer != null)
		{
			this.__buffer = buffer;
			this.__view = new DataView(this.__buffer);
			this.__length = buffer.byteLength;
		}

		this.position = 0;
	}

	/**
			Writes a Boolean value. A single byte is written according to the
			`value` parameter, either 1 if `true` or 0 if
			`false`.

			@param value A Boolean value determining which byte is written. If the
						 parameter is `true`, the method writes a 1; if
						 `false`, the method writes a 0.
		**/
	public writeBoolean(value: boolean): void
	{
		this.writeByte(value ? 1 : 0);
	}

	/**
		Writes a byte to the byte stream.

		The low 8 bits of the parameter are used. The high 24 bits are ignored.


		@param value A 32-bit integer. The low 8 bits are written to the byte
					 stream.
	**/
	public writeByte(value: number): void
	{
		this.__resize(this.position + 1);
		this.__view.setUint8(this.position++, value & 0xFF);
	}

	/**
			Writes a sequence of `length` bytes from the specified byte
			array, `bytes`, starting `offset`(zero-based index)
			bytes into the byte stream.

			If the `length` parameter is omitted, the default length of
			0 is used; the method writes the entire buffer starting at
			`offset`. If the `offset` parameter is also omitted,
			the entire buffer is written.

			If `offset` or `length` is out of range, they are
			clamped to the beginning and end of the `bytes` array.

			@param bytes  The ByteArray object.
			@param offset A zero-based index indicating the position into the array to
						  begin writing.
			@param length An unsigned integer indicating how far into the buffer to
						  write.
		**/
	public writeBytes(bytes: ByteArray, offset: number = 0, length: number = 0): void
	{
		if (bytes.__length == 0) return;
		if (length == 0) length = bytes.__length - offset;

		this.__resize(this.position + length);

		if (bytes == this && offset > this.position)
		{
			var i = length;
			while (i > 0)
			{
				i--;
				this.__view.setUint8(i + offset, this.__view.getUint8(i + this.position));
			}
		}

		for (let i = 0; i < length; i++)
		{
			this.__view.setUint8(i + offset, bytes.__view.getUint8(i + this.position));
		}

		this.position += length;
	}

	/**
			Writes an IEEE 754 double-precision(64-bit) floating-point number to the
			byte stream.

			@param value A double-precision(64-bit) floating-point number.
		**/
	public writeDouble(value: number): void
	{
		this.__resize(this.position + 8);
		this.__view.setFloat64(this.position, value, this.__littleEndian);
		this.position += 8;
	}

	/**
			Writes an IEEE 754 single-precision(32-bit) floating-point number to the
			byte stream.

			@param value A single-precision(32-bit) floating-point number.
		**/
	public writeFloat(value: number): void
	{
		this.__resize(this.position + 4);
		this.__view.setFloat32(this.position, value, this.__littleEndian);
		this.position += 4;
	}

	/**
			Writes a 32-bit signed integer to the byte stream.

			@param value An integer to write to the byte stream.
		**/
	public writeInt(value: number): void
	{
		this.__resize(this.position + 4);
		this.__view.setInt32(this.position, value, this.__littleEndian);
		this.position += 4;
	}

	/**
			Writes a multibyte string to the byte stream using the specified character
			set.

			@param value   The string value to be written.
			@param charSet The string denoting the character set to use. Possible
						   character set strings include `"shift-jis"`,
						   `"cn-gb"`, `"iso-8859-1"`, and
						   others. For a complete list, see <a
						   href="../../charset-codes.html">Supported Character
						   Sets</a>.
		**/
	public writeMultiByte(value: string, charSet: string): void
	{
		this.writeUTFBytes(value);
	}

	/**
		Writes an object into the byte array in AMF serialized format.

		@param object The object to serialize.
	**/
	public writeObject(object: any): void
	{
		// TODO
	}

	/**
		Writes a 16-bit integer to the byte stream. The low 16 bits of the
		parameter are used. The high 16 bits are ignored.

		@param value 32-bit integer, whose low 16 bits are written to the byte
					 stream.
	**/
	public writeShort(value: number): void
	{
		this.__resize(this.position + 2);
		this.__view.setInt16(this.position, value, this.__littleEndian);
		this.position += 2;
	}

	/**
			Writes a 32-bit unsigned integer to the byte stream.

			@param value An unsigned integer to write to the byte stream.
		**/
	public writeUnsignedInt(value: number): void
	{
		this.__resize(this.position + 4);
		this.__view.setUint32(this.position, value, this.__littleEndian);
		this.position += 4;
	}

	/**
		Writes a UTF-8 string to the byte stream. The length of the UTF-8 string
		in bytes is written first, as a 16-bit integer, followed by the bytes
		representing the characters of the string.

		@param value The string value to be written.
		@throws RangeError If the length is larger than 65535.
	**/
	public writeUTF(value: string): void
	{
		var encoder = new TextEncoder();
		var bytes = encoder.encode(value);

		this.__resize(this.position + bytes.byteLength + 2);
		this.writeShort(bytes.length);
		new Uint8Array(this.__buffer).set(bytes, this.position);
		this.position += bytes.byteLength;
	}

	/**
		Writes a UTF-8 string to the byte stream. Similar to the
		`writeUTF()` method, but `writeUTFBytes()` does not
		prefix the string with a 16-bit length word.

		@param value The string value to be written.
	**/
	public writeUTFBytes(value: string): void
	{
		var encoder = new TextEncoder();
		var bytes = encoder.encode(value);

		this.__resize(this.position + bytes.byteLength);
		new Uint8Array(this.__buffer).set(bytes, this.position);
		this.position += bytes.byteLength;
	}

	protected __resize(size: number): void
	{
		if (size > this.__length)
		{
			if (size > this.__buffer.byteLength)
			{
				var buffer = new ArrayBuffer(((size + 1) * 3) >> 1);

				if (this.__length > 0)
				{
					new Uint8Array(buffer).set(new Uint8Array(this.__buffer));
				}

				this.__buffer = buffer;
				this.__view = new DataView(this.__buffer);
			}

			this.__length = size;
		}
	}

	// Get & Set Methods

	/**
		The number of bytes of data available for reading from the current
		position in the byte array to the end of the array.

		Use the `bytesAvailable` property in conjunction with the
		read methods each time you access a ByteArray object to ensure that you
		are reading valid data.
	**/
	public get bytesAvailable(): number
	{
		return this.__length - this.position;
	}

	/**
		Denotes the default endianness for the ByteArray class to use for a
		new ByteArray instance. When you create a new ByteArray instance, the
		endian value on that instance starts with the value of
		`defaultEndian`. The `defaultEndian`
		property is initialized to the default system endianness. This will
		most likely be `Endian.LITTLE_ENDIAN` on the majority platforms
		except for the Flash runtime.

		On Flash and AIR targets, this property cannot be changed and will
		always be set to `Endian.BIG_ENDIAN`.
	**/
	public static get defaultEndian(): Endian
	{
		if (ByteArray.__defaultEndian == null)
		{
			var arrayBuffer = new ArrayBuffer(2);
			var uint8Array = new Uint8Array(arrayBuffer);
			var uint16array = new Uint16Array(arrayBuffer);
			uint8Array[0] = 0xAA;
			uint8Array[1] = 0xBB;
			if (uint16array[0] == 0xAABB)
			{
				ByteArray.__defaultEndian = Endian.BIG_ENDIAN;
			}
			else
			{
				ByteArray.__defaultEndian = Endian.LITTLE_ENDIAN;
			}
		}

		return ByteArray.__defaultEndian;
	}

	public static set defaultEndian(value: Endian)
	{
		ByteArray.__defaultEndian = value;
	}

	/**
		Changes or reads the byte order for the data; either
		`Endian.BIG_ENDIAN` or `Endian.LITTLE_ENDIAN`.
	**/
	public get endian(): Endian
	{
		return this.__littleEndian ? Endian.LITTLE_ENDIAN : Endian.BIG_ENDIAN;
	}

	public set endian(value: Endian)
	{
		this.__littleEndian = (value == Endian.LITTLE_ENDIAN);
	}

	/**
		The length of the ByteArray object, in bytes.

		If the length is set to a value that is larger than the current length,
		the right side of the byte array is filled with zeros.

		If the length is set to a value that is smaller than the current
		length, the byte array is truncated.
	**/
	public get length(): number
	{
		return this.__length;
	}

	public set length(value: number)
	{
		if (value > 0)
		{
			this.__resize(value);
			if (value < this.position) this.position = value;
		}

		this.__length = value;
	}
}
