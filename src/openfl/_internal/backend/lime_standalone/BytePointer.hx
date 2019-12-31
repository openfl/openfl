package openfl._internal.backend.lime_standalone;

#if openfl_html5
import haxe.io.BytesData;
import haxe.io.Bytes;
#if haxe4
import js.lib.ArrayBuffer;
import js.lib.ArrayBufferView;
import js.lib.Uint8Array as UInt8Array;
import js.lib.Uint8ClampedArray as UInt8ClampedArray;
import js.lib.Int8Array;
import js.lib.Uint16Array as UInt16Array;
import js.lib.Int16Array;
import js.lib.Uint32Array as UInt32Array;
import js.lib.Int32Array;
import js.lib.Float32Array;
import js.lib.Float64Array;
#else
import js.html.ArrayBuffer;
import js.html.ArrayBufferView;
import js.html.Uint8Array as UInt8Array;
import js.html.Uint8ClampedArray as UInt8ClampedArray;
import js.html.Int8Array;
import js.html.Uint16Array as UInt16Array;
import js.html.Int16Array;
import js.html.Uint32Array as UInt32Array;
import js.html.Int32Array;
import js.html.Float32Array;
import js.html.Float64Array;
#end

@:access(haxe.io.Bytes)
@:access(openfl._internal.backend.lime_standalone.BytePointerData)
@:forward()
abstract BytePointer(BytePointerData) from BytePointerData to BytePointerData
{
	public inline function new(bytes:Bytes = null, offset:Int = 0):Void
	{
		this = new BytePointerData(bytes, offset);
	}

	public function set(?bytes:Bytes, ?bufferView:ArrayBufferView, ?buffer:ArrayBuffer, ?offset:Int):Void
	{
		if (buffer != null)
		{
			bytes = Bytes.ofData(cast buffer);
		}

		if (bytes != null || bufferView == null)
		{
			this.bytes = bytes;
			this.offset = offset != null ? offset : 0;
		}
		else
		{
			this.bytes = Bytes.ofData(cast bufferView.buffer);
			this.offset = offset != null ? bufferView.byteOffset + offset : bufferView.byteOffset;
		}
	}

	@:arrayAccess @:noCompletion private inline function __arrayGet(index:Int):Int
	{
		return (this.bytes != null) ? this.bytes.get(index + this.offset) : 0;
	}

	@:arrayAccess @:noCompletion private inline function __arraySet(index:Int, value:Int):Int
	{
		if (this.bytes == null) this.bytes.set(index + this.offset, value);
		return value;
	}

	@:from @:noCompletion public static function fromArrayBufferView(arrayBufferView:ArrayBufferView):BytePointer
	{
		if (arrayBufferView == null) return null;

		return new BytePointerData(Bytes.ofData(arrayBufferView.buffer), arrayBufferView.byteOffset);
	}

	@:from @:noCompletion public static function fromArrayBuffer(buffer:ArrayBuffer):BytePointer
	{
		if (buffer == null) return null;
		return new BytePointerData(Bytes.ofData(buffer), 0);
	}

	@:from @:noCompletion public static function fromBytes(bytes:Bytes):BytePointer
	{
		return new BytePointerData(bytes, 0);
	}

	@:from @:noCompletion public static function fromBytesData(bytesData:BytesData):BytePointer
	{
		if (bytesData == null) return new BytePointerData(null, 0);
		else
			return new BytePointerData(Bytes.ofData(bytesData), 0);
	}

	public static function fromFile(path:String):BytePointer
	{
		return new BytePointerData(LimeBytes.fromFile(path), 0);
	}

	@:from @:noCompletion public static function fromLimeBytes(bytes:LimeBytes):BytePointer
	{
		return new BytePointerData(bytes, 0);
	}

	@:to @:noCompletion public static function toUInt8Array(bytePointer:BytePointer):UInt8Array
	{
		return new UInt8Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 8));
	}

	@:to @:noCompletion public static function toUInt8ClampedArray(bytePointer:BytePointer):UInt8ClampedArray
	{
		if (bytePointer == null || bytePointer.bytes == null) return null;
		return new UInt8ClampedArray(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 8));
	}

	@:to @:noCompletion public static function toInt8Array(bytePointer:BytePointer):Int8Array
	{
		if (bytePointer == null || bytePointer.bytes == null) return null;
		return new Int8Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 8));
	}

	@:to @:noCompletion public static function toUInt16Array(bytePointer:BytePointer):UInt16Array
	{
		if (bytePointer == null || bytePointer.bytes == null) return null;
		return new UInt16Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 16));
	}

	@:to @:noCompletion public static function toInt16Array(bytePointer:BytePointer):Int16Array
	{
		if (bytePointer == null || bytePointer.bytes == null) return null;
		return new Int16Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 16));
	}

	@:to @:noCompletion public static function toUInt32Array(bytePointer:BytePointer):UInt32Array
	{
		if (bytePointer == null || bytePointer.bytes == null) return null;
		return new UInt32Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 32));
	}

	@:to @:noCompletion public static function toInt32Array(bytePointer:BytePointer):Int32Array
	{
		if (bytePointer == null || bytePointer.bytes == null) return null;
		return new Int32Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 32));
	}

	@:to @:noCompletion public static function toFloat32Array(bytePointer:BytePointer):Float32Array
	{
		if (bytePointer == null || bytePointer.bytes == null) return null;
		return new Float32Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 32));
	}

	@:to @:noCompletion public static function toFloat64Array(bytePointer:BytePointer):Float64Array
	{
		if (bytePointer == null || bytePointer.bytes == null) return null;
		return new Float64Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 64));
	}
}

@:noCompletion @:dox(hide) class BytePointerData
{
	public var bytes:Bytes;
	public var offset:Int;

	public function new(bytes:Bytes, offset:Int)
	{
		this.bytes = bytes;
		this.offset = offset;
	}
}
#end
