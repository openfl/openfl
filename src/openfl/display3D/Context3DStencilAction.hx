package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying stencil actions.

	A stencil action specifies how the values in the stencil buffer should be changed.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DStencilAction(Null<Int>)

{
	/**
		Decrement the stencil buffer value, clamping at 0, the minimum value.
	**/
	public var DECREMENT_SATURATE = 0;

	/**
		Decrement the stencil buffer value. If the result is less than 0, the minimum
		value, then the buffer value is "wrapped around" to 255.
	**/
	public var DECREMENT_WRAP = 1;

	/**
		Increment the stencil buffer value, clamping at 255, the maximum value.
	**/
	public var INCREMENT_SATURATE = 2;

	/**
		Increment the stencil buffer value. If the result exceeds 255, the maximum
		value, then the buffer value is "wrapped around" to 0.
	**/
	public var INCREMENT_WRAP = 3;

	/**
		Invert the stencil buffer value, bitwise.

		For example, if the 8-bit binary number in the stencil buffer is: 11110000, then
		the value is changed to: 00001111.
	**/
	public var INVERT = 4;

	/**
		Keep the current stencil buffer value.
	**/
	public var KEEP = 5;

	/**
		Replace the stencil buffer value with the reference value.
	**/
	public var SET = 6;

	/**
		Set the stencil buffer value to 0.
	**/
	public var ZERO = 7;

	@:from private static function fromString(value:String):Context3DStencilAction
	{
		return switch (value)
		{
			case "decrementSaturate": DECREMENT_SATURATE;
			case "decrementWrap": DECREMENT_WRAP;
			case "incrementSaturate": INCREMENT_SATURATE;
			case "incrementWrap": INCREMENT_WRAP;
			case "invert": INVERT;
			case "keep": KEEP;
			case "set": SET;
			case "zero": ZERO;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DStencilAction)
		{
			case Context3DStencilAction.DECREMENT_SATURATE: "decrementSaturate";
			case Context3DStencilAction.DECREMENT_WRAP: "decrementWrap";
			case Context3DStencilAction.INCREMENT_SATURATE: "incrementSaturate";
			case Context3DStencilAction.INCREMENT_WRAP: "incrementWrap";
			case Context3DStencilAction.INVERT: "invert";
			case Context3DStencilAction.KEEP: "keep";
			case Context3DStencilAction.SET: "set";
			case Context3DStencilAction.ZERO: "zero";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DStencilAction, b:Context3DStencilAction):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DStencilAction, b:Context3DStencilAction):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DStencilAction(String) from String to String

{
	public var DECREMENT_SATURATE = "decrementSaturate";
	public var DECREMENT_WRAP = "decrementWrap";
	public var INCREMENT_SATURATE = "incrementSaturate";
	public var INCREMENT_WRAP = "incrementWrap";
	public var INVERT = "invert";
	public var KEEP = "keep";
	public var SET = "set";
	public var ZERO = "zero";
}
#end
#else
typedef Context3DStencilAction = flash.display3D.Context3DStencilAction;
#end
