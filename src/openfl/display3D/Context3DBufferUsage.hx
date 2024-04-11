package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying the buffer usage type.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DBufferUsage(Null<Int>)

{
	/**
		Indicates the buffer will be used for drawing and be updated frequently
	**/
	public var DYNAMIC_DRAW = 0;

	/**
		Indicates the buffer will be used for drawing and be updated once

		This type is the default value for buffers in `Stage3D`.
	**/
	public var STATIC_DRAW = 1;

	@:from private static function fromString(value:String):Context3DBufferUsage
	{
		return switch (value)
		{
			case "dynamicDraw": DYNAMIC_DRAW;
			case "staticDraw": STATIC_DRAW;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DBufferUsage)
		{
			case Context3DBufferUsage.DYNAMIC_DRAW: "dynamicDraw";
			case Context3DBufferUsage.STATIC_DRAW: "staticDraw";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DBufferUsage, b:Context3DBufferUsage):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DBufferUsage, b:Context3DBufferUsage):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DBufferUsage(String) from String to String

{
	public var DYNAMIC_DRAW = "dynamicDraw";
	public var STATIC_DRAW = "staticDraw";
}
#end
#else
typedef Context3DBufferUsage = flash.display3D.Context3DBufferUsage;
#end
