package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying the source and destination blend factors.

	A blend factor represents a particular four-value vector that is multiplied with the
	source or destination color in the blending formula. The blending formula is:

	```
	result = source * sourceFactor + destination * destinationFactor
	```

	In the formula, the source color is the output color of the pixel shader program.
	The destination color is the color that currently exists in the color buffer, as set
	by previous clear and draw operations.

	For example, if the source color is (.6, .6, .6, .4) and the source blend factor is
	`Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA`, then the source part of the blending
	equation is calculated as:

	```
	(.6, .6, .6, .4) * (1-0.4, 1-0.4, 1-0.4, 1-0.4) = (.36, .36, .36, .24)
	```

	The final calculation is clamped to the range [0,1].

	**Examples**

	The following examples demonstrate the blending math using
	`source color = (.6,.4,.2,.4)`, `destination color = (.8,.8,.8,.5)`, and various blend
	factors.

	| Purpose | Source factor | Destination factor | Blend formula | Result |
	| --- | --- | --- | --- | --- |
	| No blending | ONE | ZERO | (.6,.4,.2,.4) * ( 1, 1, 1, 1) + (.8,.8,.8,.5) * ( 0, 0, 0, 0) | ( .6, .4, .2, .4) |
	| Alpha | SOURCE_ALPHA | ONE_MINUS_SOURCE_ALPHA | (.6,.4,.2,.4) * (.4,.4,.4,.4) + (.8,.8,.8,.5) * (.6,.6,.6,.6) | (.72,.64,.56,.46) |
	| Additive | ONE | ONE | (.6,.4,.2,.4) * ( 1, 1, 1, 1) + (.8,.8,.8,.5) * ( 1, 1, 1, 1)	( 1, 1, 1, .9) |
	| Multiply | DESTINATION_COLOR | ZERO | (.6,.4,.2,.4) * (.8,.8,.8,.5) + (.8,.8,.8,.5) * ( 0, 0, 0, 0) | (.48,.32,.16, .2) |
	| Screen | ONE | ONE_MINUS_SOURCE_COLOR | (.6,.4,.2,.4) * ( 1, 1, 1, 1) + (.8,.8,.8,.5) * (.4,.6,.8,.6) | (.92,.88,.68, .7) |

	Note that not all combinations of blend factors are useful and that you can sometimes achieve the same effect in different ways.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DBlendFactor(Null<Int>)

{
	/**
		The blend factor is (D<sub>a</sub>,D<sub>a</sub>,D<sub>a</sub>,D<sub>a</sub>),
		where D<sub>a</sub> is the alpha component of the fragment color computed by the
		pixel program.
	**/
	public var DESTINATION_ALPHA = 0;

	/**
		The blend factor is (D<sub>r</sub>,D<sub>g</sub>,D<sub>b</sub>,D<sub>a</sub>),
		where D<sub>r/g/b/a</sub> is the corresponding component of the current color
		in the color buffer.
	**/
	public var DESTINATION_COLOR = 1;

	/**
		The blend factor is (1,1,1,1).
	**/
	public var ONE = 2;

	/**
		The blend factor is (1-D<sub>a</sub>,1-D<sub>a</sub>,1-D<sub>a</sub>,1-D<sub>a</sub>),
		where D<sub>a</sub> is the alpha component of the current color in the color buffer.
	**/
	public var ONE_MINUS_DESTINATION_ALPHA = 3;

	/**
		The blend factor is (1-D<sub>r</sub>,1-D<sub>g</sub>,1-D<sub>b</sub>,1-D<sub>a</sub>),
		where D<sub>r/g/b/a</sub> is the corresponding component of the current color in
		the color buffer.
	**/
	public var ONE_MINUS_DESTINATION_COLOR = 4;

	/**
		The blend factor is (1-S<sub>a</sub>,1-S<sub>a</sub>,1-S<sub>a</sub>,1-S<sub>a</sub>),
		where S<sub>a</sub> is the alpha component of the fragment color computed by the
		pixel program.
	**/
	public var ONE_MINUS_SOURCE_ALPHA = 5;

	/**
		The blend factor is (1-S<sub>r</sub>,1-S<sub>g</sub>,1-S<sub>b</sub>,1-S<sub>a</sub>),
		where S<sub>r/g/b/a</sub> is the corresponding component of the fragment color
		computed by the pixel program.
	**/
	public var ONE_MINUS_SOURCE_COLOR = 6;

	/**
		The blend factor is (S<sub>a</sub>,S<sub>a</sub>,S<sub>a</sub>,S<sub>a</sub>),
		where S<sub>a</sub> is the alpha component of the fragment color computed by the
		pixel program.
	**/
	public var SOURCE_ALPHA = 7;

	/**
		The blend factor is (S<sub>r</sub>,S<sub>g</sub>,S<sub>b</sub>,S<sub>a</sub>),
		where S<sub>r/g/b/a</sub> is the corresponding component of the fragment color
		computed by the pixel program.
	**/
	public var SOURCE_COLOR = 8;

	/**
		The blend factor is (0,0,0,0).
	**/
	public var ZERO = 9;

	@:from private static function fromString(value:String):Context3DBlendFactor
	{
		return switch (value)
		{
			case "destinationAlpha": DESTINATION_ALPHA;
			case "destinationColor": DESTINATION_COLOR;
			case "one": ONE;
			case "oneMinusDestinationAlpha": ONE_MINUS_DESTINATION_ALPHA;
			case "oneMinusDestinationColor": ONE_MINUS_DESTINATION_COLOR;
			case "oneMinusSourceAlpha": ONE_MINUS_SOURCE_ALPHA;
			case "oneMinusSourceColor": ONE_MINUS_SOURCE_COLOR;
			case "sourceAlpha": SOURCE_ALPHA;
			case "sourceColor": SOURCE_COLOR;
			case "zero": ZERO;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DBlendFactor)
		{
			case Context3DBlendFactor.DESTINATION_ALPHA: "destinationAlpha";
			case Context3DBlendFactor.DESTINATION_COLOR: "destinationColor";
			case Context3DBlendFactor.ONE: "one";
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA: "oneMinusDestinationAlpha";
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR: "oneMinusDestinationColor";
			case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA: "oneMinusSourceAlpha";
			case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR: "oneMinusSourceColor";
			case Context3DBlendFactor.SOURCE_ALPHA: "sourceAlpha";
			case Context3DBlendFactor.SOURCE_COLOR: "sourceColor";
			case Context3DBlendFactor.ZERO: "zero";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DBlendFactor, b:Context3DBlendFactor):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DBlendFactor, b:Context3DBlendFactor):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DBlendFactor(String) from String to String

{
	public var DESTINATION_ALPHA = "destinationAlpha";
	public var DESTINATION_COLOR = "destinationColor";
	public var ONE = "one";
	public var ONE_MINUS_DESTINATION_ALPHA = "oneMinusDestinationAlpha";
	public var ONE_MINUS_DESTINATION_COLOR = "oneMinusDestinationColor";
	public var ONE_MINUS_SOURCE_ALPHA = "oneMinusSourceAlpha";
	public var ONE_MINUS_SOURCE_COLOR = "oneMinusSourceColor";
	public var SOURCE_ALPHA = "sourceAlpha";
	public var SOURCE_COLOR = "sourceColor";
	public var ZERO = "zero";
}
#end
#else
typedef Context3DBlendFactor = flash.display3D.Context3DBlendFactor;
#end
