package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying vertex buffers.
**/
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DVertexBufferFormat(Null<Int>)
{
	public var BYTES_4 = 0;
	public var FLOAT_1 = 1;
	public var FLOAT_2 = 2;
	public var FLOAT_3 = 3;
	public var FLOAT_4 = 4;

	@:from private static function fromString(value:String):Context3DVertexBufferFormat
	{
		return switch (value)
		{
			case "bytes4": BYTES_4;
			case "float1": FLOAT_1;
			case "float2": FLOAT_2;
			case "float3": FLOAT_3;
			case "float4": FLOAT_4;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DVertexBufferFormat)
		{
			case Context3DVertexBufferFormat.BYTES_4: "bytes4";
			case Context3DVertexBufferFormat.FLOAT_1: "float1";
			case Context3DVertexBufferFormat.FLOAT_2: "float2";
			case Context3DVertexBufferFormat.FLOAT_3: "float3";
			case Context3DVertexBufferFormat.FLOAT_4: "float4";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DVertexBufferFormat, b:Context3DVertexBufferFormat):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DVertexBufferFormat, b:Context3DVertexBufferFormat):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DVertexBufferFormat(String) from String to String
{
	public var BYTES_4 = "bytes4";
	public var FLOAT_1 = "float1";
	public var FLOAT_2 = "float2";
	public var FLOAT_3 = "float3";
	public var FLOAT_4 = "float4";
}
#end
#else
typedef Context3DVertexBufferFormat = flash.display3D.Context3DVertexBufferFormat;
#end
