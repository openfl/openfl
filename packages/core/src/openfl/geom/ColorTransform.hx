package openfl.geom;

#if !flash
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
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ColorTransform
{
	/**
		A decimal value that is multiplied with the alpha transparency channel
		value.

		If you set the alpha transparency value of a display object directly by
		using the `alpha` property of the DisplayObject instance, it
		affects the value of the `alphaMultiplier` property of that
		display object's `transform.colorTransform` property.
	**/
	public var alphaMultiplier(get, set):Float;

	/**
		A number from -255 to 255 that is added to the alpha transparency channel
		value after it has been multiplied by the `alphaMultiplier`
		value.
	**/
	public var alphaOffset(get, set):Float;

	/**
		A decimal value that is multiplied with the blue channel value.
	**/
	public var blueMultiplier(get, set):Float;

	/**
		A number from -255 to 255 that is added to the blue channel value after it
		has been multiplied by the `blueMultiplier` value.
	**/
	public var blueOffset(get, set):Float;

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
	public var color(get, set):Int;

	/**
		A decimal value that is multiplied with the green channel value.
	**/
	public var greenMultiplier(get, set):Float;

	/**
		A number from -255 to 255 that is added to the green channel value after
		it has been multiplied by the `greenMultiplier` value.
	**/
	public var greenOffset(get, set):Float;

	/**
		A decimal value that is multiplied with the red channel value.
	**/
	public var redMultiplier(get, set):Float;

	/**
		A number from -255 to 255 that is added to the red channel value after it
		has been multiplied by the `redMultiplier` value.
	**/
	public var redOffset(get, set):Float;

	@:allow(openfl) @:noCompletion private var _:_ColorTransform;

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
	public function new(redMultiplier:Float = 1, greenMultiplier:Float = 1, blueMultiplier:Float = 1, alphaMultiplier:Float = 1, redOffset:Float = 0,
			greenOffset:Float = 0, blueOffset:Float = 0, alphaOffset:Float = 0):Void
	{
		if (_ == null)
		{
			_ = new _ColorTransform(this, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
		}
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
	public function concat(second:ColorTransform):Void
	{
		_.concat(second);
	}

	/**
		Formats and returns a string that describes all of the properties of
		the ColorTransform object.

		@return A string that lists all of the properties of the
				ColorTransform object.
	**/
	public function toString():String
	{
		return _.toString();
	}

	// Get & Set Methods

	@:noCompletion private function get_alphaMultiplier():Float
	{
		return _.alphaMultiplier;
	}

	@:noCompletion private function set_alphaMultiplier(value:Float):Float
	{
		return _.alphaMultiplier = value;
	}

	@:noCompletion private function get_alphaOffset():Float
	{
		return _.alphaOffset;
	}

	@:noCompletion private function set_alphaOffset(value:Float):Float
	{
		return _.alphaOffset = value;
	}

	@:noCompletion private function get_blueMultiplier():Float
	{
		return _.blueMultiplier;
	}

	@:noCompletion private function set_blueMultiplier(value:Float):Float
	{
		return _.blueMultiplier = value;
	}

	@:noCompletion private function get_blueOffset():Float
	{
		return _.blueOffset;
	}

	@:noCompletion private function set_blueOffset(value:Float):Float
	{
		return _.blueOffset = value;
	}

	@:noCompletion private function get_color():Int
	{
		return _.color;
	}

	@:noCompletion private function set_color(value:Int):Int
	{
		return _.color = value;
	}

	@:noCompletion private function get_greenMultiplier():Float
	{
		return _.greenMultiplier;
	}

	@:noCompletion private function set_greenMultiplier(value:Float):Float
	{
		return _.greenMultiplier = value;
	}

	@:noCompletion private function get_greenOffset():Float
	{
		return _.greenOffset;
	}

	@:noCompletion private function set_greenOffset(value:Float):Float
	{
		return _.greenOffset = value;
	}

	@:noCompletion private function get_redMultiplier():Float
	{
		return _.redMultiplier;
	}

	@:noCompletion private function set_redMultiplier(value:Float):Float
	{
		return _.redMultiplier = value;
	}

	@:noCompletion private function get_redOffset():Float
	{
		return _.redOffset;
	}

	@:noCompletion private function set_redOffset(value:Float):Float
	{
		return _.redOffset = value;
	}
}
#else
typedef ColorTransform = flash.geom.ColorTransform;
#end
