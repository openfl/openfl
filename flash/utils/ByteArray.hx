package flash.utils;
#if (flash || display)


/**
 * The ByteArray class provides methods and properties to optimize reading,
 * writing, and working with binary data.
 *
 * <p><i>Note:</i> The ByteArray class is for advanced developers who need to
 * access data on the byte level.</p>
 *
 * <p>In-memory data is a packed array(the most compact representation for
 * the data type) of bytes, but an instance of the ByteArray class can be
 * manipulated with the standard <code>[]</code>(array access) operators. It
 * also can be read and written to as an in-memory file, using methods similar
 * to those in the URLStream and Socket classes.</p>
 *
 * <p>In addition, zlib compression and decompression are supported, as well
 * as Action Message Format(AMF) object serialization.</p>
 *
 * <p>Possible uses of the ByteArray class include the following:
 * <ul>
 *   <li>Creating a custom protocol to connect to a server.</li>
 *   <li>Writing your own URLEncoder/URLDecoder.</li>
 *   <li>Writing your own AMF/Remoting packet.</li>
 *   <li>Optimizing the size of your data by using data types.</li>
 *   <li>Working with binary data loaded from a file in Adobe<sup>®</sup>
 * AIR<sup>®</sup>.</li>
 * </ul>
 * </p>
 */
extern class ByteArray /*implements IDataOutput,*/ implements IDataInput  implements ArrayAccess<Int> {

	/**
	 * The number of bytes of data available for reading from the current
	 * position in the byte array to the end of the array.
	 *
	 * <p>Use the <code>bytesAvailable</code> property in conjunction with the
	 * read methods each time you access a ByteArray object to ensure that you
	 * are reading valid data.</p>
	 */
	var bytesAvailable(default,null) : Int;

	/**
	 * Changes or reads the byte order for the data; either
	 * <code>Endian.BIG_ENDIAN</code> or <code>Endian.LITTLE_ENDIAN</code>.
	 */
	var endian : Endian;

	/**
	 * The length of the ByteArray object, in bytes.
	 *
	 * <p>If the length is set to a value that is larger than the current length,
	 * the right side of the byte array is filled with zeros.</p>
	 *
	 * <p>If the length is set to a value that is smaller than the current
	 * length, the byte array is truncated.</p>
	 */
	var length : Int;

	/**
	 * Used to determine whether the ActionScript 3.0, ActionScript 2.0, or
	 * ActionScript 1.0 format should be used when writing to, or reading from, a
	 * ByteArray instance. The value is a constant from the ObjectEncoding class.
	 */
	var objectEncoding : Int;

	/**
	 * Moves, or returns the current position, in bytes, of the file pointer into
	 * the ByteArray object. This is the point at which the next call to a read
	 * method starts reading or a write method starts writing.
	 */
	var position : Int;
	
	@:require(flash11_4) var shareable : Bool;

	/**
	 * Creates a ByteArray instance representing a packed array of bytes, so that
	 * you can use the methods and properties in this class to optimize your data
	 * storage and stream.
	 */
	function new() : Void;
	
	@:require(flash11_4) function atomicCompareAndSwapIntAt(byteIndex : Int, expectedValue : Int, newValue : Int) : Int;
	@:require(flash11_4) function atomicCompareAndSwapLength(expectedLength : Int, newLength : Int) : Int;

	/**
	 * Clears the contents of the byte array and resets the <code>length</code>
	 * and <code>position</code> properties to 0. Calling this method explicitly
	 * frees up the memory used by the ByteArray instance.
	 * 
	 */
	@:require(flash10) function clear() : Void;

	/**
	 * Compresses the byte array. The entire byte array is compressed. For
	 * content running in Adobe AIR, you can specify a compression algorithm by
	 * passing a value(defined in the CompressionAlgorithm class) as the
	 * <code>algorithm</code> parameter. Flash Player supports only the default
	 * algorithm, zlib.
	 *
	 * <p>After the call, the <code>length</code> property of the ByteArray is
	 * set to the new length. The <code>position</code> property is set to the
	 * end of the byte array.</p>
	 *
	 * <p>The zlib compressed data format is described at <a
	 * href="http://www.ietf.org/rfc/rfc1950.txt"
	 * scope="external">http://www.ietf.org/rfc/rfc1950.txt</a>.</p>
	 *
	 * <p>The deflate compression algorithm is described at <a
	 * href="http://www.ietf.org/rfc/rfc1951.txt"
	 * scope="external">http://www.ietf.org/rfc/rfc1951.txt</a>.</p>
	 *
	 * <p>The deflate compression algorithm is used in several compression
	 * formats, such as zlib, gzip, some zip implementations, and others. When
	 * data is compressed using one of those compression formats, in addition to
	 * storing the compressed version of the original data, the compression
	 * format data(for example, the .zip file) includes metadata information.
	 * Some examples of the types of metadata included in various file formats
	 * are file name, file modification date/time, original file size, optional
	 * comments, checksum data, and more.</p>
	 *
	 * <p>For example, when a ByteArray is compressed using the zlib algorithm,
	 * the resulting ByteArray is structured in a specific format. Certain bytes
	 * contain metadata about the compressed data, while other bytes contain the
	 * actual compressed version of the original ByteArray data. As defined by
	 * the zlib compressed data format specification, those bytes(that is, the
	 * portion containing the compressed version of the original data) are
	 * compressed using the deflate algorithm. Consequently those bytes are
	 * identical to the result of calling <code>compress(<ph
	 * outputclass="javascript">air.CompressionAlgorithm.DEFLATE)</code> on the
	 * original ByteArray. However, the result from <code>compress(<ph
	 * outputclass="javascript">air.CompressionAlgorithm.ZLIB)</code> includes
	 * the extra metadata, while the
	 * <code>compress(CompressionAlgorithm.DEFLATE)</code> result includes only
	 * the compressed version of the original ByteArray data and nothing
	 * else.</p>
	 *
	 * <p>In order to use the deflate format to compress a ByteArray instance's
	 * data in a specific format such as gzip or zip, you cannot simply call
	 * <code>compress(CompressionAlgorithm.DEFLATE)</code>. You must create a
	 * ByteArray structured according to the compression format's specification,
	 * including the appropriate metadata as well as the compressed data obtained
	 * using the deflate format. Likewise, in order to decode data compressed in
	 * a format such as gzip or zip, you can't simply call
	 * <code>uncompress(CompressionAlgorithm.DEFLATE)</code> on that data. First,
	 * you must separate the metadata from the compressed data, and you can then
	 * use the deflate format to decompress the compressed data.</p>
	 * 
	 */
	function compress(#if flash11 ?algorithm : CompressionAlgorithm #end) : Void;

	/**
	 * Compresses the byte array using the deflate compression algorithm. The
	 * entire byte array is compressed.
	 *
	 * <p>After the call, the <code>length</code> property of the ByteArray is
	 * set to the new length. The <code>position</code> property is set to the
	 * end of the byte array.</p>
	 *
	 * <p>The deflate compression algorithm is described at <a
	 * href="http://www.ietf.org/rfc/rfc1951.txt"
	 * scope="external">http://www.ietf.org/rfc/rfc1951.txt</a>.</p>
	 *
	 * <p>In order to use the deflate format to compress a ByteArray instance's
	 * data in a specific format such as gzip or zip, you cannot simply call
	 * <code>deflate()</code>. You must create a ByteArray structured according
	 * to the compression format's specification, including the appropriate
	 * metadata as well as the compressed data obtained using the deflate format.
	 * Likewise, in order to decode data compressed in a format such as gzip or
	 * zip, you can't simply call <code>inflate()</code> on that data. First, you
	 * must separate the metadata from the compressed data, and you can then use
	 * the deflate format to decompress the compressed data.</p>
	 * 
	 */
	@:require(flash10) function deflate() : Void;

	/**
	 * Decompresses the byte array using the deflate compression algorithm. The
	 * byte array must have been compressed using the same algorithm.
	 *
	 * <p>After the call, the <code>length</code> property of the ByteArray is
	 * set to the new length. The <code>position</code> property is set to 0.</p>
	 *
	 * <p>The deflate compression algorithm is described at <a
	 * href="http://www.ietf.org/rfc/rfc1951.txt"
	 * scope="external">http://www.ietf.org/rfc/rfc1951.txt</a>.</p>
	 *
	 * <p>In order to decode data compressed in a format that uses the deflate
	 * compression algorithm, such as data in gzip or zip format, it will not
	 * work to simply call <code>inflate()</code> on a ByteArray containing the
	 * compression formation data. First, you must separate the metadata that is
	 * included as part of the compressed data format from the actual compressed
	 * data. For more information, see the <code>compress()</code> method
	 * description.</p>
	 * 
	 * @throws IOError The data is not valid compressed data; it was not
	 *                 compressed with the same compression algorithm used to
	 *                 compress.
	 */
	@:require(flash10) function inflate() : Void;

	/**
	 * Reads a Boolean value from the byte stream. A single byte is read, and
	 * <code>true</code> is returned if the byte is nonzero, <code>false</code>
	 * otherwise.
	 * 
	 * @return Returns <code>true</code> if the byte is nonzero,
	 *         <code>false</code> otherwise.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readBoolean() : Bool;

	/**
	 * Reads a signed byte from the byte stream.
	 *
	 * <p>The returned value is in the range -128 to 127.</p>
	 * 
	 * @return An integer between -128 and 127.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readByte() : Int;

	/**
	 * Reads the number of data bytes, specified by the <code>length</code>
	 * parameter, from the byte stream. The bytes are read into the ByteArray
	 * object specified by the <code>bytes</code> parameter, and the bytes are
	 * written into the destination ByteArray starting at the position specified
	 * by <code>offset</code>.
	 * 
	 * @param bytes  The ByteArray object to read data into.
	 * @param offset The offset(position) in <code>bytes</code> at which the
	 *               read data should be written.
	 * @param length The number of bytes to read. The default value of 0 causes
	 *               all available data to be read.
	 * @throws EOFError   There is not sufficient data available to read.
	 * @throws RangeError The value of the supplied offset and length, combined,
	 *                    is greater than the maximum for a uint.
	 */
	function readBytes(bytes : ByteArray, offset : Int = 0, length : Int = 0) : Void;

	/**
	 * Reads an IEEE 754 double-precision(64-bit) floating-point number from the
	 * byte stream.
	 * 
	 * @return A double-precision(64-bit) floating-point number.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readDouble() : Float;

	/**
	 * Reads an IEEE 754 single-precision(32-bit) floating-point number from the
	 * byte stream.
	 * 
	 * @return A single-precision(32-bit) floating-point number.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readFloat() : Float;

	/**
	 * Reads a signed 32-bit integer from the byte stream.
	 *
	 * <p>The returned value is in the range -2147483648 to 2147483647.</p>
	 * 
	 * @return A 32-bit signed integer between -2147483648 and 2147483647.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readInt() : Int;

	/**
	 * Reads a multibyte string of specified length from the byte stream using
	 * the specified character set.
	 * 
	 * @param length  The number of bytes from the byte stream to read.
	 * @param charSet The string denoting the character set to use to interpret
	 *                the bytes. Possible character set strings include
	 *                <code>"shift-jis"</code>, <code>"cn-gb"</code>,
	 *                <code>"iso-8859-1"</code>, and others. For a complete list,
	 *                see <a href="../../charset-codes.html">Supported Character
	 *                Sets</a>.
	 *
	 *                <p><b>Note:</b> If the value for the <code>charSet</code>
	 *                parameter is not recognized by the current system, the
	 *                application uses the system's default code page as the
	 *                character set. For example, a value for the
	 *                <code>charSet</code> parameter, as in
	 *                <code>myTest.readMultiByte(22, "iso-8859-01")</code> that
	 *                uses <code>01</code> instead of <code>1</code> might work
	 *                on your development system, but not on another system. On
	 *                the other system, the application will use the system's
	 *                default code page.</p>
	 * @return UTF-8 encoded string.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readMultiByte(length : Int, charSet : String) : String;

	/**
	 * Reads an object from the byte array, encoded in AMF serialized format.
	 * 
	 * @return The deserialized object.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readObject() : Dynamic;

	/**
	 * Reads a signed 16-bit integer from the byte stream.
	 *
	 * <p>The returned value is in the range -32768 to 32767.</p>
	 * 
	 * @return A 16-bit signed integer between -32768 and 32767.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readShort() : Int;

	/**
	 * Reads a UTF-8 string from the byte stream. The string is assumed to be
	 * prefixed with an unsigned short indicating the length in bytes.
	 * 
	 * @return UTF-8 encoded string.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readUTF() : String;

	/**
	 * Reads a sequence of UTF-8 bytes specified by the <code>length</code>
	 * parameter from the byte stream and returns a string.
	 * 
	 * @param length An unsigned short indicating the length of the UTF-8 bytes.
	 * @return A string composed of the UTF-8 bytes of the specified length.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readUTFBytes(length : Int) : String;

	/**
	 * Reads an unsigned byte from the byte stream.
	 *
	 * <p>The returned value is in the range 0 to 255. </p>
	 * 
	 * @return A 32-bit unsigned integer between 0 and 255.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readUnsignedByte() : Int;

	/**
	 * Reads an unsigned 32-bit integer from the byte stream.
	 *
	 * <p>The returned value is in the range 0 to 4294967295. </p>
	 * 
	 * @return A 32-bit unsigned integer between 0 and 4294967295.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readUnsignedInt() : Int;

	/**
	 * Reads an unsigned 16-bit integer from the byte stream.
	 *
	 * <p>The returned value is in the range 0 to 65535. </p>
	 * 
	 * @return A 16-bit unsigned integer between 0 and 65535.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	function readUnsignedShort() : Int;

	/**
	 * Converts the byte array to a string. If the data in the array begins with
	 * a Unicode byte order mark, the application will honor that mark when
	 * converting to a string. If <code>System.useCodePage</code> is set to
	 * <code>true</code>, the application will treat the data in the array as
	 * being in the current system code page when converting.
	 * 
	 * @return The string representation of the byte array.
	 */
	function toString() : String;

	/**
	 * Decompresses the byte array. For content running in Adobe AIR, you can
	 * specify a compression algorithm by passing a value(defined in the
	 * CompressionAlgorithm class) as the <code>algorithm</code> parameter. The
	 * byte array must have been compressed using the same algorithm. Flash
	 * Player supports only the default algorithm, zlib.
	 *
	 * <p>After the call, the <code>length</code> property of the ByteArray is
	 * set to the new length. The <code>position</code> property is set to 0.</p>
	 *
	 * <p>The zlib compressed data format is described at <a
	 * href="http://www.ietf.org/rfc/rfc1950.txt"
	 * scope="external">http://www.ietf.org/rfc/rfc1950.txt</a>.</p>
	 *
	 * <p>The deflate compression algorithm is described at <a
	 * href="http://www.ietf.org/rfc/rfc1951.txt"
	 * scope="external">http://www.ietf.org/rfc/rfc1951.txt</a>.</p>
	 *
	 * <p>In order to decode data compressed in a format that uses the deflate
	 * compression algorithm, such as data in gzip or zip format, it will not
	 * work to call <code>uncompress(CompressionAlgorithm.DEFLATE)</code> on a
	 * ByteArray containing the compression formation data. First, you must
	 * separate the metadata that is included as part of the compressed data
	 * format from the actual compressed data. For more information, see the
	 * <code>compress()</code> method description.</p>
	 * 
	 * @throws IOError The data is not valid compressed data; it was not
	 *                 compressed with the same compression algorithm used to
	 *                 compress.
	 */
	function uncompress(#if flash11 ?algorithm : CompressionAlgorithm #end) : Void;

	/**
	 * Writes a Boolean value. A single byte is written according to the
	 * <code>value</code> parameter, either 1 if <code>true</code> or 0 if
	 * <code>false</code>.
	 * 
	 * @param value A Boolean value determining which byte is written. If the
	 *              parameter is <code>true</code>, the method writes a 1; if
	 *              <code>false</code>, the method writes a 0.
	 */
	function writeBoolean(value : Bool) : Void;

	/**
	 * Writes a byte to the byte stream.
	 *
	 * <p>The low 8 bits of the parameter are used. The high 24 bits are ignored.
	 * </p>
	 * 
	 * @param value A 32-bit integer. The low 8 bits are written to the byte
	 *              stream.
	 */
	function writeByte(value : Int) : Void;

	/**
	 * Writes a sequence of <code>length</code> bytes from the specified byte
	 * array, <code>bytes</code>, starting <code>offset</code>(zero-based index)
	 * bytes into the byte stream.
	 *
	 * <p>If the <code>length</code> parameter is omitted, the default length of
	 * 0 is used; the method writes the entire buffer starting at
	 * <code>offset</code>. If the <code>offset</code> parameter is also omitted,
	 * the entire buffer is written. </p>
	 *
	 * <p>If <code>offset</code> or <code>length</code> is out of range, they are
	 * clamped to the beginning and end of the <code>bytes</code> array.</p>
	 * 
	 * @param bytes  The ByteArray object.
	 * @param offset A zero-based index indicating the position into the array to
	 *               begin writing.
	 * @param length An unsigned integer indicating how far into the buffer to
	 *               write.
	 */
	function writeBytes(bytes : ByteArray, offset : Int = 0, length : Int = 0) : Void;

	/**
	 * Writes an IEEE 754 double-precision(64-bit) floating-point number to the
	 * byte stream.
	 * 
	 * @param value A double-precision(64-bit) floating-point number.
	 */
	function writeDouble(value : Float) : Void;

	/**
	 * Writes an IEEE 754 single-precision(32-bit) floating-point number to the
	 * byte stream.
	 * 
	 * @param value A single-precision(32-bit) floating-point number.
	 */
	function writeFloat(value : Float) : Void;

	/**
	 * Writes a 32-bit signed integer to the byte stream.
	 * 
	 * @param value An integer to write to the byte stream.
	 */
	function writeInt(value : Int) : Void;

	/**
	 * Writes a multibyte string to the byte stream using the specified character
	 * set.
	 * 
	 * @param value   The string value to be written.
	 * @param charSet The string denoting the character set to use. Possible
	 *                character set strings include <code>"shift-jis"</code>,
	 *                <code>"cn-gb"</code>, <code>"iso-8859-1"</code>, and
	 *                others. For a complete list, see <a
	 *                href="../../charset-codes.html">Supported Character
	 *                Sets</a>.
	 */
	function writeMultiByte(value : String, charSet : String) : Void;

	/**
	 * Writes an object into the byte array in AMF serialized format.
	 * 
	 * @param object The object to serialize.
	 */
	function writeObject(object : Dynamic) : Void;

	/**
	 * Writes a 16-bit integer to the byte stream. The low 16 bits of the
	 * parameter are used. The high 16 bits are ignored.
	 * 
	 * @param value 32-bit integer, whose low 16 bits are written to the byte
	 *              stream.
	 */
	function writeShort(value : Int) : Void;

	/**
	 * Writes a UTF-8 string to the byte stream. The length of the UTF-8 string
	 * in bytes is written first, as a 16-bit integer, followed by the bytes
	 * representing the characters of the string.
	 * 
	 * @param value The string value to be written.
	 * @throws RangeError If the length is larger than 65535.
	 */
	function writeUTF(value : String) : Void;

	/**
	 * Writes a UTF-8 string to the byte stream. Similar to the
	 * <code>writeUTF()</code> method, but <code>writeUTFBytes()</code> does not
	 * prefix the string with a 16-bit length word.
	 * 
	 * @param value The string value to be written.
	 */
	function writeUTFBytes(value : String) : Void;

	/**
	 * Writes a 32-bit unsigned integer to the byte stream.
	 * 
	 * @param value An unsigned integer to write to the byte stream.
	 */
	function writeUnsignedInt(value : Int) : Void;

	/**
	 * Denotes the default object encoding for the ByteArray class to use for a
	 * new ByteArray instance. When you create a new ByteArray instance, the
	 * encoding on that instance starts with the value of
	 * <code>defaultObjectEncoding</code>. The <code>defaultObjectEncoding</code>
	 * property is initialized to <code>ObjectEncoding.AMF3</code>.
	 *
	 * <p>When an object is written to or read from binary data, the
	 * <code>objectEncoding</code> value is used to determine whether the
	 * ActionScript 3.0, ActionScript2.0, or ActionScript 1.0 format should be
	 * used. The value is a constant from the ObjectEncoding class.</p>
	 */
	static var defaultObjectEncoding : Int;
}


#end
