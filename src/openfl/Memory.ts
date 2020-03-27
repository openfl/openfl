import ByteArray from "./utils/ByteArray";

/**
	Adobe Flash Player supports an accelerated method of reading and
	writing to the `ByteArray` object, known as "domain memory"

	The Memory API provides access to domain memory using `Memory.select`
	on an existing `ByteArray` on the Flash target, and falls back to
	standard access on other targets.
**/
export default class Memory
{
	protected static __byteArray: ByteArray;
	protected static __length: number;

	/**
		Get a byte from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	An 8-bit integer value
	**/
	public static getByte(position: number): number
	{
		return Memory.__byteArray[position];
	}

	/**
		Get a double from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	A 64-bit floating point value
	**/
	public static getDouble(position: number): number
	{
		return Memory._setPositionTemporarily(position, () =>
		{
			return Memory.__byteArray.readDouble();
		});
	}

	/**
		Get a float from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	A 32-bit floating-point value
	**/
	public static getFloat(position: number): number
	{
		return Memory._setPositionTemporarily(position, () =>
		{
			return Memory.__byteArray.readFloat();
		});
	}

	/**
		Get an int from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return A 32-bit integer value
	**/
	public static getI32(position: number): number
	{
		return Memory._setPositionTemporarily(position, () =>
		{
			return Memory.__byteArray.readInt();
		});
	}

	/**
		Return an unsigned int from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return An unsigned 16-bit integer value
	**/
	public static getUI16(position: number): number
	{
		return Memory._setPositionTemporarily(position, () =>
		{
			return Memory.__byteArray.readUnsignedShort();
		});
	}

	/**
		Selects the `ByteArray` to use for subsequent domain memory access
		@param	byteArray	A `ByteArray` object to use for memory
	**/
	public static select(byteArray: ByteArray): void
	{
		Memory.__byteArray = byteArray;
		Memory.__length = (byteArray != null) ? byteArray.length : 0;
	}

	/**
		Set a byte at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	An 8-bit byte value
	**/
	public static setByte(position: number, v: number): void
	{
		Memory.__byteArray[position] = v;
	}

	/**
		Set a double at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 64-bit floating-point value
	**/
	public static setDouble(position: number, v: number): void
	{
		Memory._setPositionTemporarily(position, () =>
		{
			Memory.__byteArray.writeDouble(v);
		});
	}

	/**
		Set a float at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 32-bit floating-point value
	**/
	public static setFloat(position: number, v: number): void
	{
		Memory._setPositionTemporarily(position, () =>
		{
			Memory.__byteArray.writeFloat(v);
		});
	}

	/**
		Set an int at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 16-bit integer value
	**/
	public static setI16(position: number, v: number): void
	{
		Memory._setPositionTemporarily(position, () =>
		{
			Memory.__byteArray.writeShort(v);
		});
	}

	/**
		Set a long int at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 32-bit integer value
	**/
	public static setI32(position: number, v: number): void
	{
		Memory._setPositionTemporarily(position, () =>
		{
			Memory.__byteArray.writeInt(v);
		});
	}

	private static _setPositionTemporarily<T>(position: number, action: () => T): T
	{
		var oldPosition: number = Memory.__byteArray.position;
		Memory.__byteArray.position = position;
		var value: T = action();
		Memory.__byteArray.position = oldPosition;

		return value;
	}
}
