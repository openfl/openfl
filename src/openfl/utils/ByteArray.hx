package openfl.utils;

import haxe.Constraints.IMap;
import haxe.ds.ObjectMap;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.FPHelper;
import haxe.Json;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.errors.EOFError;
import openfl.net.ObjectEncoding;
#if lime
import lime.system.System;
import lime.utils.ArrayBuffer;
import lime.utils.BytePointer;
import lime.utils.Bytes as LimeBytes;
import lime.utils.DataPointer;
#end
#if format
import format.amf.Reader as AMFReader;
import format.amf.Tools as AMFTools;
import format.amf.Writer as AMFWriter;
import format.amf.Value as AMFValue;
import format.amf3.Reader as AMF3Reader;
import format.amf3.Tools as AMF3Tools;
import format.amf3.Value as AMF3Value;
import format.amf3.Writer as AMF3Writer;
#end

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
@:access(haxe.io.Bytes)
@:access(openfl.utils.ByteArrayData)
// TODO: Remove if bug that breaks `byteArray.endian = BIG_ENDIAN` is fixed
#if !openfl_doc_gen
@:forward(endian, objectEncoding)
#end
@:transitive
abstract ByteArray(ByteArrayData) from ByteArrayData to ByteArrayData
{
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
	public static var defaultEndian(get, set):Endian;

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
	public static var defaultObjectEncoding(get, set):ObjectEncoding;

	#if lime
	@:noCompletion private static var __bytePointer = new BytePointer();
	#end

	/**
		The number of bytes of data available for reading from the current
		position in the byte array to the end of the array.

		Use the `bytesAvailable` property in conjunction with the
		read methods each time you access a ByteArray object to ensure that you
		are reading valid data.
	**/
	public var bytesAvailable(get, never):UInt;

	#if openfl_doc_gen
	/**
		Changes or reads the byte order for the data; either
		`Endian.BIG_ENDIAN` or `Endian.LITTLE_ENDIAN`.
	**/
	public var endian(get, set):Endian;
	#end

	/**
		The length of the ByteArray object, in bytes.

		If the length is set to a value that is larger than the current length,
		the right side of the byte array is filled with zeros.

		If the length is set to a value that is smaller than the current
		length, the byte array is truncated.
	**/
	public var length(get, set):UInt;

	#if openfl_doc_gen
	/**
		* Used to determine whether the ActionScript 3.0, ActionScript 2.0, or
		* ActionScript 1.0 format should be used when writing to, or reading from, a
		* ByteArray instance. The value is a constant from the ObjectEncoding class.

		* On the Flash and AIR targets, support for Action Message Format (AMF) object
		* serialization is included in the Flash runtime. For other targets, AMF
		* serialization is supported if your project using built using the optional
		* "format" library, such as `<haxelib name="format" />` in a project.xml file.
		*
		* Additional OpenFL targets support reading and writing of objects using
		* Haxe Serialization Format (HXSF) and JavaScript Object Notation (JSON). These
		* targets use HXSF by default.
		*
		* Since these additional object serialization formats are not internal to the
		* Flash runtime, they are not supported by the `readObject` or `writeObject`
		* functions on the Flash or AIR targets, but through `haxe.Serializer`,
		* `haxe.Unserializer` or `haxe.JSON` if needed.
	**/
	public var objectEncoding(get, set):ObjectEncoding;
	#end

	/**
		Moves, or returns the current position, in bytes, of the file pointer into
		the ByteArray object. This is the point at which the next call to a read
		method starts reading or a write method starts writing.
	**/
	public var position(get, set):UInt;

	/**
		Creates a ByteArray instance representing a packed array of bytes, so that
		you can use the methods and properties in this class to optimize your data
		storage and stream.
	**/
	public inline function new(length:Int = 0):Void
	{
		#if (display || flash)
		this = new ByteArrayData();
		this.length = length;
		#else
		this = new ByteArrayData(length);
		#end
	}

	/**
		Clears the contents of the byte array and resets the `length`
		and `position` properties to 0. Calling this method explicitly
		frees up the memory used by the ByteArray instance.

	**/
	public inline function clear():Void
	{
		this.clear();
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
	public inline function compress(algorithm:CompressionAlgorithm = null):Void
	{
		#if flash
		return (algorithm == null) ? this.compress() : this.compress(algorithm);
		#else
		return this.compress(algorithm);
		#end
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
	public inline function deflate():Void
	{
		this.deflate();
	}

	#if lime
	/**
		Converts an ArrayBuffer into a ByteArray.

		@param	buffer	An ArrayBuffer instance
		@returns	A new ByteArray
	**/
	@:from public static function fromArrayBuffer(buffer:ArrayBuffer):ByteArray
	{
		if (buffer == null) return null;

		#if display
		return null;
		#elseif js
		return ByteArrayData.fromBytes(Bytes.ofData(buffer));
		#elseif flash
		return (buffer : Bytes).getData();
		#else
		return ByteArrayData.fromBytes((buffer : Bytes));
		#end
	}
	#end

	/**
		Converts a Bytes object into a ByteArray.

		@param	buffer	A Bytes instance
		@returns	A new ByteArray
	**/
	@:from public static function fromBytes(bytes:Bytes):ByteArray
	{
		if (bytes == null) return null;

		#if display
		return null;
		#else
		if ((bytes is ByteArrayData))
		{
			return cast bytes;
		}
		else
		{
			#if flash
			return bytes.getData();
			#else
			return ByteArrayData.fromBytes(bytes);
			#end
		}
		#end
	}

	/**
		Converts a BytesData object into a ByteArray.

		@param	buffer	A BytesData instance
		@returns	A new ByteArray
	**/
	@:from @:noCompletion public static function fromBytesData(bytesData:BytesData):ByteArray
	{
		if (bytesData == null) return null;

		#if display
		return null;
		#elseif flash
		return bytesData;
		#else
		return ByteArrayData.fromBytes(Bytes.ofData(bytesData));
		#end
	}

	/**
		Creates a new ByteArray from a file path synchronously. This means that the
		ByteArray will be returned immediately (if supported).

		HTML5 and Flash do not support loading files synchronously, so these targets
		always return `null`.

		In order to load files from a remote web address, use the `loadFromFile` method,
		which supports asynchronous loading.

		@param	path	A local file path
		@returns	A new ByteArray if successful, or `null` if unsuccessful
	**/
	public static function fromFile(path:String):ByteArray
	{
		#if lime
		return LimeBytes.fromFile(path);
		#else
		return null;
		#end
	}

	#if lime
	/**
		Converts a Lime Bytes object into a ByteArray.

		@param	buffer	A Lime Bytes instance
		@returns	A new ByteArray
	**/
	@:from @:noCompletion public static function fromLimeBytes(bytes:LimeBytes):ByteArray
	{
		return fromBytes(bytes);
	}
	#end

	@:arrayAccess @:noCompletion private inline function get(index:Int):Int
	{
		#if display
		return 0;
		#elseif flash
		return this[index];
		#else
		return this.get(index);
		#end
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
	public inline function inflate():Void
	{
		this.inflate();
	}

	/**
		Creates a new ByteArray from haxe.io.Bytes. Progress, completion and error
		callbacks will be dispatched using callbacks attached to a returned Future
		object.

		@param	bytes	A haxe.io.Bytes instance
		@returns	A Future ByteArray
	**/
	public static function loadFromBytes(bytes:Bytes):Future<ByteArray>
	{
		#if lime
		return LimeBytes.loadFromBytes(bytes).then(function(limeBytes:LimeBytes)
		{
			var byteArray:ByteArray = limeBytes;
			return Future.withValue(byteArray);
		});
		#else
		return cast Future.withError("Cannot load ByteArray from bytes");
		#end
	}

	/**
		Creates a new ByteArray from a file path or web address asynchronously. The file
		load will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	path	A local file path or web address
		@returns	A Future ByteArray
	**/
	public static function loadFromFile(path:String):Future<ByteArray>
	{
		#if lime
		return LimeBytes.loadFromFile(path).then(function(limeBytes:LimeBytes)
		{
			var byteArray:ByteArray = limeBytes;
			return Future.withValue(byteArray);
		});
		#else
		return cast Future.withError("Cannot load ByteArray from file");
		#end
	}

	/**
		Reads a Boolean value from the byte stream. A single byte is read, and
		`true` is returned if the byte is nonzero, `false`
		otherwise.

		@return Returns `true` if the byte is nonzero,
				`false` otherwise.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readBoolean():Bool
	{
		return this.readBoolean();
	}

	/**
		Reads a signed byte from the byte stream.

		The returned value is in the range -128 to 127.

		@return An integer between -128 and 127.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readByte():Int
	{
		return this.readByte();
	}

	/**
		Reads the number of data bytes, specified by the `length`
		parameter, from the byte stream. The bytes are read into the ByteArray
		object specified by the `bytes` parameter, and the bytes are
		written into the destination ByteArray starting at the position specified
		by `offset`.

		@param bytes  The ByteArray object to read data into.
		@param offset The offset(position) in `bytes` at which the
					  read data should be written.
		@param length The number of bytes to read. The default value of 0 causes
					  all available data to be read.
		@throws EOFError   There is not sufficient data available to read.
		@throws RangeError The value of the supplied offset and length, combined,
						   is greater than the maximum for a uint.
	**/
	public inline function readBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
	{
		this.readBytes(bytes, offset, length);
	}

	/**
		Reads an IEEE 754 double-precision(64-bit) floating-point number from the
		byte stream.

		@return A double-precision(64-bit) floating-point number.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readDouble():Float
	{
		return this.readDouble();
	}

	/**
		Reads an IEEE 754 single-precision(32-bit) floating-point number from the
		byte stream.

		@return A single-precision(32-bit) floating-point number.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readFloat():Float
	{
		return this.readFloat();
	}

	/**
		Reads a signed 32-bit integer from the byte stream.

		The returned value is in the range -2147483648 to 2147483647.

		@return A 32-bit signed integer between -2147483648 and 2147483647.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readInt():Int
	{
		return this.readInt();
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
	public inline function readMultiByte(length:UInt, charSet:String):String
	{
		return this.readMultiByte(length, charSet);
	}

	/**
		Reads an object from the byte array, encoded in AMF serialized format.

		@return The deserialized object.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readObject():Dynamic
	{
		return this.readObject();
	}

	/**
		Reads a signed 16-bit integer from the byte stream.

		The returned value is in the range -32768 to 32767.

		@return A 16-bit signed integer between -32768 and 32767.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readShort():Int
	{
		return this.readShort();
	}

	/**
		Reads a UTF-8 string from the byte stream. The string is assumed to be
		prefixed with an unsigned short indicating the length in bytes.

		@return UTF-8 encoded string.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readUTF():String
	{
		return this.readUTF();
	}

	/**
		Reads a sequence of UTF-8 bytes specified by the `length`
		parameter from the byte stream and returns a string.

		@param length An unsigned short indicating the length of the UTF-8 bytes.
		@return A string composed of the UTF-8 bytes of the specified length.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readUTFBytes(length:UInt):String
	{
		return this.readUTFBytes(length);
	}

	/**
		Reads an unsigned byte from the byte stream.

		The returned value is in the range 0 to 255.

		@return A 32-bit unsigned integer between 0 and 255.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readUnsignedByte():UInt
	{
		return this.readUnsignedByte();
	}

	/**
		Reads an unsigned 32-bit integer from the byte stream.

		The returned value is in the range 0 to 4294967295.

		@return A 32-bit unsigned integer between 0 and 4294967295.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readUnsignedInt():UInt
	{
		return this.readUnsignedInt();
	}

	/**
		Reads an unsigned 16-bit integer from the byte stream.

		The returned value is in the range 0 to 65535.

		@return A 16-bit unsigned integer between 0 and 65535.
		@throws EOFError There is not sufficient data available to read.
	**/
	public inline function readUnsignedShort():UInt
	{
		return this.readUnsignedShort();
	}

	@:arrayAccess @:noCompletion private inline function set(index:Int, value:Int):Int
	{
		#if display
		#elseif flash
		this[index] = value;
		#else
		this.__resize(index + 1);
		this.set(index, value);
		#end
		return value;
	}

	#if lime
	/**
		Converts a ByteArray into an ArrayBuffer.

		@param	buffer	A ByteArray instance
		@returns	A new ArrayBuffer
	**/
	@:to @:noCompletion public static function toArrayBuffer(byteArray:ByteArray):ArrayBuffer
	{
		#if display
		return null;
		#elseif js
		return (byteArray : ByteArrayData).getData();
		#elseif flash
		return Bytes.ofData(byteArray);
		#else
		return (byteArray : ByteArrayData);
		#end
	}
	#end

	#if lime
	@:to @:noCompletion private static function toBytePointer(byteArray:ByteArray):BytePointer
	{
		#if !display
		__bytePointer.set(#if flash byteArray #else (byteArray : ByteArrayData) #end, byteArray.position);
		#end
		return __bytePointer;
	}
	#end

	#if lime
	#if (sys || display)
	@:to @:noCompletion private static function toDataPointer(byteArray:ByteArray):DataPointer
	{
		#if !display
		__bytePointer.set((byteArray : ByteArrayData), byteArray.position);
		#end
		return __bytePointer;
	}
	#end
	#end
	@:to @:noCompletion private static function toBytes(byteArray:ByteArray):Bytes
	{
		#if display
		return null;
		#elseif flash
		return Bytes.ofData(byteArray);
		#else
		return (byteArray : ByteArrayData);
		#end
	}

	#if !display
	@:to @:noCompletion private static function toBytesData(byteArray:ByteArray):BytesData
	{
		#if display
		return null;
		#elseif flash
		return byteArray;
		#else
		return (byteArray : ByteArrayData).getData();
		#end
	}
	#end

	#if lime
	@:to @:noCompletion private static function toLimeBytes(byteArray:ByteArray):LimeBytes
	{
		#if display
		return null;
		#elseif flash
		return Bytes.ofData(byteArray);
		#else
		return (byteArray : ByteArrayData);
		#end
	}
	#end

	/**
		Converts the byte array to a string. If the data in the array begins with
		a Unicode byte order mark, the application will honor that mark when
		converting to a string. If `System.useCodePage` is set to
		`true`, the application will treat the data in the array as
		being in the current system code page when converting.

		@return The string representation of the byte array.
	**/
	public inline function toString():String
	{
		return this.toString();
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
	public inline function uncompress(algorithm:CompressionAlgorithm = null):Void
	{
		#if flash
		return (algorithm == null) ? this.uncompress() : this.uncompress(algorithm);
		#else
		return this.uncompress(algorithm);
		#end
	}

	/**
		Writes a Boolean value. A single byte is written according to the
		`value` parameter, either 1 if `true` or 0 if
		`false`.

		@param value A Boolean value determining which byte is written. If the
					 parameter is `true`, the method writes a 1; if
					 `false`, the method writes a 0.
	**/
	public inline function writeBoolean(value:Bool):Void
	{
		this.writeBoolean(value);
	}

	/**
		Writes a byte to the byte stream.

		The low 8 bits of the parameter are used. The high 24 bits are ignored.


		@param value A 32-bit integer. The low 8 bits are written to the byte
					 stream.
	**/
	public inline function writeByte(value:Int):Void
	{
		this.writeByte(value);
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
	public inline function writeBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
	{
		this.writeBytes(bytes, offset, length);
	}

	/**
		Writes an IEEE 754 double-precision(64-bit) floating-point number to the
		byte stream.

		@param value A double-precision(64-bit) floating-point number.
	**/
	public inline function writeDouble(value:Float):Void
	{
		this.writeDouble(value);
	}

	/**
		Writes an IEEE 754 single-precision(32-bit) floating-point number to the
		byte stream.

		@param value A single-precision(32-bit) floating-point number.
	**/
	public inline function writeFloat(value:Float):Void
	{
		this.writeFloat(value);
	}

	/**
		Writes a 32-bit signed integer to the byte stream.

		@param value An integer to write to the byte stream.
	**/
	public inline function writeInt(value:Int):Void
	{
		this.writeInt(value);
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
	public inline function writeMultiByte(value:String, charSet:String):Void
	{
		this.writeMultiByte(value, charSet);
	}

	/**
		Writes an object into the byte array in AMF serialized format.

		@param object The object to serialize.
	**/
	public inline function writeObject(object:Dynamic):Void
	{
		this.writeObject(object);
	}

	/**
		Writes a 16-bit integer to the byte stream. The low 16 bits of the
		parameter are used. The high 16 bits are ignored.

		@param value 32-bit integer, whose low 16 bits are written to the byte
					 stream.
	**/
	public inline function writeShort(value:Int):Void
	{
		this.writeShort(value);
	}

	/**
		Writes a UTF-8 string to the byte stream. The length of the UTF-8 string
		in bytes is written first, as a 16-bit integer, followed by the bytes
		representing the characters of the string.

		@param value The string value to be written.
		@throws RangeError If the length is larger than 65535.
	**/
	public inline function writeUTF(value:String):Void
	{
		this.writeUTF(value);
	}

	/**
		Writes a UTF-8 string to the byte stream. Similar to the
		`writeUTF()` method, but `writeUTFBytes()` does not
		prefix the string with a 16-bit length word.

		@param value The string value to be written.
	**/
	public inline function writeUTFBytes(value:String):Void
	{
		this.writeUTFBytes(value);
	}

	/**
		Writes a 32-bit unsigned integer to the byte stream.

		@param value An unsigned integer to write to the byte stream.
	**/
	public inline function writeUnsignedInt(value:UInt):Void
	{
		this.writeUnsignedInt(value);
	}

	// Get & Set Methods
	@:noCompletion private inline function get_bytesAvailable():UInt
	{
		return this.bytesAvailable;
	}

	@:noCompletion private inline static function get_defaultEndian():Endian
	{
		return ByteArrayData.defaultEndian;
	}

	@:noCompletion private inline static function set_defaultEndian(value:Endian):Endian
	{
		return ByteArrayData.defaultEndian = value;
	}

	@:noCompletion private inline static function get_defaultObjectEncoding():ObjectEncoding
	{
		return ByteArrayData.defaultObjectEncoding;
	}

	@:noCompletion private inline static function set_defaultObjectEncoding(value:ObjectEncoding):ObjectEncoding
	{
		return ByteArrayData.defaultObjectEncoding = value;
	}

	@:noCompletion private inline function get_endian():Endian
	{
		return this.endian;
	}

	@:noCompletion private inline function set_endian(value:Endian):Endian
	{
		return this.endian = value;
	}

	@:noCompletion private function get_length():UInt
	{
		#if display
		return 0;
		#elseif lime_bytes_length_getter
		return this == null ? 0 : this.l;
		#else
		return this == null ? 0 : this.length;
		#end
	}

	@:noCompletion private function set_length(value:Int):UInt
	{
		#if display
		#elseif flash
		this.length = value;
		#elseif lime_bytes_length_getter
		this.length = value;
		#else
		if (value > 0)
		{
			this.__resize(value);
			if (value < this.position) this.position = value;
		}

		this.length = value;
		#end

		return value;
	}

	@:noCompletion private inline function get_objectEncoding():ObjectEncoding
	{
		return this.objectEncoding;
	}

	@:noCompletion private inline function set_objectEncoding(value:ObjectEncoding):ObjectEncoding
	{
		return this.objectEncoding = value;
	}

	@:noCompletion private inline function get_position():UInt
	{
		return this.position;
	}

	@:noCompletion private inline function set_position(value:UInt):UInt
	{
		return this.position = value;
	}
}

#if (!display && !flash)
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:autoBuild(lime._internal.macros.AssetsMacro.embedByteArray())
@:noCompletion @:dox(hide) class ByteArrayData extends Bytes implements IDataInput implements IDataOutput
{
	public static var defaultEndian(get, set):Endian;
	public static var defaultObjectEncoding:ObjectEncoding = ObjectEncoding.DEFAULT;
	@:noCompletion private static var __defaultEndian:Endian = null;

	public var bytesAvailable(get, never):UInt;
	public var endian(get, set):Endian;
	public var objectEncoding:ObjectEncoding;
	public var position:Int;

	@:noCompletion private var __endian:Endian;
	@:noCompletion private var __length:Int;

	#if lime_bytes_length_getter
	@:noCompletion private static function __init__()
	{
		untyped global.Object.defineProperty(ByteArrayData, "defaultEndian", {
			get: function()
			{
				return ByteArrayData.get_defaultEndian();
			},
			set: function(v)
			{
				return ByteArrayData.set_defaultEndian(v);
			}
		});
		untyped global.Object.defineProperties(ByteArrayData.prototype, {
			"bytesAvailable": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_bytesAvailable (); }")
			},
			"endian": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_endian (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_endian (v); }")
			},
			"length": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_length (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_length (v); }")
			},
		});
	}
	#end

	public function new(length:Int = 0)
	{
		var bytes = Bytes.alloc(length);

		#if sys
		if (length > 0)
		{
			bytes.fill(0, length, 0);
		}
		#end

		#if hl
		super(bytes.getData(), length);
		#elseif js
		super(bytes.b.buffer);
		#else
		super(length, bytes.getData());
		#end

		__length = length;

		endian = defaultEndian;
		objectEncoding = defaultObjectEncoding;
		position = 0;
	}

	public function clear():Void
	{
		length = 0;
		position = 0;
	}

	public function compress(algorithm:CompressionAlgorithm = ZLIB):Void
	{
		#if lime
		#if js
		if (__length > #if lime_bytes_length_getter l #else length #end)
		{
			var cacheLength = #if lime_bytes_length_getter l #else length #end;
			#if lime_bytes_length_getter
			this.l = __length;
			#else
			this.length = __length;
			#end
			var data = Bytes.alloc(cacheLength);
			data.blit(0, this, 0, cacheLength);
			__setData(data);
			#if lime_bytes_length_getter
			this.l = cacheLength;
			#else
			this.length = cacheLength;
			#end
		}
		#end

		var limeBytes:LimeBytes = this;

		var bytes = switch (algorithm)
		{
			case CompressionAlgorithm.DEFLATE: limeBytes.compress(DEFLATE);
			case CompressionAlgorithm.LZMA: limeBytes.compress(LZMA);
			default: limeBytes.compress(ZLIB);
		}

		if (bytes != null)
		{
			__setData(bytes);

			#if lime_bytes_length_getter
			l
			#else
			length
			#end
			= __length;
			position = #if lime_bytes_length_getter l #else length #end;
		}
		#end
	}

	public function deflate():Void
	{
		compress(CompressionAlgorithm.DEFLATE);
	}

	#if openfljs
	public static function fromArrayBuffer(buffer:ArrayBuffer):ByteArrayData
	{
		return ByteArray.fromArrayBuffer(buffer);
	}
	#end

	public static function fromBytes(bytes:Bytes):ByteArrayData
	{
		var result = new ByteArrayData();
		result.__fromBytes(bytes);
		return result;
	}

	public function inflate():Void
	{
		uncompress(CompressionAlgorithm.DEFLATE);
	}

	#if openfljs
	public static function loadFromBytes(bytes:Bytes):Future<ByteArray>
	{
		return ByteArray.loadFromBytes(bytes);
	}

	public static function loadFromFile(path:String):Future<ByteArray>
	{
		return ByteArray.loadFromFile(path);
	}
	#end

	public function readBoolean():Bool
	{
		if (position < #if lime_bytes_length_getter l #else length #end)
		{
			return (get(position++) != 0);
		}
		else
		{
			throw new EOFError();
			return false;
		}
	}

	public function readByte():Int
	{
		var value = readUnsignedByte();

		if (value & 0x80 != 0)
		{
			return value - 0x100;
		}
		else
		{
			return value;
		}
	}

	public function readBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void
	{
		if (length == 0) length = #if lime_bytes_length_getter l #else this.length #end - position;

		if (position + length > #if lime_bytes_length_getter l #else this.length #end)
		{
			throw new EOFError();
		}

		if ((bytes : ByteArrayData).length < offset + length)
		{
			(bytes : ByteArrayData).__resize(offset + length);
		}

		(bytes : ByteArrayData).blit(offset, this, position, length);
		position += length;
	}

	public function readDouble():Float
	{
		if (endian == LITTLE_ENDIAN)
		{
			if (position + 8 > #if lime_bytes_length_getter l #else length #end)
			{
				throw new EOFError();
				return 0;
			}

			position += 8;
			return getDouble(position - 8);
		}
		else
		{
			var ch1 = readInt();
			var ch2 = readInt();

			return FPHelper.i64ToDouble(ch2, ch1);
		}
	}

	public function readFloat():Float
	{
		if (endian == LITTLE_ENDIAN)
		{
			if (position + 4 > #if lime_bytes_length_getter l #else length #end)
			{
				throw new EOFError();
				return 0;
			}

			position += 4;
			return getFloat(position - 4);
		}
		else
		{
			return FPHelper.i32ToFloat(readInt());
		}
	}

	public function readInt():Int
	{
		var ch1 = readUnsignedByte();
		var ch2 = readUnsignedByte();
		var ch3 = readUnsignedByte();
		var ch4 = readUnsignedByte();

		if (endian == LITTLE_ENDIAN)
		{
			return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
		}
		else
		{
			return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
		}
	}

	public function readMultiByte(length:Int, charSet:String):String
	{
		return readUTFBytes(length);
	}

	public function readObject():Dynamic
	{
		switch (objectEncoding)
		{
			#if format
			case AMF0:
				var input = new BytesInput(this, position);
				var reader = new AMFReader(input);
				var data = unwrapAMFValue(reader.read());
				position = input.position;
				return data;

			case AMF3:
				var input = new BytesInput(this, position);
				var reader = new AMF3Reader(input);
				var data = unwrapAMF3Value(reader.read());
				position = input.position;
				return data;
			#end

			case HXSF:
				var data = readUTF();
				return Unserializer.run(data);

			case JSON:
				var data = readUTF();
				return Json.parse(data);

			default:
				return null;
		}
	}

	#if format
	private static function unwrapAMFValue(val:AMFValue):Dynamic
	{
		switch (val)
		{
			case ANumber(f):
				return f;
			case ABool(b):
				return b;
			case AString(s):
				return s;
			case ADate(d):
				return d;
			case AUndefined:
				return null;
			case ANull:
				return null;
			case AArray(vals):
				return vals.map(unwrapAMFValue);

			case AObject(vmap):
				// AMF0 has no distinction between Object/Map. Most likely we want an anonymous object here.
				var obj = {};
				for (name in vmap.keys())
				{
					Reflect.setField(obj, name, unwrapAMFValue(vmap.get(name)));
				}
				return obj;
		};
	}

	private static function unwrapAMF3Value(val:AMF3Value):Dynamic
	{
		return switch (val)
		{
			case ANumber(f): return f;
			case AInt(n): return n;
			case ABool(b): return b;
			case AString(s): return s;
			case ADate(d): return d;
			case AXml(xml): return xml;
			case AUndefined: return null;
			case ANull: return null;
			case AArray(vals): return vals.map(unwrapAMF3Value);
			case AVector(vals): return vals.map(unwrapAMF3Value);
			case ABytes(b): return ByteArray.fromBytes(b);

			case AObject(vmap):
				var obj = {};
				for (name in vmap.keys())
				{
					Reflect.setField(obj, name, unwrapAMF3Value(vmap[name]));
				}
				return obj;

			case AMap(vmap):
				var map:IMap<Dynamic, Dynamic> = null;
				for (key in vmap.keys())
				{
					// Get the map type from the type of the first key.
					if (map == null)
					{
						map = switch (key)
						{
							case AString(_): new Map<String, Dynamic>();
							case AInt(_): new Map<Int, Dynamic>();
							default: new ObjectMap<Dynamic, Dynamic>();
						}
					}
					map.set(unwrapAMF3Value(key), unwrapAMF3Value(vmap[key]));
				}

				// Default to StringMap if the map is empty.
				if (map == null)
				{
					map = new Map<String, Dynamic>();
				}
				return map;
		}
	}
	#end

	public function readShort():Int
	{
		var ch1 = readUnsignedByte();
		var ch2 = readUnsignedByte();

		var value;

		if (endian == LITTLE_ENDIAN)
		{
			value = ((ch2 << 8) | ch1);
		}
		else
		{
			value = ((ch1 << 8) | ch2);
		}

		if ((value & 0x8000) != 0)
		{
			return value - 0x10000;
		}
		else
		{
			return value;
		}
	}

	public function readUnsignedByte():Int
	{
		if (position < #if lime_bytes_length_getter l #else length #end)
		{
			return get(position++);
		}
		else
		{
			throw new EOFError();
			return 0;
		}
	}

	public function readUnsignedInt():Int
	{
		var ch1 = readUnsignedByte();
		var ch2 = readUnsignedByte();
		var ch3 = readUnsignedByte();
		var ch4 = readUnsignedByte();

		if (endian == LITTLE_ENDIAN)
		{
			return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
		}
		else
		{
			return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
		}
	}

	public function readUnsignedShort():Int
	{
		var ch1 = readUnsignedByte();
		var ch2 = readUnsignedByte();

		if (endian == LITTLE_ENDIAN)
		{
			return (ch2 << 8) + ch1;
		}
		else
		{
			return (ch1 << 8) | ch2;
		}
	}

	public function readUTF():String
	{
		var bytesCount = readUnsignedShort();
		return readUTFBytes(bytesCount);
	}

	public function readUTFBytes(length:Int):String
	{
		if (position + length > #if lime_bytes_length_getter l #else this.length #end)
		{
			throw new EOFError();
		}

		position += length;

		return getString(position - length, length);
	}

	public function uncompress(algorithm:CompressionAlgorithm = ZLIB):Void
	{
		#if lime
		#if js
		if (__length > #if lime_bytes_length_getter l #else length #end)
		{
			var cacheLength = #if lime_bytes_length_getter l #else length #end;
			#if lime_bytes_length_getter
			this.l = __length;
			#else
			this.length = __length;
			#end
			var data = Bytes.alloc(cacheLength);
			data.blit(0, this, 0, cacheLength);
			__setData(data);
			#if lime_bytes_length_getter
			this.l = cacheLength;
			#else
			this.length = cacheLength;
			#end
		}
		#end

		var limeBytes:LimeBytes = this;

		var bytes = switch (algorithm)
		{
			case CompressionAlgorithm.DEFLATE: limeBytes.decompress(DEFLATE);
			case CompressionAlgorithm.LZMA: limeBytes.decompress(LZMA);
			default: limeBytes.decompress(ZLIB);
		};

		if (bytes != null)
		{
			__setData(bytes);

			#if lime_bytes_length_getter
			l
			#else
			length
			#end
			= __length;
		}
		#end

		position = 0;
	}

	public function writeBoolean(value:Bool):Void
	{
		this.writeByte(value ? 1 : 0);
	}

	public function writeByte(value:Int):Void
	{
		__resize(position + 1);
		set(position++, value & 0xFF);
	}

	public function writeBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void
	{
		if (bytes.length == 0) return;
		if (length == 0) length = bytes.length - offset;

		__resize(position + length);
		blit(position, (bytes : ByteArrayData), offset, length);

		position += length;
	}

	public function writeDouble(value:Float):Void
	{
		var int64 = FPHelper.doubleToI64(value);

		if (endian == LITTLE_ENDIAN)
		{
			writeInt(int64.low);
			writeInt(int64.high);
		}
		else
		{
			writeInt(int64.high);
			writeInt(int64.low);
		}
	}

	public function writeFloat(value:Float):Void
	{
		if (endian == LITTLE_ENDIAN)
		{
			__resize(position + 4);
			setFloat(position, value);
			position += 4;
		}
		else
		{
			var int = FPHelper.floatToI32(value);
			writeInt(int);
		}
	}

	public function writeInt(value:Int):Void
	{
		__resize(position + 4);

		if (endian == LITTLE_ENDIAN)
		{
			set(position++, value & 0xFF);
			set(position++, (value >> 8) & 0xFF);
			set(position++, (value >> 16) & 0xFF);
			set(position++, (value >> 24) & 0xFF);
		}
		else
		{
			set(position++, (value >> 24) & 0xFF);
			set(position++, (value >> 16) & 0xFF);
			set(position++, (value >> 8) & 0xFF);
			set(position++, value & 0xFF);
		}
	}

	public function writeMultiByte(value:String, charSet:String):Void
	{
		writeUTFBytes(value);
	}

	public function writeObject(object:Dynamic):Void
	{
		switch (objectEncoding)
		{
			#if format
			case AMF0:
				var value = AMFTools.encode(object);
				var output = new BytesOutput();
				var writer = new AMFWriter(output);
				writer.write(value);
				writeBytes(output.getBytes());

			case AMF3:
				var value = AMF3Tools.encode(object);
				var output = new BytesOutput();
				var writer = new AMF3Writer(output);
				writer.write(value);
				writeBytes(output.getBytes());
			#end

			case HXSF:
				var value = Serializer.run(object);
				writeUTF(value);

			case JSON:
				var value = Json.stringify(object);
				writeUTF(value);

			default:
				return;
		}
	}

	public function writeShort(value:Int):Void
	{
		__resize(position + 2);

		if (endian == LITTLE_ENDIAN)
		{
			set(position++, value);
			set(position++, value >> 8);
		}
		else
		{
			set(position++, value >> 8);
			set(position++, value);
		}
	}

	public function writeUnsignedInt(value:Int):Void
	{
		writeInt(value);
	}

	public function writeUTF(value:String):Void
	{
		var bytes = Bytes.ofString(value);

		writeShort(#if lime_bytes_length_getter bytes.l #else bytes.length #end);
		writeBytes(bytes);
	}

	public function writeUTFBytes(value:String):Void
	{
		var bytes = Bytes.ofString(value);
		writeBytes(bytes);
	}

	@:noCompletion private function __fromBytes(bytes:Bytes):Void
	{
		__setData(bytes);
		#if lime_bytes_length_getter
		l = bytes.l;
		#else
		length = bytes.length;
		#end
	}

	@:noCompletion private function __resize(size:Int):Void
	{
		if (size > __length)
		{
			var bytes = Bytes.alloc(((size + 1) * 3) >> 1);
			#if sys
			bytes.fill(__length, size - __length, 0);
			#end

			if (__length > 0)
			{
				var cacheLength = #if lime_bytes_length_getter l #else length #end;
				#if lime_bytes_length_getter
				l
				#else
				length
				#end
				= __length;
				bytes.blit(0, this, 0, __length);
				#if lime_bytes_length_getter
				l
				#else
				length
				#end
				= cacheLength;
			}

			__setData(bytes);
		}

		if (#if lime_bytes_length_getter l #else length #end < size)
		{
			#if lime_bytes_length_getter l #else length #end = size;
		}
	}

	@:noCompletion private inline function __setData(bytes:Bytes):Void
	{
		#if eval
		// TODO: Not quite correct, but this will probably
		// not be called while in a macro
		var count = bytes.length < length ? bytes.length : length;
		for (i in 0...count)
			set(i, bytes.get(i));
		#else
		b = bytes.b;
		#end

		__length = #if lime_bytes_length_getter bytes.l #else bytes.length #end;

		#if js
		data = bytes.data;
		#end
	}

	// Get & Set Methods
	@:noCompletion private inline function get_bytesAvailable():Int
	{
		return #if lime_bytes_length_getter l #else length #end - position;
	}

	@:noCompletion private inline static function get_defaultEndian():Endian
	{
		if (__defaultEndian == null)
		{
			#if openfl_big_endian
			__defaultEndian = BIG_ENDIAN;
			#elseif lime
			if (System.endianness == LITTLE_ENDIAN)
			{
				__defaultEndian = LITTLE_ENDIAN;
			}
			else
			{
				__defaultEndian = BIG_ENDIAN;
			}
			#else
			__defaultEndian = LITTLE_ENDIAN;
			#end
		}

		return __defaultEndian;
	}

	@:noCompletion private inline static function set_defaultEndian(value:Endian):Endian
	{
		return __defaultEndian = value;
	}

	@:noCompletion private inline function get_endian():Endian
	{
		return __endian;
	}

	@:noCompletion private inline function set_endian(value:Endian):Endian
	{
		return __endian = value;
	}

	#if lime_bytes_length_getter
	@:noCompletion private override function set_length(value:Int):Int
	{
		#if display
		#else
		if (value > 0)
		{
			this.__resize(value);
			if (value < this.position) this.position = value;
		}

		this.l = value;
		#end

		return value;
	}
	#end
}
#else
#if flash
@:native("flash.utils.ByteArray")
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:noCompletion @:dox(hide) extern class ByteArrayData implements IDataOutput implements IDataInput implements ArrayAccess<Int>
{
	#if flash
	public static var defaultEndian(get, set):Endian;
	private static inline function get_defaultEndian():Endian
	{
		return BIG_ENDIAN;
	}
	private static inline function set_defaultEndian(value:Endian):Endian
	{
		return value;
	}
	#else
	public static var defaultEndian:Endian;
	#end
	public static var defaultObjectEncoding:ObjectEncoding;
	#if flash
	public var bytesAvailable(default, never):UInt;
	#else
	public var bytesAvailable(get, never):UInt;
	private inline function get_bytesAvailable():UInt
	{
		return 0;
	}
	#end
	#if flash
	public var endian:Endian;
	#else
	public var endian(get, set):Endian;
	@:noCompletion private function get_endian():Endian;
	@:noCompletion private function set_endian(value:Endian):Endian;
	#end
	public var length:UInt;
	public var objectEncoding:ObjectEncoding;
	public var position:UInt;
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public var shareable:Bool;
	#end
	public function new();
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public function atomicCompareAndSwapIntAt(byteIndex:Int, expectedValue:Int, newValue:Int):Int;
	#end
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public function atomicCompareAndSwapLength(expectedLength:Int, newLength:Int):Int;
	#end

	/**
		Clears the contents of the byte array and resets the `length`
		and `position` properties to 0. Calling this method explicitly
		frees up the memory used by the ByteArray instance.

	**/
	public function clear():Void;

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
	public function compress(?algorithm:CompressionAlgorithm):Void;

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
	public function deflate():Void;

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
	public function inflate():Void;

	/**
		Reads a Boolean value from the byte stream. A single byte is read, and
		`true` is returned if the byte is nonzero, `false`
		otherwise.

		@return Returns `true` if the byte is nonzero,
				`false` otherwise.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readBoolean():Bool;

	/**
		Reads a signed byte from the byte stream.

		The returned value is in the range -128 to 127.

		@return An integer between -128 and 127.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readByte():Int;

	/**
		Reads the number of data bytes, specified by the `length`
		parameter, from the byte stream. The bytes are read into the ByteArray
		object specified by the `bytes` parameter, and the bytes are
		written into the destination ByteArray starting at the position specified
		by `offset`.

		@param bytes  The ByteArray object to read data into.
		@param offset The offset(position) in `bytes` at which the
					  read data should be written.
		@param length The number of bytes to read. The default value of 0 causes
					  all available data to be read.
		@throws EOFError   There is not sufficient data available to read.
		@throws RangeError The value of the supplied offset and length, combined,
						   is greater than the maximum for a uint.
	**/
	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void;

	/**
		Reads an IEEE 754 double-precision(64-bit) floating-point number from the
		byte stream.

		@return A double-precision(64-bit) floating-point number.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readDouble():Float;

	/**
		Reads an IEEE 754 single-precision(32-bit) floating-point number from the
		byte stream.

		@return A single-precision(32-bit) floating-point number.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readFloat():Float;

	/**
		Reads a signed 32-bit integer from the byte stream.

		The returned value is in the range -2147483648 to 2147483647.

		@return A 32-bit signed integer between -2147483648 and 2147483647.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readInt():Int;

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
	public function readMultiByte(length:UInt, charSet:String):String;

	/**
		Reads an object from the byte array, encoded in AMF serialized format.

		@return The deserialized object.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readObject():Dynamic;

	/**
		Reads a signed 16-bit integer from the byte stream.

		The returned value is in the range -32768 to 32767.

		@return A 16-bit signed integer between -32768 and 32767.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readShort():Int;

	/**
		Reads a UTF-8 string from the byte stream. The string is assumed to be
		prefixed with an unsigned short indicating the length in bytes.

		@return UTF-8 encoded string.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readUTF():String;

	/**
		Reads a sequence of UTF-8 bytes specified by the `length`
		parameter from the byte stream and returns a string.

		@param length An unsigned short indicating the length of the UTF-8 bytes.
		@return A string composed of the UTF-8 bytes of the specified length.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readUTFBytes(length:UInt):String;

	/**
		Reads an unsigned byte from the byte stream.

		The returned value is in the range 0 to 255.

		@return A 32-bit unsigned integer between 0 and 255.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readUnsignedByte():UInt;

	/**
		Reads an unsigned 32-bit integer from the byte stream.

		The returned value is in the range 0 to 4294967295.

		@return A 32-bit unsigned integer between 0 and 4294967295.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readUnsignedInt():UInt;

	/**
		Reads an unsigned 16-bit integer from the byte stream.

		The returned value is in the range 0 to 65535.

		@return A 16-bit unsigned integer between 0 and 65535.
		@throws EOFError There is not sufficient data available to read.
	**/
	public function readUnsignedShort():UInt;

	/**
		Converts the byte array to a string. If the data in the array begins with
		a Unicode byte order mark, the application will honor that mark when
		converting to a string. If `System.useCodePage` is set to
		`true`, the application will treat the data in the array as
		being in the current system code page when converting.

		@return The string representation of the byte array.
	**/
	public function toString():String;

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
	public function uncompress(?algorithm:CompressionAlgorithm):Void;

	/**
		Writes a Boolean value. A single byte is written according to the
		`value` parameter, either 1 if `true` or 0 if
		`false`.

		@param value A Boolean value determining which byte is written. If the
					 parameter is `true`, the method writes a 1; if
					 `false`, the method writes a 0.
	**/
	public function writeBoolean(value:Bool):Void;

	/**
		Writes a byte to the byte stream.

		The low 8 bits of the parameter are used. The high 24 bits are ignored.


		@param value A 32-bit integer. The low 8 bits are written to the byte
					 stream.
	**/
	public function writeByte(value:Int):Void;

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
	public function writeBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void;

	/**
		Writes an IEEE 754 double-precision(64-bit) floating-point number to the
		byte stream.

		@param value A double-precision(64-bit) floating-point number.
	**/
	public function writeDouble(value:Float):Void;

	/**
		Writes an IEEE 754 single-precision(32-bit) floating-point number to the
		byte stream.

		@param value A single-precision(32-bit) floating-point number.
	**/
	public function writeFloat(value:Float):Void;

	/**
		Writes a 32-bit signed integer to the byte stream.

		@param value An integer to write to the byte stream.
	**/
	public function writeInt(value:Int):Void;

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
	public function writeMultiByte(value:String, charSet:String):Void;

	/**
		Writes an object into the byte array in AMF serialized format.

		@param object The object to serialize.
	**/
	public function writeObject(object:Dynamic):Void;

	/**
		Writes a 16-bit integer to the byte stream. The low 16 bits of the
		parameter are used. The high 16 bits are ignored.

		@param value 32-bit integer, whose low 16 bits are written to the byte
					 stream.
	**/
	public function writeShort(value:Int):Void;

	/**
		Writes a UTF-8 string to the byte stream. The length of the UTF-8 string
		in bytes is written first, as a 16-bit integer, followed by the bytes
		representing the characters of the string.

		@param value The string value to be written.
		@throws RangeError If the length is larger than 65535.
	**/
	public function writeUTF(value:String):Void;

	/**
		Writes a UTF-8 string to the byte stream. Similar to the
		`writeUTF()` method, but `writeUTFBytes()` does not
		prefix the string with a 16-bit length word.

		@param value The string value to be written.
	**/
	public function writeUTFBytes(value:String):Void;

	/**
		Writes a 32-bit unsigned integer to the byte stream.

		@param value An unsigned integer to write to the byte stream.
	**/
	public function writeUnsignedInt(value:UInt):Void;
}
#end
