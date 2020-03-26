namespace openfl._internal.backend.lime_standalone;

import openfl._internal.bindings.typedarray.Float32Array;
import openfl._internal.bindings.typedarray.UInt8Array;

/**
	`ColorMatrix` is a 4x5 matrix containing color multiplication
	and offset values for tinting and other kinds of color
	manipulation. In addition to using the multiplier, offset and
	`color` properties, it can be edited directly as a `Float32Array`
**/
abstract ColorMatrix(Float32Array) from Float32Array to Float32Array
{
	private static __alphaTable: number8Array;
	private static __blueTable: number8Array;
	private static __greenTable: number8Array;
	private static __identity = [
		1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0
	];
	private static __redTable: number8Array;

	/**
		The current alpha multiplication value (default is 1.0)
	**/
	public alphaMultiplier(get, set) : number;

	/**
		The current alpha offset value (default is 0)
	**/
	public alphaOffset(get, set) : number;

	/**
		The current blue multiplication value (default is 1.0)
	**/
	public blueMultiplier(get, set) : number;

	/**
		The current blue offset value (default is 0)
	**/
	public blueOffset(get, set) : number;

	/**
		Gets or sets a color offset for tinting.

		This will change the red, green and blue multipliers
		to zero, and affect the red, green and blue offset
		values.
	**/
	public color(get, set) : number;

	/**
		The current green multiplication value (default is 1.0)
	**/
	public greenMultiplier(get, set) : number;

	/**
		The current green offset value (default is 0)
	**/
	public greenOffset(get, set) : number;

	/**
		The current red multiplication value (default is 1.0)
	**/
	public redMultiplier(get, set) : number;

	/**
		The current red offset value (default is 0)
	**/
	public redOffset(get, set) : number;

	/**
		Creates a new `ColorMatrix` instance
		@param	data	(Optional) Initial `Float32Array` data to use
	**/
	public new (data : Float32Array = null)
	{
		if (data != null && data.length == 20)
		{
			this = data;
		}
		else
		{
			this = new Float32Array(__identity);
		}
	}

	/**
		Creates a duplicate of the current `ColorMatrix` instance
		@return	A new `ColorMatrix` instance
	**/
	public clone(): ColorMatrix
	{
		return new ColorMatrix(new Float32Array(this));
	}

	/**
		Adds the color multipliers from a second `ColorMatrix` to the current one
		@param	second	The `ColorMatrix` to `concat` to the current one
	**/
	public concat(second: ColorMatrix): void
		{
			redMultiplier += second.redMultiplier;
			greenMultiplier += second.greenMultiplier;
			blueMultiplier += second.blueMultiplier;
			alphaMultiplier += second.alphaMultiplier;
		}

	/**
		Sets the current `ColorMatrix` values to the same as another one
		@param	other	The `ColorMatrix` to copy from
	**/
	public copyFrom(other: ColorMatrix): void
		{
			this.set(other);
		}

	/**
		Resets to default values
	**/
	public identity()
	{
		this[0] = 1;
		this[1] = 0;
		this[2] = 0;
		this[3] = 0;
		this[4] = 0;
		this[5] = 0;
		this[6] = 1;
		this[7] = 0;
		this[8] = 0;
		this[9] = 0;
		this[10] = 0;
		this[11] = 0;
		this[12] = 1;
		this[13] = 0;
		this[14] = 0;
		this[15] = 0;
		this[16] = 0;
		this[17] = 0;
		this[18] = 1;
		this[19] = 0;
	}

	/**
		Returns a reference to a `UInt8Array` table for transforming
		alpha values using the current matrix.

		The table is 256 values in length, and includes values based
		on the `alphaMultipler` and `alphaOffset` values of the matrix.

		The values are constrained within 0 and 255.

		For example:

		```haxe
		var colorMatrix = new ColorMatrix ();
		colorMatrix.alphaOffset = 12;

		var alphaTable = colorMatrix.getAlphaTable ();
		trace (alphaTable[0]); // 12
		trace (alphaTable[1]); // 13
		```
	**/
	public getAlphaTable(): number8Array
	{
		if (__alphaTable == null)
		{
			__alphaTable = new UInt8Array(256);
		}

		var value: number;
		__alphaTable[0] = 0;

		for (i in 1...256)
		{
			value = Math.floor(i * alphaMultiplier + alphaOffset);
			if (value > 0xFF) value = 0xFF;
			if (value < 0) value = 0;
			__alphaTable[i] = value;
		}

		return __alphaTable;
	}

	/**
		Returns a reference to a `UInt8Array` table for transforming
		blue values using the current matrix.

		The table is 256 values in length, and includes values based
		on the `blueMultiplier` and `blueOffset` values of the matrix.

		The values are constrained within 0 and 255.

		For example:

		```haxe
		var colorMatrix = new ColorMatrix ();
		colorMatrix.blueOffset = 16;

		var blueTable = colorMatrix.getBlueTable ();
		trace (blueTable[0]); // 16
		trace (blueTable[1]); // 17
		```
	**/
	public getBlueTable(): number8Array
	{
		if (__blueTable == null)
		{
			__blueTable = new UInt8Array(256);
		}

		var value: number;

		for (i in 0...256)
		{
			value = Math.floor(i * blueMultiplier + blueOffset);
			if (value > 0xFF) value = 0xFF;
			if (value < 0) value = 0;
			__blueTable[i] = value;
		}

		return __blueTable;
	}

	/**
		Returns a reference to a `UInt8Array` table for transforming
		green values using the current matrix.

		The table is 256 values in length, and includes values based
		on the `greenMultiplier` and `greenOffset` values of the matrix.

		The values are constrained within 0 and 255.

		For example:

		```haxe
		var colorMatrix = new ColorMatrix ();
		colorMatrix.greenOffset = 16;

		var greenTable = colorMatrix.getGreenTable ();
		trace (greenTable[0]); // 16
		trace (greenTable[1]); // 17
		```
	**/
	public getGreenTable(): number8Array
	{
		if (__greenTable == null)
		{
			__greenTable = new UInt8Array(256);
		}

		var value: number;

		for (i in 0...256)
		{
			value = Math.floor(i * greenMultiplier + greenOffset);
			if (value > 0xFF) value = 0xFF;
			if (value < 0) value = 0;
			__greenTable[i] = value;
		}

		return __greenTable;
	}

	/**
		Returns a reference to a `UInt8Array` table for transforming
		red values using the current matrix.

		The table is 256 values in length, and includes values based
		on the `redMultiplier` and `redOffset` values of the matrix.

		The values are constrained within 0 and 255.

		For example:

		```haxe
		var colorMatrix = new ColorMatrix ();
		colorMatrix.redOffset = 16;

		var redTable = colorMatrix.getRedTable ();
		trace (redTable[0]); // 16
		trace (redTable[1]); // 17
		```
	**/
	public getRedTable(): number8Array
	{
		if (__redTable == null)
		{
			__redTable = new UInt8Array(256);
		}

		var value: number;

		for (i in 0...256)
		{
			value = Math.floor(i * redMultiplier + redOffset);
			if (value > 0xFF) value = 0xFF;
			if (value < 0) value = 0;
			__redTable[i] = value;
		}

		return __redTable;
	}

	// Get & Set Methods
	protected inline get_alphaMultiplier() : number
	{
		return this[18];
	}

	protected inline set_alphaMultiplier(value : number) : number
	{
		return this[18] = value;
	}

	protected inline get_alphaOffset() : number
	{
		return this[19] * 255;
	}

	protected inline set_alphaOffset(value : number) : number
	{
		return this[19] = value / 255;
	}

	protected inline get_blueMultiplier() : number
	{
		return this[12];
	}

	protected inline set_blueMultiplier(value : number) : number
	{
		return this[12] = value;
	}

	protected inline get_blueOffset() : number
	{
		return this[14] * 255;
	}

	protected inline set_blueOffset(value : number) : number
	{
		return this[14] = value / 255;
	}

	protected get_color() : number
	{
		return ((Std.int(redOffset) << 16) | (Std.int(greenOffset) << 8) | Std.int(blueOffset));
	}

	protected set_color(value : number) : number
	{
		redOffset = (value >> 16) & 0xFF;
		greenOffset = (value >> 8) & 0xFF;
		blueOffset = value & 0xFF;

		redMultiplier = 0;
		greenMultiplier = 0;
		blueMultiplier = 0;

		return color;
	}

	protected inline get_greenMultiplier() : number
	{
		return this[6];
	}

	protected inline set_greenMultiplier(value : number) : number
	{
		return this[6] = value;
	}

	protected inline get_greenOffset() : number
	{
		return this[9] * 255;
	}

	protected inline set_greenOffset(value : number) : number
	{
		return this[9] = value / 255;
	}

	protected inline get_redMultiplier() : number
	{
		return this[0];
	}

	protected inline set_redMultiplier(value : number) : number
	{
		return this[0] = value;
	}

	protected inline get_redOffset() : number
	{
		return this[4] * 255;
	}

	protected inline set_redOffset(value : number) : number
	{
		return this[4] = value / 255;
	}

	/** @hidden */ @: arrayAccess public get(index : number) : number
	{
		return this[index];
	}

	/** @hidden */ @: arrayAccess public set(index : number, value : number) : number
	{
		return this[index] = value;
	}
}
