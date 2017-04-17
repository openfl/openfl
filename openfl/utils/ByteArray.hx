package openfl.utils;


import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.FPHelper;
import lime.utils.BytePointer;
import lime.utils.DataPointer;
import lime.utils.compress.Deflate;
import lime.utils.compress.LZMA;
import lime.utils.compress.Zlib;
import lime.utils.ArrayBuffer;
import lime.utils.Bytes in LimeBytes;
import openfl.errors.EOFError;

@:access(haxe.io.Bytes)
@:access(openfl.utils.ByteArrayData)
@:forward(bytesAvailable, endian, objectEncoding, position, clear, compress, deflate, inflate, readBoolean, readByte, readBytes, readDouble, readFloat, readInt, readMultiByte, readShort, readUnsignedByte, readUnsignedInt, readUnsignedShort, readUTF, readUTFBytes, toString, uncompress, writeBoolean, writeByte, writeBytes, writeDouble, writeFloat, writeInt, writeMultiByte, writeShort, writeUnsignedInt, writeUTF, writeUTFBytes)


abstract ByteArray(ByteArrayData) from ByteArrayData to ByteArrayData {
	
	
	public static var defaultObjectEncoding:UInt;
	
	private static var __bytePointer = new BytePointer ();
	
	public var length (get, set):Int;
	
	
	public inline function new (length:Int = 0):Void {
		
		#if (display || flash)
		this = new ByteArrayData ();
		this.length = length;
		#else
		this = new ByteArrayData (length);
		#end
		
	}
	
	
	@:arrayAccess @:noCompletion private inline function get (index:Int):Int {
		
		#if display
		return 0;
		#elseif flash
		return this[index];
		#else
		return this.get (index);
		#end
		
	}
	
	
	@:arrayAccess @:noCompletion private inline function set (index:Int, value:Int):Int {
		
		#if display
		#elseif flash
		this[index] = value;
		#else
		this.__resize (index + 1);
		this.set (index, value);
		#end
		return value;
		
	}
	
	
	@:from @:noCompletion public static function fromArrayBuffer (buffer:ArrayBuffer):ByteArray {
		
		if (buffer == null) return null;
		
		#if display
		return null;
		#elseif js
		return ByteArrayData.fromBytes (Bytes.ofData (buffer));
		#elseif flash
		return (buffer:Bytes).getData ();
		#else
		return ByteArrayData.fromBytes ((buffer:Bytes));
		#end
		
	}
	
	
	@:from @:noCompletion public static function fromBytes (bytes:Bytes):ByteArray {
		
		if (bytes == null) return null;
		
		#if display
		
		return null;
		
		#else
		
		if (Std.is (bytes, ByteArrayData)) {
			
			return cast bytes;
			
		} else {
			
			#if flash
			return bytes.getData ();
			#else
			return ByteArrayData.fromBytes (bytes);
			#end
			
		}
		
		#end
		
	}
	
	
	@:from @:noCompletion public static function fromBytesData (bytesData:BytesData):ByteArray {
		
		if (bytesData == null) return null;
		
		#if display
		return null;
		#elseif flash
		return bytesData;
		#else
		return ByteArrayData.fromBytes (Bytes.ofData (bytesData));
		#end
		
	}
	
	
	public static function fromFile (path:String):ByteArray {
		
		return LimeBytes.fromFile (path);
		
	}
	
	
	@:from @:noCompletion public static function fromLimeBytes (bytes:LimeBytes):ByteArray {
		
		return fromBytes (bytes);
		
	}
	
	
	@:to @:noCompletion public static function toArrayBuffer (byteArray:ByteArray):ArrayBuffer {
		
		#if display
		return null;
		#elseif js
		return (byteArray:ByteArrayData).getData ();
		#elseif flash
		return Bytes.ofData (byteArray);
		#else
		return (byteArray:ByteArrayData);
		#end
		
	}
	
	
	@:to @:noCompletion private static function toDataPointer (byteArray:ByteArray):DataPointer {
		
		__bytePointer.set ((byteArray:ByteArrayData), byteArray.position);
		return __bytePointer;
		
	}
	
	
	@:to @:noCompletion private static function toBytes (byteArray:ByteArray):Bytes {
		
		#if display
		return null;
		#elseif flash
		return Bytes.ofData (byteArray);
		#else
		return (byteArray:ByteArrayData);
		#end
		
	}
	
	
	#if !display
	@:to @:noCompletion private static function toBytesData (byteArray:ByteArray):BytesData {
		
		#if display
		return null;
		#elseif flash
		return byteArray;
		#else
		return (byteArray:ByteArrayData).getData ();
		#end
		
	}
	#end
	
	
	@:to @:noCompletion private static function toLimeBytes (byteArray:ByteArray):LimeBytes {
		
		return fromBytes (byteArray);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_length ():Int {
		
		#if display
		return 0;
		#else
		return this.length;
		#end
		
	}
	
	
	@:noCompletion private function set_length (value:Int):Int {
		
		#if display
		#elseif flash
		this.length = value;
		#else
		if (value > 0) {
			
			this.__resize (value);
			
		}
		
		this.length = value;
		#end
		
		return value;
		
	}
	
	
}


#if (!display && !flash)


@:autoBuild(lime._macros.AssetsMacro.embedByteArray())

@:noCompletion @:dox(hide) class ByteArrayData extends Bytes implements IDataInput implements IDataOutput {
	
	
	public var bytesAvailable (get, never):UInt;
	public var endian (get, set):Endian;
	public var objectEncoding:UInt;
	public var position:Int;
	
	private var __endian:Endian;
	private var __length:Int;
	
	
	public function new (length:Int = 0) {
		
		var bytes = Bytes.alloc (length);
		
		#if sys
		if (length > 0) {
			
			bytes.fill (0, length, 0);
			
		}
		#end
		
		#if js
		super (bytes.b.buffer);
		#else
		super (length, bytes.b);
		#end
		
		__length = length;
		endian = BIG_ENDIAN;
		position = 0;
		
	}
	
	
	public function clear ():Void {
		
		length = 0;
		position = 0;
		
	}
	
	
	public function compress (algorithm:CompressionAlgorithm = ZLIB):Void {
		
		#if (js && html5)
		if (__length > length) {
			
			var cacheLength = length;
			this.length = __length;
			var data = Bytes.alloc (cacheLength);
			data.blit (0, this, 0, cacheLength);
			__setData (data);
			this.length = cacheLength;
			
		}
		#end
		
		var bytes = switch (algorithm) {
			
			case CompressionAlgorithm.DEFLATE: Deflate.compress (this);
			case CompressionAlgorithm.LZMA: LZMA.compress (this);
			default: Zlib.compress (this);
			
		}
		
		if (bytes != null) {
			
			__setData (bytes);
			
			length = __length;
			position = length;
			
		}
		
	}
	
	
	public function deflate ():Void {
		
		compress (CompressionAlgorithm.DEFLATE);
		
	}
	
	
	public static function fromBytes (bytes:Bytes):ByteArrayData {
		
		var result = new ByteArrayData ();
		result.__fromBytes (bytes);
		return result;
		
	}
	
	
	public function inflate () {
		
		uncompress (CompressionAlgorithm.DEFLATE);
		
	}
	
	
	public function readBoolean ():Bool {
		
		if (position < length) {
			
			return (get (position++) != 0);
			
		} else {
			
			throw new EOFError ();
			return false;
			
		}
		
	}
	
	
	public function readByte ():Int {
		
		var value = readUnsignedByte ();
		
		if (value & 0x80 != 0) {
			
			return value - 0x100;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function readBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void {
		
		if (length == 0) length = this.length - position;
		
		if (position + length > this.length) {
			
			throw new EOFError ();
			
		}
		
		if ((bytes:ByteArrayData).length < offset + length) {
			
			(bytes:ByteArrayData).__resize (offset + length);
			
		}
		
		(bytes:ByteArrayData).blit (offset, this, position, length);
		position += length;
		
	}
	
	
	public function readDouble ():Float {
		
		var ch1 = readInt ();
		var ch2 = readInt ();
		
		if (endian == LITTLE_ENDIAN) {
			
			return FPHelper.i64ToDouble (ch1, ch2);
			
		} else {
			
			return FPHelper.i64ToDouble (ch2, ch1);
			
		}
		
	}
	
	
	public function readFloat ():Float {
		
		return FPHelper.i32ToFloat (readInt ());
		
	}
	
	
	public function readInt ():Int {
		
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var ch3 = readUnsignedByte ();
		var ch4 = readUnsignedByte ();
		
		if (endian == LITTLE_ENDIAN) {
			
			return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
			
		} else {
			
			return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
			
		}
		
	}
	
	
	public function readMultiByte (length:Int, charSet:String):String {
		
		return readUTFBytes (length);
		
	}
	
	
	public function readShort ():Int {
		
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		
		var value;
		
		if (endian == LITTLE_ENDIAN) {
			
			value = ((ch2 << 8) | ch1);
			
		} else {
			
			value = ((ch1 << 8) | ch2);
			
		}
		
		if ((value & 0x8000) != 0) {
			
			return value - 0x10000;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function readUnsignedByte ():Int {
		
		if (position < length) {
			
			return get (position++);
			
		} else {
			
			throw new EOFError ();
			return 0;
			
		}
		
	}
	
	
	public function readUnsignedInt ():Int {
		
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var ch3 = readUnsignedByte ();
		var ch4 = readUnsignedByte ();
		
		if (endian == LITTLE_ENDIAN) {
			
			return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
			
		} else {
			
			return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
			
		}
		
	}
	
	
	public function readUnsignedShort ():Int {
		
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		
		if (endian == LITTLE_ENDIAN) {
			
			return (ch2 << 8) + ch1;
			
		} else {
			
			return (ch1 << 8) | ch2;
			
		}
		
	}
	
	
	public function readUTF ():String {
		
		var bytesCount = readUnsignedShort ();
		return readUTFBytes (bytesCount);
		
	}
	
	
	public function readUTFBytes (length:Int):String {
		
		if (position + length > this.length) {
			
			throw new EOFError ();
			
		}
		
		position += length;
		
		
		return getString (position - length, length);
		
	}
	
	
	public function uncompress (algorithm:CompressionAlgorithm = ZLIB):Void {
		
		#if (js && html5)
		if (__length > length) {
			
			var cacheLength = length;
			this.length = __length;
			var data = Bytes.alloc (cacheLength);
			data.blit (0, this, 0, cacheLength);
			__setData (data);
			this.length = cacheLength;
			
		}
		#end
		
		var bytes = switch (algorithm) {
			
			case CompressionAlgorithm.DEFLATE: Deflate.decompress (this);
			case CompressionAlgorithm.LZMA: LZMA.decompress (this);
			default: Zlib.decompress (this);
			
		};
		
		if (bytes != null) {
			
			__setData (bytes);
			
			length = __length;
			position = 0;
			
		}
		
	}
	
	
	public function writeBoolean (value:Bool):Void {
		
		this.writeByte (value ? 1 : 0);
		
	}
	
	
	public function writeByte (value:Int):Void {
		
		__resize (position + 1);
		set (position++, value & 0xFF);
		
	}
	
	
	public function writeBytes (bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void {
		
		if (bytes.length == 0) return;
		if (length == 0) length = bytes.length - offset;
		
		__resize (position + length);
		blit (position, (bytes:ByteArrayData), offset, length);
		
		position += length;
		
	}
	
	
	public function writeDouble (value:Float):Void {
		
		var int64 = FPHelper.doubleToI64 (value);
		
		if (endian == LITTLE_ENDIAN) {
			
			writeInt (int64.low);
			writeInt (int64.high);
			
		} else {
			
			writeInt (int64.high);
			writeInt (int64.low);
			
		}
		
	}
	
	
	public function writeFloat (value:Float):Void {
		
		if (endian == LITTLE_ENDIAN) {
			
			__resize (position + 4);
			setFloat (position, value);
			position += 4;
			
		} else {
			
			var int = FPHelper.floatToI32 (value);
			writeInt (int);
			
		}
		
	}
	
	
	public function writeInt (value:Int):Void {
		
		__resize (position + 4);
		
		if (endian == LITTLE_ENDIAN) {
			
			set (position++, value & 0xFF);
			set (position++, (value >> 8) & 0xFF);
			set (position++, (value >> 16) & 0xFF);
			set (position++, (value >> 24) & 0xFF);
			
		} else {
			
			set (position++, (value >> 24) & 0xFF);
			set (position++, (value >> 16) & 0xFF);
			set (position++, (value >> 8) & 0xFF);
			set (position++, value & 0xFF);
			
		}
		
	}
	
	
	public function writeMultiByte (value:String, charSet:String):Void {
		
		writeUTFBytes (value);
		
	}
	
	
	public function writeShort (value:Int):Void {
		
		__resize (position + 2);
		
		if (endian == LITTLE_ENDIAN) {
			
			set (position++, value);
			set (position++, value >> 8);
			
		} else {
			
			set (position++, value >> 8);
			set (position++, value);
			
		}
		
	}
	
	
	public function writeUnsignedInt (value:Int):Void {
		
		writeInt (value);
		
	}
	
	
	public function writeUTF (value:String):Void {
		
		var bytes = Bytes.ofString (value);
		
		writeShort (bytes.length);
		writeBytes (bytes);
		
	}
	
	
	public function writeUTFBytes (value:String):Void {
		
		var bytes = Bytes.ofString (value);
		writeBytes (Bytes.ofString (value));
		
	}
	
	
	private function __fromBytes (bytes:Bytes):Void {
		
		__setData (bytes);
		length = bytes.length;
		
	}
	
	
	private function __resize (size:Int) {
		
		if (size > __length) {
			
			var bytes = Bytes.alloc (((size + 1) * 3) >> 1);
			#if sys
			bytes.fill (length, size, 0);
			#end
			var cacheLength = length;
			length = __length;
			bytes.blit (0, this, 0, __length);
			length = cacheLength;
			__setData (bytes);
			
		}
		
		if (length < size) {
			
			length = size;
			
		}
		
	}
	
	
	private inline function __setData (bytes:Bytes):Void {
		
		b = bytes.b;
		__length = bytes.length;
		
		#if js
		data = bytes.data;
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private inline function get_bytesAvailable ():Int {
		
		return length - position;
		
	}
	
	
	@:noCompletion private inline function get_endian ():Endian {
		
		return __endian;
		
	}
	
	
	@:noCompletion private inline function set_endian (value:Endian):Endian {
		
		return __endian = value;
		
	}
	
	
}


#else


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

#if flash
@:native("flash.utils.ByteArray")
#end

extern class ByteArrayData implements IDataOutput implements IDataInput implements ArrayAccess<Int> {
	
	
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
	public static var defaultObjectEncoding:UInt;
	
	/**
	 * The number of bytes of data available for reading from the current
	 * position in the byte array to the end of the array.
	 *
	 * <p>Use the <code>bytesAvailable</code> property in conjunction with the
	 * read methods each time you access a ByteArray object to ensure that you
	 * are reading valid data.</p>
	 */
	#if (flash && !display)
	public var bytesAvailable (default, null):UInt;
	#else
	public var bytesAvailable (get, never):UInt; private inline function get_bytesAvailable ():UInt { return 0; }
	#end
	
	/**
	 * Changes or reads the byte order for the data; either
	 * <code>Endian.BIG_ENDIAN</code> or <code>Endian.LITTLE_ENDIAN</code>.
	 */
	#if (flash && !display)
	public var endian:Endian;
	#else
	public var endian (get, set):Endian;
	
	private function get_endian ():Endian;
	private function set_endian (value:Endian):Endian;
	#end
	
	/**
	 * The length of the ByteArray object, in bytes.
	 *
	 * <p>If the length is set to a value that is larger than the current length,
	 * the right side of the byte array is filled with zeros.</p>
	 *
	 * <p>If the length is set to a value that is smaller than the current
	 * length, the byte array is truncated.</p>
	 */
	public var length:UInt;
	
	/**
	 * Used to determine whether the ActionScript 3.0, ActionScript 2.0, or
	 * ActionScript 1.0 format should be used when writing to, or reading from, a
	 * ByteArray instance. The value is a constant from the ObjectEncoding class.
	 */
	public var objectEncoding:UInt;
	
	/**
	 * Moves, or returns the current position, in bytes, of the file pointer into
	 * the ByteArray object. This is the point at which the next call to a read
	 * method starts reading or a write method starts writing.
	 */
	public var position:UInt;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public var shareable:Bool;
	#end
	
	
	/**
	 * Creates a ByteArray instance representing a packed array of bytes, so that
	 * you can use the methods and properties in this class to optimize your data
	 * storage and stream.
	 */
	public function new ();
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public function atomicCompareAndSwapIntAt (byteIndex:Int, expectedValue:Int, newValue:Int):Int;
	#end
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public function atomicCompareAndSwapLength (expectedLength:Int, newLength:Int):Int;
	#end
	
	
	/**
	 * Clears the contents of the byte array and resets the <code>length</code>
	 * and <code>position</code> properties to 0. Calling this method explicitly
	 * frees up the memory used by the ByteArray instance.
	 * 
	 */
	public function clear ():Void;
	
	
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
	public function compress (algorithm:CompressionAlgorithm = null):Void;
	
	
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
	public function deflate ():Void;
	
	
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
	public function inflate ():Void;
	
	
	/**
	 * Reads a Boolean value from the byte stream. A single byte is read, and
	 * <code>true</code> is returned if the byte is nonzero, <code>false</code>
	 * otherwise.
	 * 
	 * @return Returns <code>true</code> if the byte is nonzero,
	 *         <code>false</code> otherwise.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readBoolean ():Bool;
	
	
	/**
	 * Reads a signed byte from the byte stream.
	 *
	 * <p>The returned value is in the range -128 to 127.</p>
	 * 
	 * @return An integer between -128 and 127.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readByte ():Int;
	
	
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
	public function readBytes (bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void;
	
	
	/**
	 * Reads an IEEE 754 double-precision(64-bit) floating-point number from the
	 * byte stream.
	 * 
	 * @return A double-precision(64-bit) floating-point number.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readDouble ():Float;
	
	
	/**
	 * Reads an IEEE 754 single-precision(32-bit) floating-point number from the
	 * byte stream.
	 * 
	 * @return A single-precision(32-bit) floating-point number.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readFloat ():Float;
	
	
	/**
	 * Reads a signed 32-bit integer from the byte stream.
	 *
	 * <p>The returned value is in the range -2147483648 to 2147483647.</p>
	 * 
	 * @return A 32-bit signed integer between -2147483648 and 2147483647.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readInt ():Int;
	
	
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
	public function readMultiByte (length:UInt, charSet:String):String;
	
	
	/**
	 * Reads an object from the byte array, encoded in AMF serialized format.
	 * 
	 * @return The deserialized object.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	#if flash
	@:noCompletion @:dox(hide) public function readObject ():Dynamic;
	#end
	
	
	/**
	 * Reads a signed 16-bit integer from the byte stream.
	 *
	 * <p>The returned value is in the range -32768 to 32767.</p>
	 * 
	 * @return A 16-bit signed integer between -32768 and 32767.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readShort ():Int;
	
	
	/**
	 * Reads a UTF-8 string from the byte stream. The string is assumed to be
	 * prefixed with an unsigned short indicating the length in bytes.
	 * 
	 * @return UTF-8 encoded string.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readUTF ():String;
	
	
	/**
	 * Reads a sequence of UTF-8 bytes specified by the <code>length</code>
	 * parameter from the byte stream and returns a string.
	 * 
	 * @param length An unsigned short indicating the length of the UTF-8 bytes.
	 * @return A string composed of the UTF-8 bytes of the specified length.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readUTFBytes (length:UInt):String;
	
	
	/**
	 * Reads an unsigned byte from the byte stream.
	 *
	 * <p>The returned value is in the range 0 to 255. </p>
	 * 
	 * @return A 32-bit unsigned integer between 0 and 255.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readUnsignedByte ():UInt;
	
	
	/**
	 * Reads an unsigned 32-bit integer from the byte stream.
	 *
	 * <p>The returned value is in the range 0 to 4294967295. </p>
	 * 
	 * @return A 32-bit unsigned integer between 0 and 4294967295.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readUnsignedInt ():UInt;
	
	
	/**
	 * Reads an unsigned 16-bit integer from the byte stream.
	 *
	 * <p>The returned value is in the range 0 to 65535. </p>
	 * 
	 * @return A 16-bit unsigned integer between 0 and 65535.
	 * @throws EOFError There is not sufficient data available to read.
	 */
	public function readUnsignedShort ():UInt;
	
	
	/**
	 * Converts the byte array to a string. If the data in the array begins with
	 * a Unicode byte order mark, the application will honor that mark when
	 * converting to a string. If <code>System.useCodePage</code> is set to
	 * <code>true</code>, the application will treat the data in the array as
	 * being in the current system code page when converting.
	 * 
	 * @return The string representation of the byte array.
	 */
	public function toString ():String;
	
	
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
	public function uncompress (algorithm:CompressionAlgorithm = null):Void;
	
	
	/**
	 * Writes a Boolean value. A single byte is written according to the
	 * <code>value</code> parameter, either 1 if <code>true</code> or 0 if
	 * <code>false</code>.
	 * 
	 * @param value A Boolean value determining which byte is written. If the
	 *              parameter is <code>true</code>, the method writes a 1; if
	 *              <code>false</code>, the method writes a 0.
	 */
	public function writeBoolean (value:Bool):Void;
	
	
	/**
	 * Writes a byte to the byte stream.
	 *
	 * <p>The low 8 bits of the parameter are used. The high 24 bits are ignored.
	 * </p>
	 * 
	 * @param value A 32-bit integer. The low 8 bits are written to the byte
	 *              stream.
	 */
	public function writeByte (value:Int):Void;
	
	
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
	public function writeBytes (bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void;
	
	
	/**
	 * Writes an IEEE 754 double-precision(64-bit) floating-point number to the
	 * byte stream.
	 * 
	 * @param value A double-precision(64-bit) floating-point number.
	 */
	public function writeDouble (value:Float):Void;
	
	
	/**
	 * Writes an IEEE 754 single-precision(32-bit) floating-point number to the
	 * byte stream.
	 * 
	 * @param value A single-precision(32-bit) floating-point number.
	 */
	public function writeFloat (value:Float):Void;
	
	
	/**
	 * Writes a 32-bit signed integer to the byte stream.
	 * 
	 * @param value An integer to write to the byte stream.
	 */
	public function writeInt (value:Int):Void;
	
	
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
	public function writeMultiByte (value:String, charSet:String):Void;
	
	
	/**
	 * Writes an object into the byte array in AMF serialized format.
	 * 
	 * @param object The object to serialize.
	 */
	#if flash
	@:noCompletion @:dox(hide) public function writeObject (object:Dynamic):Void;
	#end
	
	
	/**
	 * Writes a 16-bit integer to the byte stream. The low 16 bits of the
	 * parameter are used. The high 16 bits are ignored.
	 * 
	 * @param value 32-bit integer, whose low 16 bits are written to the byte
	 *              stream.
	 */
	public function writeShort (value:Int):Void;
	
	
	/**
	 * Writes a UTF-8 string to the byte stream. The length of the UTF-8 string
	 * in bytes is written first, as a 16-bit integer, followed by the bytes
	 * representing the characters of the string.
	 * 
	 * @param value The string value to be written.
	 * @throws RangeError If the length is larger than 65535.
	 */
	public function writeUTF (value:String):Void;
	
	
	/**
	 * Writes a UTF-8 string to the byte stream. Similar to the
	 * <code>writeUTF()</code> method, but <code>writeUTFBytes()</code> does not
	 * prefix the string with a 16-bit length word.
	 * 
	 * @param value The string value to be written.
	 */
	public function writeUTFBytes (value:String):Void;
	
	
	/**
	 * Writes a 32-bit unsigned integer to the byte stream.
	 * 
	 * @param value An unsigned integer to write to the byte stream.
	 */
	public function writeUnsignedInt (value:UInt):Void;
	
	
}


#end