package openfl.utils; #if !openfl_legacy


import haxe.io.Bytes;

#if !flash
import haxe.io.BytesBuffer;
import haxe.io.BytesData;
import haxe.io.Input;
import haxe.zip.Compress;
import haxe.zip.Uncompress;
import lime.utils.ArrayBuffer;
import lime.utils.LZMA;
import openfl.utils.CompressionAlgorithm;
import openfl.utils.IDataInput;

#if js
#if format
import format.tools.Inflate;
#end
import js.html.DataView;
import js.html.Uint8Array;
#elseif cpp
import cpp.NativeArray;
#end

#if sys
import sys.io.File;
#end
#end


abstract ByteArray(ByteArrayData) from ByteArrayData to ByteArrayData {
	
	
	public static var defaultObjectEncoding:UInt;
	
	public var bytesAvailable (get, never):Int;
	public var endian (get, set):Endian;
	public var length (get, set):Int;
	public var objectEncoding (get, set):Int;
	public var position (get, set):Int;
	
	
	public inline function new (length:Int = 0):Void {
		
		#if flash
		this = new ByteArrayData ();
		this.length = length;
		#else
		this = new ByteArrayData (length);
		#end
		
	}
	
	
	public inline function clear ():Void {
		
		this.clear ();
		
	}
	
	
	public inline function compress (algorithm:CompressionAlgorithm = null):Void {
		
		this.compress (algorithm);
		
	}
	
	
	public inline function deflate ():Void {
		
		this.deflate ();
		
	}
	
	
	public inline function inflate () {
		
		this.inflate ();
		
	}
	
	
	public inline function readBoolean ():Bool {
		
		return this.readBoolean ();
		
	}
	
	
	public inline function readByte ():Int {
		
		return this.readByte ();
		
	}
	
	
	public function readBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void {
		
		return this.readBytes (bytes, offset, length);
		
	}
	
	
	public function readDouble ():Float {
		
		return this.readDouble ();
		
	}
	
	
	public function readFloat ():Float {
		
		return this.readFloat ();
		
	}
	
	
	public function readInt ():Int {
		
		return this.readInt ();
		
	}
	
	
	public inline function readMultiByte (length:Int, charSet:String):String {
		
		return this.readMultiByte (length, charSet);
		
	}
	
	
	public function readShort ():Int {
		
		return this.readShort ();
		
	}
	
	
	public inline function readUnsignedByte ():Int {
		
		return this.readUnsignedByte ();
		
	}
	
	
	public inline function readUnsignedInt ():Int {
		
		return this.readUnsignedInt ();
		
	}
	
	
	public inline function readUnsignedShort ():Int {
		
		return this.readUnsignedShort ();
		
	}
	
	
	public inline function readUTF ():String {
		
		return this.readUTF ();
		
	}
	
	
	public inline function readUTFBytes (len:Int):String {
		
		return this.readUTFBytes (len);
		
	}
	
	
	public inline function toString ():String {
		
		return this.toString ();
		
	}
	
	
	public inline function uncompress (algorithm:CompressionAlgorithm = null):Void {
		
		return this.uncompress (algorithm);
		
	}
	
	
	public inline function writeBoolean (value:Bool):Void {
		
		this.writeBoolean (value);
		
	}
	
	
	public inline function writeByte (value:Int):Void {
		
		this.writeByte (value);
		
	}
	
	
	public inline function writeBytes (bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void {
		
		this.writeBytes (bytes, offset, length);
		
	}
	
	
	public inline function writeDouble (x:Float):Void {
		
		this.writeDouble (x);
		
	}
	
	
	public inline function writeFloat (x:Float):Void {
		
		this.writeFloat (x);
		
	}
	
	
	public inline function writeInt (value:Int):Void {
		
		this.writeInt (value);
		
	}
	
	
	public inline function writeShort (value:Int):Void {
		
		this.writeShort (value);
		
	}
	
	
	public inline function writeUnsignedInt (value:Int):Void {
		
		this.writeUnsignedInt (value);
		
	}
	
	
	public inline function writeUTF (value:String):Void {
		
		this.writeUTF (value);
		
	}
	
	
	public inline function writeUTFBytes (value:String):Void {
		
		this.writeUTFBytes (value);
		
	}
	
	
	@:arrayAccess @:noCompletion private inline function get (index:Int):Int {
		
		#if flash
		return this[index];
		#else
		return this.__get (index);
		#end
		
	}
	
	
	@:arrayAccess @:noCompletion private inline function set (index:Int, value:Int):Int {
		
		#if flash
		this[index] = value;
		#else
		this.__set (index, value);
		#end
		return value;
		
	}
	
	
	@:from public static function fromBytes (bytes:Bytes):ByteArray {
		
		#if flash
		return bytes.getData ();
		#else
		return ByteArrayData.fromBytes (bytes);
		#end
		
	}
	
	
	@:to @:noCompletion private static function toBytes (byteArray:ByteArray):Bytes {
		
		#if flash
		return Bytes.ofData (byteArray);
		#elseif (js && html5)
		return Bytes.ofData ((byteArray:ByteArrayData).byteView.buffer);
		#else
		return byteArray;
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private inline function get_bytesAvailable ():Int {
		
		return this.bytesAvailable;
		
	}
	
	
	@:noCompletion private inline function get_endian ():Endian {
		
		#if flash
		return this.endian;
		#else
		return (this.endian == "littleEndian" ? Endian.LITTLE_ENDIAN : Endian.BIG_ENDIAN);
		#end
		
	}
	
	
	@:noCompletion private inline function set_endian (value:Endian):Endian {
		
		#if flash
		this.endian = value;
		#else
		if (value == Endian.LITTLE_ENDIAN) {
			
			this.endian = "littleEndian";
			
		} else {
			
			this.endian = "bigEndian";
			
		}
		#end
		
		return value;
		
	}
	
	
	@:noCompletion private inline function get_length ():Int {
		
		return this.length;
		
	}
	
	
	@:noCompletion private inline function set_length (value:Int):Int {
		
		#if (flash || js)
		this.length = value;
		#else
		this.setLength (value);
		#end
		
		return value;
		
	}
	
	
	@:noCompletion private inline function get_objectEncoding ():Int {
		
		return this.objectEncoding;
		
	}
	
	
	@:noCompletion private inline function set_objectEncoding (value:Int):Int {
		
		return this.objectEncoding = value;
		
	}
	
	
	@:noCompletion private inline function get_position ():Int {
		
		return this.position;
		
	}
	
	
	@:noCompletion private inline function set_position (value:Int):Int {
		
		return this.position = value;
		
	}
	
	
}


#if !flash


#if !macro
@:build(lime.system.CFFI.build())
#end

//@:autoBuild(lime.Assets.embedFile())


@:noCompletion @:dox(hide) class ByteArrayData #if !js extends Bytes implements ArrayAccess<Int> implements IDataInput /*implements IDataOutput*/ #end {
	
	
	public var bytesAvailable (get, null):Int;
	public var endian (get, set):String;
	#if js
	public var length (default, set):Int = 0;
	#end
	public var objectEncoding:Int;
	public var position:Int = 0;
	
	private var allocated:Int = 0;
	private var littleEndian:Bool = false;
	
	#if js
	public var byteView:Uint8Array;
	private var data:DataView;
	#else
	public var bigEndian (get, set):Bool;
	public var byteLength (get, null):Int;
	#end
	
	
	public function new (size = 0):Void {
		
		#if js
		if (size > 0) allocated = size;
		___resizeBuffer (allocated);
		length = allocated;
		#else
		length = 0;
		if (size > 0) {
			
			#if neko
			allocated = size < 16 ? 16 : size;
			var bytes = untyped __dollar__smake (allocated);
			super (size, bytes);
			#else
			var data = new BytesData (#if java size #end);
			#if cpp
			NativeArray.setSize (data, size);
			#elseif neko
			if (size > 0) untyped data[size - 1] = 0;
			#end
			super (size, data);
			#end
			
		}
		#end
		
	}
	
	
	#if !js
	public function asString ():String {
		
		return readUTFBytes (length);
		
	}
	#end
	
	
	#if !js
	public function checkData (length:Int) {
		
		if (length + position > this.length) {
			
			ThrowEOFi ();
			
		}
		
	}
	#end
	
	
	public function clear ():Void {
		
		length = 0;
		position = 0;
		
	}
	
	
	public function compress (algorithm:CompressionAlgorithm = null):Void {
		
		#if !js
		#if neko
		var src = allocated == length ? this : sub(0, length);
		#else
		var src = this;
		#end
		
		if (algorithm == null) {
			
			algorithm = CompressionAlgorithm.ZLIB;
			
		}
		
		var result:Bytes;
		
		if (algorithm == CompressionAlgorithm.LZMA) {
			
			result = cast lime.utils.LZMA.encode (ByteArray.fromBytes (src));
			
		} else {
			
			var windowBits = switch (algorithm) {
				
				case DEFLATE: -15;
				case GZIP: 31;
				default: 15;
				
			}
			
			#if enable_deflate
			result = Compress.run (src, 8, windowBits);
			#else
			result = Compress.run (src, 8);
			#end
			
		}
		
		b = result.b;
		length = result.length;
		position = length;
		#if neko
		allocated = length;
		#end
		#end
		
	}
	
	
	public function deflate():Void {
		
		compress (CompressionAlgorithm.DEFLATE);
		
	}
	
	
	#if !js
	private function ensureElem (size:Int, updateLength:Bool) {
		
		var len = size + 1;
		
		#if neko
		if (allocated < len) {
			
			allocated = ((len + 1) * 3) >> 1;
			var new_b = untyped __dollar__smake (allocated);
			if (b != null) 
				untyped __dollar__sblit (new_b, 0, b, 0, length);
			b = new_b;
			
		}
		#else
		if (b == null)
			b = new BytesData (#if java len #end);
		
		if (b.length < len) {
			
			untyped b.__SetSize (len);
			
		}
		#end
		
		if (updateLength && length < len) {
			
			length = len;
			
		}
		
	}
	#end
	
	
	#if js
	@:extern private inline function ensureWrite (lengthToEnsure:Int):Void {
		
		if (this.length < lengthToEnsure) this.length = lengthToEnsure;
		
	}
	#end
	
	
	public static function fromBytes (bytes:Bytes):ByteArray {
		
		var result = new ByteArray ();
		(result:ByteArrayData).__fromBytes (bytes);
		return result;
		
	}
	
	
	#if !js
	public function getLength ():Int { return length; }
	public function getByteBuffer ():ByteArray { return this; }
	public function getStart ():Int { return 0; }
	#end
	
	
	public function inflate () {
		
		uncompress (CompressionAlgorithm.DEFLATE);
		
	}
	
	
	public inline function readBoolean ():Bool {
		
		#if js
		return (this.readByte () != 0);
		#else
		return (position < length) ? __get (position++) != 0 : ThrowEOFi () != 0;
		#end
		
	}
	
	
	public inline function readByte ():Int {
		
		#if js
		var data:Dynamic = data;
		return data.getInt8 (this.position++);
		#else
		var val:Int = readUnsignedByte ();
		return ((val & 0x80) != 0) ? (val - 0x100) : val;
		#end
		
	}
	
	
	public function readBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void {
		
		#if js
		
		if (offset < 0 || length < 0) {
			
			throw ("Read error - Out of bounds");
			
		}
		
		if (length == 0) length = this.bytesAvailable;
		
		(bytes:ByteArrayData).ensureWrite (offset + length);
		
		(bytes:ByteArrayData).byteView.set (byteView.subarray (this.position, this.position + length), offset);
		bytes.position = offset;
		
		this.position += length;
		if (bytes.position + length > bytes.length) bytes.length = bytes.position + length;
		
		#else
		
		if (length == 0) length = this.length - position;
		if (position + length > this.length) ThrowEOFi ();
		
		if (bytes.length < offset + length) {
			
			(bytes:ByteArrayData).ensureElem (offset + length - 1, true);
			
		}
		
		#if neko
		(bytes:ByteArrayData).blit (offset, this, position, length);
		#else
		var b1 = b;
		var b2 = bytes.b;
		var p = position;
		for (i in 0...length) b2[offset + i] = b1[p + i];
		#end
		
		position += length;
		
		#end
		
	}
	
	
	public function readDouble ():Float {
		
		#if js
		var double = data.getFloat64 (this.position, littleEndian);
		this.position += 8;
		return double;
		#else
		if (position + 8 > length) ThrowEOFi ();
		position += 8;
		return getDouble (position - 8);
		#end
		
	}
	
	
	public static function readFile (path:String):ByteArray {
		
		#if (!html5 && !macro)
		var data:Dynamic = lime_bytes_read_file (path);
		if (data != null) return ByteArray.fromBytes (@:privateAccess new Bytes (data.length, data.b));
		#end
		return null;
		
	}
	
	
	public function readFloat ():Float {
		
		#if js
		var float = data.getFloat32 (this.position, littleEndian);
		this.position += 4;
		return float;
		#else
		if (position + 4 > length) ThrowEOFi ();
		position += 4;
		return getFloat (position - 4);
		#end
		
	}
	
	
	public function readInt ():Int {
		
		#if js
		var int = data.getInt32 (this.position, littleEndian);
		this.position += 4;
		return int;
		#else
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var ch3 = readUnsignedByte ();
		var ch4 = readUnsignedByte ();
		return littleEndian ? (ch4 << 24) |(ch3 << 16) | (ch2 << 8) | ch1 : (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
		#end
		
	}
	
	
	public inline function readMultiByte (length:Int, charSet:String):String {
		
		return readUTFBytes (length);
		
	}
	
	
	public function readShort ():Int {
		
		#if js
		var short = data.getInt16 (this.position, littleEndian);
		this.position += 2;
		return short;
		#else
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var val = littleEndian ? ((ch2 << 8) | ch1) : ((ch1 << 8) | ch2);
		return ((val & 0x8000) != 0) ? (val - 0x10000) : val;
		#end
		
	}
	
	
	public inline function readUnsignedByte ():Int {
		
		#if js
		var data:Dynamic = data;
		return data.getUint8 (this.position++);
		#else
		return (position < length) ? __get (position++) : ThrowEOFi ();
		#end
		
	}
	
	
	public function readUnsignedInt ():Int {
		
		#if js
		var uInt = data.getUint32 (this.position, littleEndian);
		this.position += 4;
		return uInt;
		#else
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var ch3 = readUnsignedByte ();
		var ch4 = readUnsignedByte ();
		return littleEndian ? (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1 : (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
		#end
		
	}
	
	
	public function readUnsignedShort ():Int {
		
		#if js
		var uShort = data.getUint16 (this.position, littleEndian);
		this.position += 2;
		return uShort;
		#else
		 var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		return littleEndian ? (ch2 << 8) + ch1 : (ch1 << 8) | ch2;
		#end
		
	}
	
	
	public function readUTF ():String {
		
		var bytesCount = readUnsignedShort ();
		return readUTFBytes (bytesCount);
		
	}
	
	
	public function readUTFBytes (len:Int):String {
		
		#if js
		
		var value = "";
		var max = this.position + len;
		
		// utf8-encode
		while (this.position < max) {
			
			var data:Dynamic = data;
			var c = data.getUint8 (this.position++);
			
			if (c < 0x80) {
				
				if (c == 0) break;
				value += String.fromCharCode (c);
				
			} else if (c < 0xE0) {
				
				value += String.fromCharCode (((c & 0x3F) << 6) | (data.getUint8 (this.position++) & 0x7F));
				
			} else if (c < 0xF0) {
				
				var c2 = data.getUint8 (this.position++);
				value += String.fromCharCode (((c & 0x1F) << 12) | ((c2 & 0x7F) << 6) | (data.getUint8 (this.position++) & 0x7F));
				
			} else {
				
				var c2 = data.getUint8 (this.position++);
				var c3 = data.getUint8 (this.position++);
				value += String.fromCharCode (((c & 0x0F) << 18) | ((c2 & 0x7F) << 12) | ((c3 << 6) & 0x7F) | (data.getUint8 (this.position++) & 0x7F));
				
			}
			
		}
		
		return value;
		
		#else
		
		if (position + len > length) {
			
			ThrowEOFi ();
			
		}
		
		var p = position;
		position += len;
		
		#if neko
		if (b == null || len == 0) {
			return new String("");
		}
		else {
			return new String (untyped __dollar__ssub (b, p, len));
		}
		#elseif cpp
		var result = "";
		if (b != null && len > 0) {
			untyped __global__.__hxcpp_string_of_bytes (b, result, p, len);
		}
		return result;
		#elseif java
		return getString (p, len);
		#else 
		return "-";
		#end
		
		#end
		
	}
	
	
	#if !js
	public function setLength (length:Int):Void {
		
		if (length > 0)
			ensureElem (length - 1, false);
		this.length = length;
		
	}
	#end
	
	
	#if !js
	public function slice (begin:Int, ?inEnd:Int):ByteArray {
		
		if (begin < 0) {
			
			begin += length;
			if (begin < 0)
				begin = 0;
			
		}
		
		var end:Int = inEnd == null ? length : inEnd;
		
		if (end < 0) {
			
			end += length;
			
			if (end < 0)
				end = 0;
			
		}
		
		if (begin >= end)
			return new ByteArray ();
		
		var result = new ByteArray (end - begin);
		
		var opos = position;
		(result:ByteArrayData).blit (0, this, begin, end - begin);
		
		return result;
		
	}
	#end
	
	
	#if !js
	private function ThrowEOFi ():Int {
		
		throw "new EOFError();";
		return 0;
		
	}
	#end
	
	
	public #if !js override #end function toString ():String {
		
		var cachePosition = position;
		position = 0;
		var value = readUTFBytes (length);
		position = cachePosition;
		return value;
		
	}
	
	
	public function uncompress (algorithm:CompressionAlgorithm = null):Void {
		
		#if js
		
		#if format
		var bytes = Bytes.ofData (cast byteView);
		var buf = Inflate.run (bytes).getData ();
		this.byteView = untyped __new__("Uint8Array", buf);
		this.data = untyped __new__("DataView", byteView.buffer);
		this.length = this.allocated = byteView.buffer.byteLength;
		#else
		trace ("Warning: ByteArray.uncompress on JS target requires the 'format' haxelib");
		#end
		
		#else
		
		if (algorithm == null) algorithm = CompressionAlgorithm.GZIP;
		
		#if neko
		var src = allocated == length ? this : sub (0, length);
		#else
		var src = this;
		#end
		
		var result:Bytes;
		
		if (algorithm == CompressionAlgorithm.LZMA) {
			
			result = lime.utils.LZMA.decode (ByteArray.fromBytes (src));
			
		} else {
			
			var windowBits = switch (algorithm) {
				case DEFLATE: -15;
				case GZIP: 31;
				default: 15;
			}
			
			#if enable_deflate
			result = Uncompress.run (src, null, windowBits);
			#else
			result = Uncompress.run (src, null);
			#end
			
		}
		
		b = result.b;
		length = result.length;
		position = 0;
		#if neko
		allocated = length;
		#end
		
		#end
		
	}
	
	
	private inline function write_uncheck (byte:Int) {
		
		#if !js
		#if cpp
		untyped b.__unsafe_set (position++, byte);
		#elseif neko
		untyped __dollar__sset (b, position++, byte & 0xff);
		#else
		b[position++] = byte & 0xff;
		#end
		#end
		
	}
	
	
	public inline function writeBoolean (value:Bool):Void {
		
		this.writeByte (value ? 1 : 0);
		
	}
	
	
	public function writeByte (value:Int):Void {
		
		#if js
		ensureWrite (this.position + 1);
		var data:Dynamic = data;
		data.setInt8 (this.position, value);
		this.position += 1;
		#else
		ensureElem (position, true);
		#if neko
		untyped __dollar__sset (b, position++, value & 0xff);
		#else
		b[position++] = untyped value & 0xFF;
		#end
		#end
		
	}
	
	
	public function writeBytes (bytes:#if js ByteArray #else Bytes #end, offset:UInt = 0, length:UInt = 0):Void {
		
		if (bytes.length == 0) return;
		#if js
		if (offset < 0 || length < 0) throw ("Write error - Out of bounds");
		if( length == 0 ) length = bytes.length;
		ensureWrite (this.position + length);
		byteView.set ((bytes:ByteArrayData).byteView.subarray (offset, offset + length), this.position);
		this.position += length;
		#else
		if (length == 0) length = bytes.length - offset;
		ensureElem (position + length - 1, true);
		var opos = position;
		position += length;
		blit (opos, bytes, offset, length);
		#end
		
	}
	
	
	public function writeDouble (x:Float):Void {
		
		#if js
		ensureWrite (this.position + 8);
		data.setFloat64 (this.position, x, littleEndian);
		this.position += 8;
		#else
		ensureElem (position + 7, true);
		setDouble (position, x);
		position += 8;
		#end
		
	}
	
	
	public function writeFile (path:String):Void {
		
		#if sys
		File.saveBytes (path, this);
		#end
		
	}
	
	
	public function writeFloat (x:Float):Void {
		
		#if js
		ensureWrite (this.position + 4);
		data.setFloat32 (this.position, x, littleEndian);
		this.position += 4;
		#else
		ensureElem (position + 3, true);
		setFloat (position, x);
		position += 4;
		#end
		
	}
	
	
	public function writeInt (value:Int):Void {
		
		#if js
		ensureWrite (this.position + 4);
		data.setInt32 (this.position, value, littleEndian);
		this.position += 4;
		#else
		ensureElem (position + 3, true);
		
		if (littleEndian) {
			
			write_uncheck (value);
			write_uncheck (value >> 8);
			write_uncheck (value >> 16);
			write_uncheck (value >> 24);
			
		} else {
			
			write_uncheck (value >> 24);
			write_uncheck (value >> 16);
			write_uncheck (value >> 8);
			write_uncheck (value);
			
		}
		#end
		
	}
	
	
	public function writeShort (value:Int):Void {
		
		#if js
		ensureWrite (this.position + 2);
		data.setInt16 (this.position, value, littleEndian);
		this.position += 2;
		#else
		ensureElem (position + 1, true);
		
		if (littleEndian) {
			
			write_uncheck (value);
			write_uncheck (value >> 8);
			
		} else {
			
			write_uncheck (value >> 8);
			write_uncheck (value);
			
		}
		
		#end
		
	}
	
	
	public function writeUnsignedInt (value:Int):Void {
		
		#if js
		ensureWrite (this.position + 4);
		data.setUint32 (this.position, value, littleEndian);
		this.position += 4;
		#else
		writeInt (value);
		#end
		
	}
	
	
	public function writeUnsignedShort (value:Int):Void {
		
		#if js
		ensureWrite (this.position + 2);
		data.setUint16 (this.position, value, littleEndian);
		this.position += 2;
		#else
		writeShort (value);
		#end
		
	}
	
	
	public function writeUTF (value:String):Void {
		
		#if js
		writeUnsignedShort (__getUTFBytesCount (value));
		writeUTFBytes (value);
		#else
		#if neko
		var bytes = new Bytes (value.length, untyped value.__s);
		#else
		var bytes = Bytes.ofString (value);
		#end
		writeShort (bytes.length);
		writeBytes (bytes);
		#end
		
	}
	
	
	public function writeUTFBytes (value:String):Void {
		
		#if js
		// utf8-decode
		for (i in 0...value.length) {
			
			var c = StringTools.fastCodeAt (value, i);
			
			if (c <= 0x7F) {
				
				writeByte (c);
				
			} else if (c <= 0x7FF) {
				
				writeByte (0xC0 | (c >> 6));
				writeByte (0x80 | (c & 63));
				
			} else if (c <= 0xFFFF) {
				
				writeByte (0xE0 | (c >> 12));
				writeByte (0x80 | ((c >> 6) & 63));
				writeByte (0x80 | (c & 63));
				
			} else {
				
				writeByte (0xF0 | (c >> 18));
				writeByte (0x80 | ((c >> 12) & 63));
				writeByte (0x80 | ((c >> 6) & 63));
				writeByte (0x80 | (c & 63));
				
			}
			
		}
		#else
		#if neko
		var bytes = new Bytes (value.length, untyped value.__s);
		#else
		var bytes = Bytes.ofString (value);
		#end
		writeBytes (bytes);
		#end
		
	}
	
	
	private inline function __fromBytes (bytes:Bytes):Void {
		
		#if js
		byteView = untyped __new__("Uint8Array", bytes.getData ());
		data = untyped __new__("DataView", byteView.buffer);
		allocated = length;
		length = byteView.length;
		#else
		b = bytes.b;
		length = bytes.length;
		#if neko
		allocated = length;
		#end
		#end
		
	}
	
	
	#if ((cpp || neko || nodejs) && !macro)
	public static function __fromNativePointer (data:Dynamic, length:Int):ByteArray {
		
		var bytes:Dynamic = lime_bytes_from_data_pointer (data, length);
		return ByteArray.fromBytes (@:privateAccess new Bytes (bytes.length, bytes.b));
		
	}
	#end
	
	
	@:keep public inline function __get (pos:Int):Int {
		
		#if js
		return data.getInt8 (pos);
		#else
		// Neko/cpp pseudo array accessors...
		// No bounds checking is done in the cpp case
		#if cpp
		return untyped b[pos];
		#else
		return get (pos);
		#end
		#end
		
	}
	
	
	#if js
	public inline function __getBuffer () {
		
		return data.buffer;
		
	}
	#end
	
	
	#if ((cpp || neko || nodejs) && !macro)
	public function __getNativePointer ():Dynamic {
		
		return lime_bytes_get_data_pointer (this);
		
	}
	#end
	
	
	#if js
	private function __getUTFBytesCount (value:String):Int {
		
		var count:Int = 0;
		// utf8-decode
		
		for (i in 0...value.length) {
			
			var c = StringTools.fastCodeAt (value, i);
			
			if (c <= 0x7F) {
				
				count += 1;
				
			} else if (c <= 0x7FF) {
				
				count += 2;
				
			} else if (c <= 0xFFFF) {
				
				count += 3;
				
			} else {
				
				count += 4;
				
			}
			
		}
		
		return count;
		
	}
	#end
	
	
	#if js
	public static function __ofBuffer (buffer:ArrayBuffer):ByteArray {
		
		var bytes = new ByteArray ();
		#if !display
		bytes.length = (bytes:ByteArrayData).allocated = buffer.byteLength;
		(bytes:ByteArrayData).data = untyped __new__("DataView", buffer);
		(bytes:ByteArrayData).byteView = untyped __new__("Uint8Array", buffer);
		#end
		return bytes;
		
	}
	#end
	
	
	#if js
	private function ___resizeBuffer (len:Int):Void {
		
		var oldByteView:Uint8Array = this.byteView;
		var newByteView:Uint8Array = untyped __new__("Uint8Array", len);
		
		if (oldByteView != null) {
			
			if (oldByteView.length <= len) newByteView.set (oldByteView);
			else newByteView.set (oldByteView.subarray (0, len));
			
		}
		
		this.byteView = newByteView;
		this.data = untyped __new__("DataView", newByteView.buffer);
		
	}
	#end
	
	
	@:keep public inline function __set (pos:Int, v:Int):Void {
		
		#if js
		data.setUint8 (pos, v);
		#else
		// No bounds checking is done in the cpp case
		#if cpp
		untyped b[pos] = v;
		#else
		set (pos, v);
		#end
		#end
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	#if !js
	private inline function get_bigEndian ():Bool { return !littleEndian; }
	private inline function set_bigEndian (value:Bool):Bool { littleEndian = !value; return value; }
	#end
	
	
	private inline function get_bytesAvailable ():Int {
		
		return length - position;
		
	}
	
	
	#if !js
	private function get_byteLength ():Int {
		
		return length;
		
	}
	#end
	
	
	private inline function get_endian ():String {
		
		return littleEndian ? "littleEndian" : "bigEndian";
		
	}
	
	
	private inline function set_endian (endian:String):String {
		
		littleEndian = (endian == "littleEndian");
		return endian;
		
	}
	
	
	private inline function set_length (value:Int):Int {
		
		#if js
		if (allocated < value)
			___resizeBuffer (allocated = Std.int (Math.max (value, allocated * 2)));
		else if (allocated > value * 2)
			___resizeBuffer (allocated = value);
		length = value;
		#end
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	#if !macro
	@:cffi private static function lime_bytes_from_data_pointer (data:Float, length:Int):Dynamic;
	@:cffi private static function lime_bytes_get_data_pointer (data:Dynamic):Float;
	@:cffi private static function lime_bytes_read_file (path:String):Dynamic;
	#end
	
	
}


#else
typedef ByteArrayData = flash.utils.ByteArray;
#end
#else
typedef ByteArray = openfl._legacy.utils.ByteArray;
#end