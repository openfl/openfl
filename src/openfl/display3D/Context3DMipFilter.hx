package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for sampler mipmap filter mode
**/
@:enum abstract Context3DMipFilter(Null<Int>)
{
	/**
		Select the two closest MIP levels and linearly blend between them (the highest
		quality mode, but has some performance cost).
	**/
	public var MIPLINEAR = 0;

	/**
		Use the nearest neighbor metric to select MIP levels (the fastest rendering method).
	**/
	public var MIPNEAREST = 1;

	/**
		Always use the top level texture (has a performance penalty when downscaling).
	**/
	public var MIPNONE = 2;

	@:from private static function fromString(value:String):Context3DMipFilter
	{
		return switch (value)
		{
			case "miplinear": MIPLINEAR;
			case "mipnearest": MIPNEAREST;
			case "mipnone": MIPNONE;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DMipFilter)
		{
			case Context3DMipFilter.MIPLINEAR: "miplinear";
			case Context3DMipFilter.MIPNEAREST: "mipnearest";
			case Context3DMipFilter.MIPNONE: "mipnone";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DMipFilter, b:Context3DMipFilter):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DMipFilter, b:Context3DMipFilter):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DMipFilter(String) from String to String
{
	public var MIPLINEAR = "miplinear";
	public var MIPNEAREST = "mipnearest";
	public var MIPNONE = "mipnone";
}
#end
#else
typedef Context3DMipFilter = flash.display3D.Context3DMipFilter;
#end
