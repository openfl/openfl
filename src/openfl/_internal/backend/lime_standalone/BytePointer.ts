namespace openfl._internal.backend.lime_standalone;

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

@: access(haxe.io.Bytes)
@: access(openfl._internal.backend.lime_standalone.BytePointerData)
@: forward()
abstract BytePointer(BytePointerData) from BytePointerData to BytePointerData
{
	public inline new (bytes: Bytes = null, offset : number = 0): void
		{
			this = new BytePointerData(bytes, offset);
		}

	public set(?bytes: Bytes, ?bufferView: ArrayBufferView, ?buffer: ArrayBuffer, ?offset : number): void
		{
			if(buffer != null)
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

@: arrayAccess protected inline __arrayGet(index : number) : number
{
	return (this.bytes != null) ? this.bytes.get(index + this.offset) : 0;
}

@: arrayAccess protected inline __arraySet(index : number, value : number) : number
{
	if (this.bytes == null) this.bytes.set(index + this.offset, value);
	return value;
}

@: from /** @hidden */ public static fromArrayBufferView(arrayBufferView: ArrayBufferView): BytePointer
{
	if (arrayBufferView == null) return null;

	return new BytePointerData(Bytes.ofData(arrayBufferView.buffer), arrayBufferView.byteOffset);
}

@: from /** @hidden */ public static fromArrayBuffer(buffer: ArrayBuffer): BytePointer
{
	if (buffer == null) return null;
	return new BytePointerData(Bytes.ofData(buffer), 0);
}

@: from /** @hidden */ public static fromBytes(bytes: Bytes): BytePointer
{
	return new BytePointerData(bytes, 0);
}

@: from /** @hidden */ public static fromBytesData(bytesData: BytesData): BytePointer
{
	if (bytesData == null) return new BytePointerData(null, 0);
	else
		return new BytePointerData(Bytes.ofData(bytesData), 0);
}

	public static fromFile(path: string): BytePointer
{
	return new BytePointerData(LimeBytes.fromFile(path), 0);
}

@: from /** @hidden */ public static fromLimeBytes(bytes: LimeBytes): BytePointer
{
	return new BytePointerData(bytes, 0);
}

@: to /** @hidden */ public static toUInt8Array(bytePointer: BytePointer): number8Array
{
	return new UInt8Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 8));
}

@: to /** @hidden */ public static toUInt8ClampedArray(bytePointer: BytePointer): number8ClampedArray
{
	if (bytePointer == null || bytePointer.bytes == null) return null;
	return new UInt8ClampedArray(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 8));
}

@: to /** @hidden */ public static toInt8Array(bytePointer: BytePointer) : number8Array
{
	if (bytePointer == null || bytePointer.bytes == null) return null;
	return new Int8Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 8));
}

@: to /** @hidden */ public static toUInt16Array(bytePointer: BytePointer): number16Array
{
	if (bytePointer == null || bytePointer.bytes == null) return null;
	return new UInt16Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 16));
}

@: to /** @hidden */ public static toInt16Array(bytePointer: BytePointer) : number16Array
{
	if (bytePointer == null || bytePointer.bytes == null) return null;
	return new Int16Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 16));
}

@: to /** @hidden */ public static toUInt32Array(bytePointer: BytePointer): number32Array
{
	if (bytePointer == null || bytePointer.bytes == null) return null;
	return new UInt32Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 32));
}

@: to /** @hidden */ public static toInt32Array(bytePointer: BytePointer) : Float32Array
{
	if (bytePointer == null || bytePointer.bytes == null) return null;
	return new Int32Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 32));
}

@: to /** @hidden */ public static toFloat32Array(bytePointer: BytePointer) : Float32Array
{
	if (bytePointer == null || bytePointer.bytes == null) return null;
	return new Float32Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 32));
}

@: to /** @hidden */ public static toFloat64Array(bytePointer: BytePointer) : number64Array
{
	if (bytePointer == null || bytePointer.bytes == null) return null;
	return new Float64Array(bytePointer.bytes.getData(), Std.int(bytePointer.offset / 64));
}
}

/** @hidden */ class BytePointerData
{
	public bytes: Bytes;
	public offset: number;

	public new(bytes: Bytes, offset: number)
	{
		this.bytes = bytes;
		this.offset = offset;
	}
}
#end
