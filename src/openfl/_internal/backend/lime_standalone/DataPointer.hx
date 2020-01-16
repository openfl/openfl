package openfl._internal.backend.lime_standalone;

#if openfl_html5
import haxe.io.BytesData;
import haxe.io.Bytes;
import openfl._internal.bindings.typedarray.ArrayBuffer;
import openfl._internal.bindings.typedarray.ArrayBufferView;

@:access(haxe.io.Bytes)
abstract DataPointer(DataPointerType) to DataPointerType
{
	@:noCompletion private function new(data:DataPointerType)
	{
		this = data;
	}

	@:from @:noCompletion private static function fromFloat(value:Float):DataPointer
	{
		return cast value;
	}

	@:from @:noCompletion public static function fromBytesPointer(pointer:BytePointer):DataPointer
	{
		return 0;
	}

	@:from @:noCompletion public static function fromArrayBufferView(arrayBufferView:ArrayBufferView):DataPointer
	{
		return 0;
	}

	@:from @:noCompletion public static function fromArrayBuffer(buffer:ArrayBuffer):DataPointer
	{
		return 0;
	}

	@:from @:noCompletion public static function fromBytes(bytes:Bytes):DataPointer
	{
		return 0;
	}

	@:from @:noCompletion public static function fromBytesData(bytesData:BytesData):DataPointer
	{
		return 0;
	}

	// @:from @:noCompletion public static function fromLimeBytes(bytes:LimeBytes):DataPointer
	// {
	// 	return fromBytes(bytes);
	// }

	public static function fromFile(path:String):DataPointer
	{
		return 0;
	}

	private static function __withOffset(data:DataPointer, offset:Int):DataPointer
	{
		return 0;
	}

	@:noCompletion @:op(A == B) private static inline function equals(a:DataPointer, b:Int):Bool
	{
		return (a : Float) == b;
	}

	@:noCompletion @:op(A == B) private static inline function equalsPointer(a:DataPointer, b:DataPointer):Bool
	{
		return (a : Float) == (b : Float);
	}

	@:noCompletion @:op(A > B) private static inline function greaterThan(a:DataPointer, b:Int):Bool
	{
		return (a : Float) > b;
	}

	// @:noCompletion @:op(A > B) private static inline function greaterThanPointer(a:DataPointer, b:CFFIPointer):Bool
	// {
	// 	return (a : Float) > b;
	// }

	@:noCompletion @:op(A >= B) private static inline function greaterThanOrEqual(a:DataPointer, b:Int):Bool
	{
		return (a : Float) >= b;
	}

	// @:noCompletion @:op(A >= B) private static inline function greaterThanOrEqualPointer(a:DataPointer, b:CFFIPointer):Bool
	// {
	// 	return (a : Float) >= b;
	// }

	@:noCompletion @:op(A < B) private static inline function lessThan(a:DataPointer, b:Int):Bool
	{
		return (a : Float) < b;
	}

	// @:noCompletion @:op(A < B) private static inline function lessThanPointer(a:DataPointer, b:CFFIPointer):Bool
	// {
	// 	return (a : Float) < b;
	// }

	@:noCompletion @:op(A <= B) private static inline function lessThanOrEqual(a:DataPointer, b:Int):Bool
	{
		return (a : Float) <= b;
	}

	// @:noCompletion @:op(A <= B) private static inline function lessThanOrEqualPointer(a:DataPointer, b:CFFIPointer):Bool
	// {
	// 	return (a : Float) <= b;
	// }

	@:noCompletion @:op(A != B) private static inline function notEquals(a:DataPointer, b:Int):Bool
	{
		return (a : Float) != b;
	}

	@:noCompletion @:op(A != B) private static inline function notEqualsPointer(a:DataPointer, b:DataPointer):Bool
	{
		return (a : Float) != (b : Float);
	}

	@:noCompletion @:op(A + B) private static inline function plus(a:DataPointer, b:Int):DataPointer
	{
		return __withOffset(a, b);
	}

	@:noCompletion @:op(A + B) private static inline function plusPointer(a:DataPointer, b:DataPointer):DataPointer
	{
		return __withOffset(a, Std.int((b : Float)));
	}

	@:noCompletion @:op(A - B) private static inline function minus(a:DataPointer, b:Int):DataPointer
	{
		return __withOffset(a, -b);
	}

	@:noCompletion @:op(A - B) private static inline function minusPointer(a:DataPointer, b:DataPointer):DataPointer
	{
		return __withOffset(a, -Std.int((b : Float)));
	}
}

private typedef DataPointerType = Int;
#end
