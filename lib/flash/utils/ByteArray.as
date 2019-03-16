package flash.utils {
	
	
	// import flash.net.ObjectEncoding;
	
	
	/**
	 * @externs
	 */
	public class ByteArray implements IDataOutput, IDataInput /*implements ArrayAccess<Int>*/ {
		
		
		public function get (position:int):int { return 0; }
		public function set (position:int, value:int):int { return 0; }
		
		
		/**
		 * Denotes the default object encoding for the ByteArray class to use for a
		 * new ByteArray instance. When you create a new ByteArray instance, the
		 * encoding on that instance starts with the value of
		 * `defaultObjectEncoding`. The `defaultObjectEncoding`
		 * property is initialized to `ObjectEncoding.AMF3`.
		 *
		 * When an object is written to or read from binary data, the
		 * `objectEncoding` value is used to determine whether the
		 * ActionScript 3.0, ActionScript2.0, or ActionScript 1.0 format should be
		 * used. The value is a constant from the ObjectEncoding class.
		 */
		public static var defaultObjectEncoding:uint;
		
		/**
		 * The number of bytes of data available for reading from the current
		 * position in the byte array to the end of the array.
		 *
		 * Use the `bytesAvailable` property in conjunction with the
		 * read methods each time you access a ByteArray object to ensure that you
		 * are reading valid data.
		 */
		public function get bytesAvailable ():uint { return 0; }
		protected function get_bytesAvailable ():uint { return 0; }
		
		/**
		 * Changes or reads the byte order for the data; either
		 * `Endian.BIG_ENDIAN` or `Endian.LITTLE_ENDIAN`.
		 */
		public function get endian ():String { return null; }
		public function set endian (value:String):void {}
		// public var endian:String;
		protected function get_endian ():String { return null; }
		protected function set_endian (value:String):String { return null; }
		
		/**
		 * The length of the ByteArray object, in bytes.
		 *
		 * If the length is set to a value that is larger than the current length,
		 * the right side of the byte array is filled with zeros.
		 *
		 * If the length is set to a value that is smaller than the current
		 * length, the byte array is truncated.
		 */
		public var length:uint;
		
		/**
		 * Used to determine whether the ActionScript 3.0, ActionScript 2.0, or
		 * ActionScript 1.0 format should be used when writing to, or reading from, a
		 * ByteArray instance. The value is a constant from the ObjectEncoding class.
		 */
		public function get objectEncoding ():uint { return null; }
		public function set objectEncoding (value:uint):void {}
		// public var objectEncoding:uint;
		
		/**
		 * Moves, or returns the current position, in bytes, of the file pointer into
		 * the ByteArray object. This is the point at which the next call to a read
		 * method starts reading or a write method starts writing.
		 */
		public var position:uint;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_4) public var shareable:Bool;
		// #end
		
		
		/**
		 * Creates a ByteArray instance representing a packed array of bytes, so that
		 * you can use the methods and properties in this class to optimize your data
		 * storage and stream.
		 */
		public function ByteArray (length:int = 0) {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_4) public function atomicCompareAndSwapIntAt (byteIndex:int, expectedValue:int, newValue:int):int;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_4) public function atomicCompareAndSwapLength (expectedLength:int, newLength:int):int;
		// #end
		
		
		/**
		 * Clears the contents of the byte array and resets the `length`
		 * and `position` properties to 0. Calling this method explicitly
		 * frees up the memory used by the ByteArray instance.
		 * 
		 */
		public function clear ():void {}
		
		
		/**
		 * Compresses the byte array. The entire byte array is compressed. For
		 * content running in Adobe AIR, you can specify a compression algorithm by
		 * passing a value(defined in the CompressionAlgorithm class) as the
		 * `algorithm` parameter. Flash Player supports only the default
		 * algorithm, zlib.
		 *
		 * After the call, the `length` property of the ByteArray is
		 * set to the new length. The `position` property is set to the
		 * end of the byte array.
		 *
		 * The zlib compressed data format is described at 
		 * [http://www.ietf.org/rfc/rfc1950.txt](http://www.ietf.org/rfc/rfc1950.txt).
		 *
		 * The deflate compression algorithm is described at 
		 * [http://www.ietf.org/rfc/rfc1951.txt](http://www.ietf.org/rfc/rfc1951.txt).
		 *
		 * The deflate compression algorithm is used in several compression
		 * formats, such as zlib, gzip, some zip implementations, and others. When
		 * data is compressed using one of those compression formats, in addition to
		 * storing the compressed version of the original data, the compression
		 * format data(for example, the .zip file) includes metadata information.
		 * Some examples of the types of metadata included in various file formats
		 * are file name, file modification date/time, original file size, optional
		 * comments, checksum data, and more.
		 *
		 * For example, when a ByteArray is compressed using the zlib algorithm,
		 * the resulting ByteArray is structured in a specific format. Certain bytes
		 * contain metadata about the compressed data, while other bytes contain the
		 * actual compressed version of the original ByteArray data. As defined by
		 * the zlib compressed data format specification, those bytes(that is, the
		 * portion containing the compressed version of the original data) are
		 * compressed using the deflate algorithm. Consequently those bytes are
		 * identical to the result of calling `compress(<ph
		 * outputclass="javascript">air.CompressionAlgorithm.DEFLATE)` on the
		 * original ByteArray. However, the result from `compress(<ph
		 * outputclass="javascript">air.CompressionAlgorithm.ZLIB)` includes
		 * the extra metadata, while the
		 * `compress(CompressionAlgorithm.DEFLATE)` result includes only
		 * the compressed version of the original ByteArray data and nothing
		 * else.
		 *
		 * In order to use the deflate format to compress a ByteArray instance's
		 * data in a specific format such as gzip or zip, you cannot simply call
		 * `compress(CompressionAlgorithm.DEFLATE)`. You must create a
		 * ByteArray structured according to the compression format's specification,
		 * including the appropriate metadata as well as the compressed data obtained
		 * using the deflate format. Likewise, in order to decode data compressed in
		 * a format such as gzip or zip, you can't simply call
		 * `uncompress(CompressionAlgorithm.DEFLATE)` on that data. First,
		 * you must separate the metadata from the compressed data, and you can then
		 * use the deflate format to decompress the compressed data.
		 * 
		 */
		public function compress (algorithm:String = null):void {}
		
		
		/**
		 * Compresses the byte array using the deflate compression algorithm. The
		 * entire byte array is compressed.
		 *
		 * After the call, the `length` property of the ByteArray is
		 * set to the new length. The `position` property is set to the
		 * end of the byte array.
		 *
		 * The deflate compression algorithm is described at 
		 * [http://www.ietf.org/rfc/rfc1951.txt](http://www.ietf.org/rfc/rfc1951.txt).
		 *
		 * In order to use the deflate format to compress a ByteArray instance's
		 * data in a specific format such as gzip or zip, you cannot simply call
		 * `deflate()`. You must create a ByteArray structured according
		 * to the compression format's specification, including the appropriate
		 * metadata as well as the compressed data obtained using the deflate format.
		 * Likewise, in order to decode data compressed in a format such as gzip or
		 * zip, you can't simply call `inflate()` on that data. First, you
		 * must separate the metadata from the compressed data, and you can then use
		 * the deflate format to decompress the compressed data.
		 * 
		 */
		public function deflate ():void {}
		
		
		/**
		 * Decompresses the byte array using the deflate compression algorithm. The
		 * byte array must have been compressed using the same algorithm.
		 *
		 * After the call, the `length` property of the ByteArray is
		 * set to the new length. The `position` property is set to 0.
		 *
		 * The deflate compression algorithm is described at 
		 * [http://www.ietf.org/rfc/rfc1951.txt](http://www.ietf.org/rfc/rfc1951.txt).
		 *
		 * In order to decode data compressed in a format that uses the deflate
		 * compression algorithm, such as data in gzip or zip format, it will not
		 * work to simply call `inflate()` on a ByteArray containing the
		 * compression formation data. First, you must separate the metadata that is
		 * included as part of the compressed data format from the actual compressed
		 * data. For more information, see the `compress()` method
		 * description.
		 * 
		 * @throws IOError The data is not valid compressed data; it was not
		 *                 compressed with the same compression algorithm used to
		 *                 compress.
		 */
		public function inflate ():void {}
		
		
		/**
		 * Reads a Boolean value from the byte stream. A single byte is read, and
		 * `true` is returned if the byte is nonzero, `false`
		 * otherwise.
		 * 
		 * @return Returns `true` if the byte is nonzero,
		 *         `false` otherwise.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readBoolean ():Boolean { return false; }
		
		
		/**
		 * Reads a signed byte from the byte stream.
		 *
		 * The returned value is in the range -128 to 127.
		 * 
		 * @return An integer between -128 and 127.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readByte ():int { return 0; }
		
		
		/**
		 * Reads the number of data bytes, specified by the `length`
		 * parameter, from the byte stream. The bytes are read into the ByteArray
		 * object specified by the `bytes` parameter, and the bytes are
		 * written into the destination ByteArray starting at the position specified
		 * by `offset`.
		 * 
		 * @param bytes  The ByteArray object to read data into.
		 * @param offset The offset(position) in `bytes` at which the
		 *               read data should be written.
		 * @param length The number of bytes to read. The default value of 0 causes
		 *               all available data to be read.
		 * @throws EOFError   There is not sufficient data available to read.
		 * @throws RangeError The value of the supplied offset and length, combined,
		 *                    is greater than the maximum for a uint.
		 */
		public function readBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void {}
		
		
		/**
		 * Reads an IEEE 754 double-precision(64-bit) floating-point number from the
		 * byte stream.
		 * 
		 * @return A double-precision(64-bit) floating-point number.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readDouble ():Number { return 0; }
		
		
		/**
		 * Reads an IEEE 754 single-precision(32-bit) floating-point number from the
		 * byte stream.
		 * 
		 * @return A single-precision(32-bit) floating-point number.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readFloat ():Number { return 0; }
		
		
		/**
		 * Reads a signed 32-bit integer from the byte stream.
		 *
		 * The returned value is in the range -2147483648 to 2147483647.
		 * 
		 * @return A 32-bit signed integer between -2147483648 and 2147483647.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readInt ():int { return 0; }
		
		
		/**
		 * Reads a multibyte string of specified length from the byte stream using
		 * the specified character set.
		 * 
		 * @param length  The number of bytes from the byte stream to read.
		 * @param charSet The string denoting the character set to use to interpret
		 *                the bytes. Possible character set strings include
		 *                `"shift-jis"`, `"cn-gb"`,
		 *                `"iso-8859-1"`, and others. For a complete list,
		 *                see <a href="../../charset-codes.html">Supported Character
		 *                Sets</a>.
		 *
		 *                **Note:** If the value for the `charSet`
		 *                parameter is not recognized by the current system, the
		 *                application uses the system's default code page as the
		 *                character set. For example, a value for the
		 *                `charSet` parameter, as in
		 *                `myTest.readMultiByte(22, "iso-8859-01")` that
		 *                uses `01` instead of `1` might work
		 *                on your development system, but not on another system. On
		 *                the other system, the application will use the system's
		 *                default code page.
		 * @return UTF-8 encoded string.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readMultiByte (length:uint, charSet:String):String { return null; }
		
		
		/**
		 * Reads an object from the byte array, encoded in AMF serialized format.
		 * 
		 * @return The deserialized object.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readObject ():Object { return null; }
		
		
		/**
		 * Reads a signed 16-bit integer from the byte stream.
		 *
		 * The returned value is in the range -32768 to 32767.
		 * 
		 * @return A 16-bit signed integer between -32768 and 32767.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readShort ():int { return 0; }
		
		
		/**
		 * Reads a UTF-8 string from the byte stream. The string is assumed to be
		 * prefixed with an unsigned short indicating the length in bytes.
		 * 
		 * @return UTF-8 encoded string.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readUTF ():String { return null; }
		
		
		/**
		 * Reads a sequence of UTF-8 bytes specified by the `length`
		 * parameter from the byte stream and returns a string.
		 * 
		 * @param length An unsigned short indicating the length of the UTF-8 bytes.
		 * @return A string composed of the UTF-8 bytes of the specified length.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readUTFBytes (length:uint):String { return null; }
		
		
		/**
		 * Reads an unsigned byte from the byte stream.
		 *
		 * The returned value is in the range 0 to 255. 
		 * 
		 * @return A 32-bit unsigned integer between 0 and 255.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readUnsignedByte ():uint { return 0; }
		
		
		/**
		 * Reads an unsigned 32-bit integer from the byte stream.
		 *
		 * The returned value is in the range 0 to 4294967295. 
		 * 
		 * @return A 32-bit unsigned integer between 0 and 4294967295.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readUnsignedInt ():uint { return 0; }
		
		
		/**
		 * Reads an unsigned 16-bit integer from the byte stream.
		 *
		 * The returned value is in the range 0 to 65535. 
		 * 
		 * @return A 16-bit unsigned integer between 0 and 65535.
		 * @throws EOFError There is not sufficient data available to read.
		 */
		public function readUnsignedShort ():uint { return 0; }
		
		
		/**
		 * Converts the byte array to a string. If the data in the array begins with
		 * a Unicode byte order mark, the application will honor that mark when
		 * converting to a string. If `System.useCodePage` is set to
		 * `true`, the application will treat the data in the array as
		 * being in the current system code page when converting.
		 * 
		 * @return The string representation of the byte array.
		 */
		public function toString ():String { return null; }
		
		
		/**
		 * Decompresses the byte array. For content running in Adobe AIR, you can
		 * specify a compression algorithm by passing a value(defined in the
		 * CompressionAlgorithm class) as the `algorithm` parameter. The
		 * byte array must have been compressed using the same algorithm. Flash
		 * Player supports only the default algorithm, zlib.
		 *
		 * After the call, the `length` property of the ByteArray is
		 * set to the new length. The `position` property is set to 0.
		 *
		 * The zlib compressed data format is described at 
		 * [http://www.ietf.org/rfc/rfc1950.txt](http://www.ietf.org/rfc/rfc1950.txt).
		 *
		 * The deflate compression algorithm is described at 
		 * [http://www.ietf.org/rfc/rfc1951.txt](http://www.ietf.org/rfc/rfc1951.txt).
		 *
		 * In order to decode data compressed in a format that uses the deflate
		 * compression algorithm, such as data in gzip or zip format, it will not
		 * work to call `uncompress(CompressionAlgorithm.DEFLATE)` on a
		 * ByteArray containing the compression formation data. First, you must
		 * separate the metadata that is included as part of the compressed data
		 * format from the actual compressed data. For more information, see the
		 * `compress()` method description.
		 * 
		 * @throws IOError The data is not valid compressed data; it was not
		 *                 compressed with the same compression algorithm used to
		 *                 compress.
		 */
		public function uncompress (algorithm:String = null):void {}
		
		
		/**
		 * Writes a Boolean value. A single byte is written according to the
		 * `value` parameter, either 1 if `true` or 0 if
		 * `false`.
		 * 
		 * @param value A Boolean value determining which byte is written. If the
		 *              parameter is `true`, the method writes a 1; if
		 *              `false`, the method writes a 0.
		 */
		public function writeBoolean (value:Boolean):void {}
		
		
		/**
		 * Writes a byte to the byte stream.
		 *
		 * The low 8 bits of the parameter are used. The high 24 bits are ignored.
		 * 
		 * 
		 * @param value A 32-bit integer. The low 8 bits are written to the byte
		 *              stream.
		 */
		public function writeByte (value:int):void {}
		
		
		/**
		 * Writes a sequence of `length` bytes from the specified byte
		 * array, `bytes`, starting `offset`(zero-based index)
		 * bytes into the byte stream.
		 *
		 * If the `length` parameter is omitted, the default length of
		 * 0 is used; the method writes the entire buffer starting at
		 * `offset`. If the `offset` parameter is also omitted,
		 * the entire buffer is written. 
		 *
		 * If `offset` or `length` is out of range, they are
		 * clamped to the beginning and end of the `bytes` array.
		 * 
		 * @param bytes  The ByteArray object.
		 * @param offset A zero-based index indicating the position into the array to
		 *               begin writing.
		 * @param length An unsigned integer indicating how far into the buffer to
		 *               write.
		 */
		public function writeBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void {}
		
		
		/**
		 * Writes an IEEE 754 double-precision(64-bit) floating-point number to the
		 * byte stream.
		 * 
		 * @param value A double-precision(64-bit) floating-point number.
		 */
		public function writeDouble (value:Number):void {}
		
		
		/**
		 * Writes an IEEE 754 single-precision(32-bit) floating-point number to the
		 * byte stream.
		 * 
		 * @param value A single-precision(32-bit) floating-point number.
		 */
		public function writeFloat (value:Number):void {}
		
		
		/**
		 * Writes a 32-bit signed integer to the byte stream.
		 * 
		 * @param value An integer to write to the byte stream.
		 */
		public function writeInt (value:int):void {}
		
		
		/**
		 * Writes a multibyte string to the byte stream using the specified character
		 * set.
		 * 
		 * @param value   The string value to be written.
		 * @param charSet The string denoting the character set to use. Possible
		 *                character set strings include `"shift-jis"`,
		 *                `"cn-gb"`, `"iso-8859-1"`, and
		 *                others. For a complete list, see <a
		 *                href="../../charset-codes.html">Supported Character
		 *                Sets</a>.
		 */
		public function writeMultiByte (value:String, charSet:String):void {}
		
		
		/**
		 * Writes an object into the byte array in AMF serialized format.
		 * 
		 * @param object The object to serialize.
		 */
		public function writeObject (object:Object):void {}
		
		
		/**
		 * Writes a 16-bit integer to the byte stream. The low 16 bits of the
		 * parameter are used. The high 16 bits are ignored.
		 * 
		 * @param value 32-bit integer, whose low 16 bits are written to the byte
		 *              stream.
		 */
		public function writeShort (value:int):void {}
		
		
		/**
		 * Writes a UTF-8 string to the byte stream. The length of the UTF-8 string
		 * in bytes is written first, as a 16-bit integer, followed by the bytes
		 * representing the characters of the string.
		 * 
		 * @param value The string value to be written.
		 * @throws RangeError If the length is larger than 65535.
		 */
		public function writeUTF (value:String):void {}
		
		
		/**
		 * Writes a UTF-8 string to the byte stream. Similar to the
		 * `writeUTF()` method, but `writeUTFBytes()` does not
		 * prefix the string with a 16-bit length word.
		 * 
		 * @param value The string value to be written.
		 */
		public function writeUTFBytes (value:String):void {}
		
		
		/**
		 * Writes a 32-bit unsigned integer to the byte stream.
		 * 
		 * @param value An unsigned integer to write to the byte stream.
		 */
		public function writeUnsignedInt (value:uint):void {}
		
		
	}
	
	
}