package openfl.filters;

#if !flash
/**
	The DisplacementMapFilterMode class provides
	values for the mode property of the DisplacementMapFilter class.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract DisplacementMapFilterMode(String) from String to String

{
	/**
		Clamps the displacement value to the edge of the source image.
	**/
	public var CLAMP = "clamp";

	/**
		If the displacement value is outside the image, substitutes the values in
		the color and alpha properties.
	**/
	public var COLOR = "color";

	/**
		If the displacement value is out of range, ignores the displacement and
		uses the source pixel.
	**/
	public var IGNORE = "ignore";

	/**
		Wraps the displacement value to the other side of the source image.
	**/
	public var WRAP = "wrap";
}
#else
typedef DisplacementMapFilterMode = flash.filters.DisplacementMapFilterMode;
#end
