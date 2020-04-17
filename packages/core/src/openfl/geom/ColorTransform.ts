import ObjectPool from "../_internal/utils/ObjectPool";

/**
	The ColorTransform class lets you adjust the color values in a display
	object. The color adjustment or _color transformation_ can be applied
	to all four channels: red, green, blue, and alpha transparency.

	When a ColorTransform object is applied to a display object, a new value
	for each color channel is calculated like this:


	* New red value = (old red value * `redMultiplier`) +
	`redOffset`
	* New green value = (old green value * `greenMultiplier`) +
	`greenOffset`
	* New blue value = (old blue value * `blueMultiplier`) +
	`blueOffset`
	* New alpha value = (old alpha value * `alphaMultiplier`) +
	`alphaOffset`


	If any of the color channel values is greater than 255 after the
	calculation, it is set to 255. If it is less than 0, it is set to 0.

	You can use ColorTransform objects in the following ways:


	* In the `colorTransform` parameter of the
	`colorTransform()` method of the BitmapData class
	* As the `colorTransform` property of a Transform object
	(which can be used as the `transform` property of a display
	object)


	You must use the `new ColorTransform()` constructor to create
	a ColorTransform object before you can call the methods of the
	ColorTransform object.

	Color transformations do not apply to the background color of a movie
	clip(such as a loaded SWF object). They apply only to graphics and symbols
	that are attached to the movie clip.
**/
export default class ColorTransform
{
	protected static __limeColorMatrix: Float32Array;
	protected static __pool: ObjectPool<ColorTransform> = new ObjectPool<ColorTransform>(() => new ColorTransform(),
		(ct) => ct.__identity());

	/**
		A decimal value that is multiplied with the alpha transparency channel
		value.

		If you set the alpha transparency value of a display object directly by
		using the `alpha` property of the DisplayObject instance, it
		affects the value of the `alphaMultiplier` property of that
		display object's `transform.colorTransform` property.
	**/
	public alphaMultiplier: number;

	/**
		A number from -255 to 255 that is added to the alpha transparency channel
		value after it has been multiplied by the `alphaMultiplier`
		value.
	**/
	public alphaOffset: number;

	/**
		A decimal value that is multiplied with the blue channel value.
	**/
	public blueMultiplier: number;

	/**
		A number from -255 to 255 that is added to the blue channel value after it
		has been multiplied by the `blueMultiplier` value.
	**/
	public blueOffset: number;

	/**
		A decimal value that is multiplied with the green channel value.
	**/
	public greenMultiplier: number;

	/**
		A number from -255 to 255 that is added to the green channel value after
		it has been multiplied by the `greenMultiplier` value.
	**/
	public greenOffset: number;

	/**
		A decimal value that is multiplied with the red channel value.
	**/
	public redMultiplier: number;

	/**
		A number from -255 to 255 that is added to the red channel value after it
		has been multiplied by the `redMultiplier` value.
	**/
	public redOffset: number;

	/**
		Creates a ColorTransform object for a display object with the specified
		color channel values and alpha values.

		@param redMultiplier   The value for the red multiplier, in the range from
							   0 to 1.
		@param greenMultiplier The value for the green multiplier, in the range
							   from 0 to 1.
		@param blueMultiplier  The value for the blue multiplier, in the range
							   from 0 to 1.
		@param alphaMultiplier The value for the alpha transparency multiplier, in
							   the range from 0 to 1.
		@param redOffset       The offset value for the red color channel, in the
							   range from -255 to 255.
		@param greenOffset     The offset value for the green color channel, in
							   the range from -255 to 255.
		@param blueOffset      The offset for the blue color channel value, in the
							   range from -255 to 255.
		@param alphaOffset     The offset for alpha transparency channel value, in
							   the range from -255 to 255.
	**/
	public constructor(redMultiplier: number = 1, greenMultiplier: number = 1, blueMultiplier: number = 1, alphaMultiplier: number = 1, redOffset: number = 0,
		greenOffset: number = 0, blueOffset: number = 0, alphaOffset: number = 0)
	{
		this.redMultiplier = redMultiplier;
		this.greenMultiplier = greenMultiplier;
		this.blueMultiplier = blueMultiplier;
		this.alphaMultiplier = alphaMultiplier;
		this.redOffset = redOffset;
		this.greenOffset = greenOffset;
		this.blueOffset = blueOffset;
		this.alphaOffset = alphaOffset;
	}

	/**
		Concatenates the ColorTranform object specified by the `second`
		parameter with the current ColorTransform object and sets the current
		object as the result, which is an additive combination of the two color
		transformations. When you apply the concatenated ColorTransform object,
		the effect is the same as applying the `second` color
		transformation after the _original_ color transformation.

		@param second The ColorTransform object to be combined with the current
					  ColorTransform object.
	**/
	public concat(second: ColorTransform): void
	{
		this.redOffset = second.redOffset * this.redMultiplier + this.redOffset;
		this.greenOffset = second.greenOffset * this.greenMultiplier + this.greenOffset;
		this.blueOffset = second.blueOffset * this.blueMultiplier + this.blueOffset;
		this.alphaOffset = second.alphaOffset * this.alphaMultiplier + this.alphaOffset;

		this.redMultiplier *= second.redMultiplier;
		this.greenMultiplier *= second.greenMultiplier;
		this.blueMultiplier *= second.blueMultiplier;
		this.alphaMultiplier *= second.alphaMultiplier;
	}

	/**
		Formats and returns a string that describes all of the properties of
		the ColorTransform object.

		@return A string that lists all of the properties of the
				ColorTransform object.
	**/
	public toString(): string
	{
		return `(redMultiplier=${this.redMultiplier}, greenMultiplier=${this.greenMultiplier}, blueMultiplier=${this.blueMultiplier}, alphaMultiplier=${this.alphaMultiplier}, redOffset=${this.redOffset}, greenOffset=${this.greenOffset}, blueOffset=${this.blueOffset}, alphaOffset=${this.alphaOffset})`;
	}

	protected __clone(): ColorTransform
	{
		return new ColorTransform(this.redMultiplier, this.greenMultiplier, this.blueMultiplier, this.alphaMultiplier, this.redOffset, this.greenOffset, this.blueOffset, this.alphaOffset);
	}

	protected __copyFrom(ct: ColorTransform): void
	{
		this.redMultiplier = ct.redMultiplier;
		this.greenMultiplier = ct.greenMultiplier;
		this.blueMultiplier = ct.blueMultiplier;
		this.alphaMultiplier = ct.alphaMultiplier;

		this.redOffset = ct.redOffset;
		this.greenOffset = ct.greenOffset;
		this.blueOffset = ct.blueOffset;
		this.alphaOffset = ct.alphaOffset;
	}

	protected __combine(ct: ColorTransform): void
	{
		this.redMultiplier *= ct.redMultiplier;
		this.greenMultiplier *= ct.greenMultiplier;
		this.blueMultiplier *= ct.blueMultiplier;
		this.alphaMultiplier *= ct.alphaMultiplier;

		this.redOffset += ct.redOffset;
		this.greenOffset += ct.greenOffset;
		this.blueOffset += ct.blueOffset;
		this.alphaOffset += ct.alphaOffset;
	}

	protected __identity(): void
	{
		this.redMultiplier = 1;
		this.greenMultiplier = 1;
		this.blueMultiplier = 1;
		this.alphaMultiplier = 1;
		this.redOffset = 0;
		this.greenOffset = 0;
		this.blueOffset = 0;
		this.alphaOffset = 0;
	}

	protected __invert(): void
	{
		this.redMultiplier = this.redMultiplier != 0 ? 1 / this.redMultiplier : 1;
		this.greenMultiplier = this.greenMultiplier != 0 ? 1 / this.greenMultiplier : 1;
		this.blueMultiplier = this.blueMultiplier != 0 ? 1 / this.blueMultiplier : 1;
		this.alphaMultiplier = this.alphaMultiplier != 0 ? 1 / this.alphaMultiplier : 1;
		this.redOffset = -this.redOffset;
		this.greenOffset = -this.greenOffset;
		this.blueOffset = -this.blueOffset;
		this.alphaOffset = -this.alphaOffset;
	}

	protected __equals(ct: ColorTransform, ignoreAlphaMultiplier: boolean): boolean
	{
		return (ct != null
			&& this.redMultiplier == ct.redMultiplier
			&& this.greenMultiplier == ct.greenMultiplier
			&& this.blueMultiplier == ct.blueMultiplier
			&& (ignoreAlphaMultiplier || this.alphaMultiplier == ct.alphaMultiplier)
			&& this.redOffset == ct.redOffset
			&& this.greenOffset == ct.greenOffset
			&& this.blueOffset == ct.blueOffset
			&& this.alphaOffset == ct.alphaOffset);
	}

	protected __isDefault(ignoreAlphaMultiplier: boolean): boolean
	{
		if (ignoreAlphaMultiplier)
		{
			return (this.redMultiplier == 1
				&& this.greenMultiplier == 1
				&& this.blueMultiplier == 1
				&& /*alphaMultiplier == 1 &&*/ this.redOffset == 0
				&& this.greenOffset == 0
				&& this.blueOffset == 0
				&& this.alphaOffset == 0);
		}
		else
		{
			return (this.redMultiplier == 1 && this.greenMultiplier == 1 && this.blueMultiplier == 1 && this.alphaMultiplier == 1 && this.redOffset == 0 && this.greenOffset == 0
				&& this.blueOffset == 0 && this.alphaOffset == 0);
		}
	}

	protected __setArrays(colorMultipliers: Array<number>, colorOffsets: Array<number>): void
	{
		colorMultipliers[0] = this.redMultiplier;
		colorMultipliers[1] = this.greenMultiplier;
		colorMultipliers[2] = this.blueMultiplier;
		colorMultipliers[3] = this.alphaMultiplier;
		colorOffsets[0] = this.redOffset;
		colorOffsets[1] = this.greenOffset;
		colorOffsets[2] = this.blueOffset;
		colorOffsets[3] = this.alphaOffset;
	}

	protected __toLimeColorMatrix(): Float32Array
	{
		if (ColorTransform.__limeColorMatrix == null)
		{
			ColorTransform.__limeColorMatrix = new Float32Array(20);
		}

		ColorTransform.__limeColorMatrix[0] = this.redMultiplier;
		ColorTransform.__limeColorMatrix[4] = this.redOffset / 255;
		ColorTransform.__limeColorMatrix[6] = this.greenMultiplier;
		ColorTransform.__limeColorMatrix[9] = this.greenOffset / 255;
		ColorTransform.__limeColorMatrix[12] = this.blueMultiplier;
		ColorTransform.__limeColorMatrix[14] = this.blueOffset / 255;
		ColorTransform.__limeColorMatrix[18] = this.alphaMultiplier;
		ColorTransform.__limeColorMatrix[19] = this.alphaOffset / 255;

		return ColorTransform.__limeColorMatrix;
	}

	// Getters & Setters

	/**
		The RGB color value for a ColorTransform object.

		When you set this property, it changes the three color offset values
		(`redOffset`, `greenOffset`, and
		`blueOffset`) accordingly, and it sets the three color
		multiplier values(`redMultiplier`,
		`greenMultiplier`, and `blueMultiplier`) to 0. The
		alpha transparency multiplier and offset values do not change.

		When you pass a value for this property, use the format
		0x_RRGGBB_. _RR_, _GG_, and _BB_ each consist of two
		hexadecimal digits that specify the offset of each color component. The 0x
		tells the ActionScript compiler that the number is a hexadecimal
		value.
	**/
	public get color(): number
	{
		return ((Math.round(this.redOffset) << 16) | (Math.round(this.greenOffset) << 8) | Math.round(this.blueOffset));
	}

	public set color(value: number)
	{
		this.redOffset = (value >> 16) & 0xFF;
		this.greenOffset = (value >> 8) & 0xFF;
		this.blueOffset = value & 0xFF;

		this.redMultiplier = 0;
		this.greenMultiplier = 0;
		this.blueMultiplier = 0;
	}
}
