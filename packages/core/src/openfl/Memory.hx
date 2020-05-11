package openfl;

#if !flash
import openfl.utils.ByteArray;

/**
	Adobe Flash Player supports an accelerated method of reading and
	writing to the `ByteArray` object, known as "domain memory"

	The Memory API provides access to domain memory using `Memory.select`
	on an existing `ByteArray` on the Flash target, and falls back to
	standard access on other targets.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class Memory
{
	/**
		Get a byte from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	An 8-bit integer value
	**/
	public static #if !debug inline #end function getByte(position:Int):Int
	{
		return _Memory.getByte(position);
	}

	/**
		Get a double from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	A 64-bit floating point value
	**/
	public static #if !debug inline #end function getDouble(position:Int):Float
	{
		return _Memory.getDouble(position);
	}

	/**
		Get a float from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	A 32-bit floating-point value
	**/
	public static #if !debug inline #end function getFloat(position:Int):Float
	{
		return _Memory.getFloat(position);
	}

	/**
		Get an int from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return A 32-bit integer value
	**/
	public static #if !debug inline #end function getI32(position:Int):Int
	{
		return _Memory.getI32(position);
	}

	/**
		Return an unsigned int from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return An unsigned 16-bit integer value
	**/
	public static #if !debug inline #end function getUI16(position:Int):Int
	{
		return _Memory.getUI16(position);
	}

	/**
		Selects the `ByteArray` to use for subsequent domain memory access
		@param	byteArray	A `ByteArray` object to use for memory
	**/
	public static function select(byteArray:ByteArray):Void
	{
		_Memory.select(byteArray);
	}

	/**
		Set a byte at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	An 8-bit byte value
	**/
	public static #if !debug inline #end function setByte(position:Int, v:Int):Void
	{
		_Memory.setByte(position, v);
	}

	/**
		Set a double at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 64-bit floating-point value
	**/
	public static #if !debug inline #end function setDouble(position:Int, v:Float):Void
	{
		_Memory.setDouble(position, v);
	}

	/**
		Set a float at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 32-bit floating-point value
	**/
	public static #if !debug inline #end function setFloat(position:Int, v:Float):Void
	{
		_Memory.setFloat(position, v);
	}

	/**
		Set an int at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 16-bit integer value
	**/
	public static #if !debug inline #end function setI16(position:Int, v:Int):Void
	{
		_Memory.setI16(position, v);
	}

	/**
		Set a long int at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 32-bit integer value
	**/
	public static #if !debug inline #end function setI32(position:Int, v:Int):Void
	{
		_Memory.setI32(position, v);
	}
}
#else
typedef Memory = flash.Memory;
#end
