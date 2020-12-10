package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for sampler wrap mode
**/
@:enum abstract Context3DWrapMode(Null<Int>)
{
	/**
		Clamp texture coordinates outside the 0..1 range.

		The function is x = max(min(x,0),1)
	**/
	public var CLAMP = 0;

	/**
		Clamp in U axis but Repeat in V axis.
	**/
	public var CLAMP_U_REPEAT_V = 1;

	/**
		Repeat (tile) texture coordinates outside the 0..1 range.

		The function is x = x<0?1.0-frac(abs(x)):frac(x)
	**/
	public var REPEAT = 2;

	/**
		Repeat in U axis but Clamp in V axis.
	**/
	public var REPEAT_U_CLAMP_V = 3;

	@:from private static function fromString(value:String):Context3DWrapMode
	{
		return switch (value)
		{
			case "clamp": CLAMP;
			case "clamp_u_repeat_v": CLAMP_U_REPEAT_V;
			case "repeat": REPEAT;
			case "repeat_u_clamp_v": REPEAT_U_CLAMP_V;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DWrapMode)
		{
			case Context3DWrapMode.CLAMP: "clamp";
			case Context3DWrapMode.CLAMP_U_REPEAT_V: "clamp_u_repeat_v";
			case Context3DWrapMode.REPEAT: "repeat";
			case Context3DWrapMode.REPEAT_U_CLAMP_V: "repeat_u_clamp_v";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DWrapMode, b:Context3DWrapMode):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DWrapMode, b:Context3DWrapMode):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DWrapMode(String) from String to String
{
	public var CLAMP = "clamp";
	public var CLAMP_U_REPEAT_V = "clamp_u_repeat_v";
	public var REPEAT = "repeat";
	public var REPEAT_U_CLAMP_V = "repeat_u_clamp_v";
}
#end
#else
typedef Context3DWrapMode = flash.display3D.Context3DWrapMode;
#end
