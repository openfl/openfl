package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for sampler filter mode.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DTextureFilter(Null<Int>)

{
	/**
		Use anisotropic filter with radio 16 when upsampling textures
	**/
	public var ANISOTROPIC16X = 0;

	/**
		Use anisotropic filter with radio 2 when upsampling textures
	**/
	public var ANISOTROPIC2X = 1;

	/**
		Use anisotropic filter with radio 4 when upsampling textures
	**/
	public var ANISOTROPIC4X = 2;

	/**
		Use anisotropic filter with radio 8 when upsampling textures
	**/
	public var ANISOTROPIC8X = 3;

	/**
		Use linear interpolation when upsampling textures (gives a smooth, blurry look).
	**/
	public var LINEAR = 4;

	/**
		Use nearest neighbor sampling when upsampling textures (gives a pixelated,
		sharp mosaic look).
	**/
	public var NEAREST = 5;

	@:from private static function fromString(value:String):Context3DTextureFilter
	{
		return switch (value)
		{
			case "anisotropic16x": ANISOTROPIC16X;
			case "anisotropic2x": ANISOTROPIC2X;
			case "anisotropic4x": ANISOTROPIC4X;
			case "anisotropic8x": ANISOTROPIC8X;
			case "linear": LINEAR;
			case "nearest": NEAREST;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DTextureFilter)
		{
			case Context3DTextureFilter.ANISOTROPIC16X: "anisotropic16x";
			case Context3DTextureFilter.ANISOTROPIC2X: "anisotropic2x";
			case Context3DTextureFilter.ANISOTROPIC4X: "anisotropic4x";
			case Context3DTextureFilter.ANISOTROPIC8X: "anisotropic8x";
			case Context3DTextureFilter.LINEAR: "linear";
			case Context3DTextureFilter.NEAREST: "nearest";
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DTextureFilter, b:Context3DTextureFilter):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DTextureFilter, b:Context3DTextureFilter):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract Context3DTextureFilter(String) from String to String

{
	public var ANISOTROPIC16X = "anisotropic16x";
	public var ANISOTROPIC2X = "anisotropic2x";
	public var ANISOTROPIC4X = "anisotropic4x";
	public var ANISOTROPIC8X = "anisotropic8x";
	public var LINEAR = "linear";
	public var NEAREST = "nearest";
}
#end
#else
typedef Context3DTextureFilter = flash.display3D.Context3DTextureFilter;
#end
