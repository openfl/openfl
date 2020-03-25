namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
import haxe.io.BytesData;
import haxe.io.Bytes;
import openfl._internal.bindings.typedarray.ArrayBuffer;
import openfl._internal.bindings.typedarray.ArrayBufferView;

@: access(haxe.io.Bytes)
abstract DataPointer(DataPointerType) to DataPointerType
{
	protected new (data: DataPointerType)
	{
		this = data;
	}

	@: from protected static fromFloat(value : number): DataPointer
	{
		return cast value;
	}

	@: from /** @hidden */ public static fromBytesPointer(pointer: BytePointer): DataPointer
	{
		return 0;
	}

	@: from /** @hidden */ public static fromArrayBufferView(arrayBufferView: ArrayBufferView): DataPointer
	{
		return 0;
	}

	@: from /** @hidden */ public static fromArrayBuffer(buffer: ArrayBuffer): DataPointer
	{
		return 0;
	}

	@: from /** @hidden */ public static fromBytes(bytes: Bytes): DataPointer
	{
		return 0;
	}

	@: from /** @hidden */ public static fromBytesData(bytesData: BytesData): DataPointer
	{
		return 0;
	}

	// @:from /** @hidden */ public static fromLimeBytes(bytes:LimeBytes):DataPointer
	// {
	// 	return fromBytes(bytes);
	// }

	public static fromFile(path: string): DataPointer
	{
		return 0;
	}

	private static __withOffset(data: DataPointer, offset : number): DataPointer
	{
		return 0;
	}

	/** @hidden */ @: op(A == B) private static readonly equals(a: DataPointer, b : number) : boolean
	{
		return (a: number) == b;
	}

	/** @hidden */ @: op(A == B) private static readonly equalsPointer(a: DataPointer, b: DataPointer) : boolean
	{
		return (a: number) == (b  : number);
	}

	/** @hidden */ @: op(A > B) private static readonly greaterThan(a: DataPointer, b : number) : boolean
	{
		return (a: number) > b;
	}

	// /** @hidden */ @:op(A > B) private static readonly greaterThanPointer(a:DataPointer, b:CFFIPointer):Bool
	// {
	// 	return (a  : number) > b;
	// }

	/** @hidden */ @: op(A >= B) private static readonly greaterThanOrEqual(a: DataPointer, b : number) : boolean
	{
		return (a: number) >= b;
	}

	// /** @hidden */ @:op(A >= B) private static readonly greaterThanOrEqualPointer(a:DataPointer, b:CFFIPointer):Bool
	// {
	// 	return (a  : number) >= b;
	// }

	/** @hidden */ @: op(A < B) private static readonly lessThan(a: DataPointer, b : number) : boolean
	{
		return (a: number) <b;
	}

	// /** @hidden */ @:op(A < B) private static readonly lessThanPointer(a:DataPointer, b:CFFIPointer):Bool
	// {
	// 	return (a  : number) < b;
	// }

	/** @hidden */ @: op(A <= B) private static readonly lessThanOrEqual(a: DataPointer, b : number) : boolean
	{
		return (a: number) <= b;
	}

	// /** @hidden */ @:op(A <= B) private static readonly lessThanOrEqualPointer(a:DataPointer, b:CFFIPointer):Bool
	// {
	// 	return (a  : number) <= b;
	// }

	/** @hidden */ @: op(A != B) private static readonly notEquals(a: DataPointer, b : number) : boolean
	{
		return (a: number) != b;
	}

	/** @hidden */ @: op(A != B) private static readonly notEqualsPointer(a: DataPointer, b: DataPointer) : boolean
	{
		return (a: number) != (b  : number);
	}

	/** @hidden */ @: op(A + B) private static readonly plus(a: DataPointer, b : number): DataPointer
	{
		return __withOffset(a, b);
	}

	/** @hidden */ @: op(A + B) private static readonly plusPointer(a: DataPointer, b: DataPointer): DataPointer
	{
		return __withOffset(a, Std.int((b: number)));
	}

	/** @hidden */ @: op(A - B) private static readonly minus(a: DataPointer, b : number): DataPointer
	{
		return __withOffset(a, -b);
	}

	/** @hidden */ @: op(A - B) private static readonly minusPointer(a: DataPointer, b: DataPointer): DataPointer
	{
		return __withOffset(a, -Std.int((b: number)));
	}
}

private typedef DataPointerType = Int;
#end
