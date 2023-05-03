package openfl.display;

#if !flash

#if !openfljs
/**
	The InterpolationMethod class provides values for the
	`interpolationMethod` parameter in the
	`Graphics.beginGradientFill()` and
	`Graphics.lineGradientStyle()` methods. This parameter
	determines the RGB space to use when rendering the gradient.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract InterpolationMethod(Null<Int>)

{
	/**
		Specifies that the RGB interpolation method should be used. This means
		that the gradient is rendered with exponential sRGB(standard RGB) space.
		The sRGB space is a W3C-endorsed standard that defines a non-linear
		conversion between red, green, and blue component values and the actual
		intensity of the visible component color.

		For example, consider a simple linear gradient between two colors(with
		the `spreadMethod` parameter set to
		`SpreadMethod.REFLECT`). The different interpolation methods
		affect the appearance as follows:
	**/
	public var LINEAR_RGB = 0;

	/**
		Specifies that the RGB interpolation method should be used. This means
		that the gradient is rendered with exponential sRGB(standard RGB) space.
		The sRGB space is a W3C-endorsed standard that defines a non-linear
		conversion between red, green, and blue component values and the actual
		intensity of the visible component color.

		For example, consider a simple linear gradient between two colors(with
		the `spreadMethod` parameter set to
		`SpreadMethod.REFLECT`). The different interpolation methods
		affect the appearance as follows:
	**/
	public var RGB = 1;

	@:noCompletion private inline static function fromInt(value:Null<Int>):InterpolationMethod
	{
		return cast value;
	}

	@:from private static function fromString(value:String):InterpolationMethod
	{
		return switch (value)
		{
			case "linearRGB": LINEAR_RGB;
			case "rgb": RGB;
			default: null;
		}
	}

	@:noCompletion private inline function toInt():Null<Int>
	{
		return this;
	}

	@:to private function toString():String
	{
		return switch (cast this : InterpolationMethod)
		{
			case InterpolationMethod.LINEAR_RGB: "linearRGB";
			case InterpolationMethod.RGB: "rgb";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract InterpolationMethod(String) from String to String

{
	public var LINEAR_RGB = "linearRGB";
	public var RGB = "rgb";

	@:noCompletion private inline static function fromInt(value:Null<Int>):InterpolationMethod
	{
		return switch (value)
		{
			case 0: LINEAR_RGB;
			case 1: RGB;
			default: null;
		}
	}
}
#end
#else
typedef InterpolationMethod = flash.display.InterpolationMethod;
#end
