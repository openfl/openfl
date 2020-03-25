namespace openfl.display3D
{
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
	export enum Context3DBlendFactor
	{
		/**
			The blend factor is (D<sub>a</sub>,D<sub>a</sub>,D<sub>a</sub>,D<sub>a</sub>),
			where D<sub>a</sub> is the alpha component of the fragment color computed by the
			pixel program.
		**/
		DESTINATION_ALPHA = "destinationAlpha",

		/**
			The blend factor is (D<sub>r</sub>,D<sub>g</sub>,D<sub>b</sub>,D<sub>a</sub>),
			where D<sub>r/g/b/a</sub> is the corresponding component of the current color
			in the color buffer.
		**/
		DESTINATION_COLOR = "destinationColor",

		/**
			The blend factor is (1,1,1,1).
		**/
		ONE = "one",

		/**
			The blend factor is (1-D<sub>a</sub>,1-D<sub>a</sub>,1-D<sub>a</sub>,1-D<sub>a</sub>),
			where D<sub>a</sub> is the alpha component of the current color in the color buffer.
		**/
		ONE_MINUS_DESTINATION_ALPHA = "oneMinusDestinationAlpha",

		/**
			The blend factor is (1-D<sub>r</sub>,1-D<sub>g</sub>,1-D<sub>b</sub>,1-D<sub>a</sub>),
			where D<sub>r/g/b/a</sub> is the corresponding component of the current color in
			the color buffer.
		**/
		ONE_MINUS_DESTINATION_COLOR = "oneMinusDestinationColor",

		/**
			The blend factor is (1-S<sub>a</sub>,1-S<sub>a</sub>,1-S<sub>a</sub>,1-S<sub>a</sub>),
			where S<sub>a</sub> is the alpha component of the fragment color computed by the
			pixel program.
		**/
		ONE_MINUS_SOURCE_ALPHA = "oneMinusSourceAlpha",

		/**
			The blend factor is (1-S<sub>r</sub>,1-S<sub>g</sub>,1-S<sub>b</sub>,1-S<sub>a</sub>),
			where S<sub>r/g/b/a</sub> is the corresponding component of the fragment color
			computed by the pixel program.
		**/
		ONE_MINUS_SOURCE_COLOR = "oneMinusSourceColor",

		/**
			The blend factor is (S<sub>a</sub>,S<sub>a</sub>,S<sub>a</sub>,S<sub>a</sub>),
			where S<sub>a</sub> is the alpha component of the fragment color computed by the
			pixel program.
		**/
		SOURCE_ALPHA = "sourceAlpha",

		/**
			The blend factor is (S<sub>r</sub>,S<sub>g</sub>,S<sub>b</sub>,S<sub>a</sub>),
			where S<sub>r/g/b/a</sub> is the corresponding component of the fragment color
			computed by the pixel program.
		**/
		SOURCE_COLOR = "sourceColor",

		/**
			The blend factor is (0,0,0,0).
		**/
		ZERO = "zero"
	}
}

export default openfl.display3D.Context3DBlendFactor;
