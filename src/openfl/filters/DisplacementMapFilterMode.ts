/**
	The DisplacementMapFilterMode class provides
	values for the mode property of the DisplacementMapFilter class.
**/
export enum DisplacementMapFilterMode
{
	/**
		Clamps the displacement value to the edge of the source image.
	**/
	CLAMP = "clamp",

	/**
		If the displacement value is outside the image, substitutes the values in
		the color and alpha properties.
	**/
	COLOR = "color",

	/**
		If the displacement value is out of range, ignores the displacement and
		uses the source pixel.
	**/
	IGNORE = "ignore",

	/**
		Wraps the displacement value to the other side of the source image.
	**/
	WRAP = "wrap"
}

export default DisplacementMapFilterMode;
