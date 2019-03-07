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
	@:noCompletion private static var __byteArray:ByteArray;
	@:noCompletion private static var __length:Int;

	/**
		Get a byte from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	An 8-bit integer value
	**/
	public static #if !debug inline #end function getByte(position:Int):Int
	{
		#if debug
		if (position < 0 || position + 1 > __length) throw("Bad address");
		#end

		return __byteArray[position];
	}

	/**
		Get a double from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	A 64-bit floating point value
	**/
	public static #if !debug inline #end function getDouble(position:Int):Float
	{
		#if debug
		if (position < 0 || position + 8 > __length) throw("Bad address");
		#end

		return _setPositionTemporarily(position, function()
		{
			return __byteArray.readDouble();
		});
	}

	/**
		Get a float from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return	A 32-bit floating-point value
	**/
	public static #if !debug inline #end function getFloat(position:Int):Float
	{
		#if debug
		if (position < 0 || position + 4 > __length) throw("Bad address");
		#end

		return _setPositionTemporarily(position, function()
		{
			return __byteArray.readFloat();
		});
	}

	/**
		Get an int from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return A 32-bit integer value
	**/
	public static #if !debug inline #end function getI32(position:Int):Int
	{
		#if debug
		if (position < 0 || position + 4 > __length) throw("Bad address");
		#end

		return _setPositionTemporarily(position, function()
		{
			return __byteArray.readInt();
		});
	}

	/**
		Return an unsigned int from the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@return An unsigned 16-bit integer value
	**/
	public static #if !debug inline #end function getUI16(position:Int):Int
	{
		#if debug
		if (position < 0 || position + 2 > __length) throw("Bad address");
		#end

		return _setPositionTemporarily(position, function()
		{
			return __byteArray.readUnsignedShort();
		});
	}

	/**
		Selects the `ByteArray` to use for subsequent domain memory access
		@param	byteArray	A `ByteArray` object to use for memory
	**/
	public static function select(byteArray:ByteArray):Void
	{
		__byteArray = byteArray;
		__length = (byteArray != null) ? byteArray.length : 0;
	}

	/**
		Set a byte at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	An 8-bit byte value
	**/
	public static #if !debug inline #end function setByte(position:Int, v:Int):Void
	{
		#if debug
		if (position < 0 || position + 1 > __length) throw("Bad address");
		#end

		__byteArray[position] = v;
	}

	/**
		Set a double at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 64-bit floating-point value
	**/
	public static #if !debug inline #end function setDouble(position:Int, v:Float):Void
	{
		#if debug
		if (position < 0 || position + 8 > __length) throw("Bad address");
		#end

		_setPositionTemporarily(position, function()
		{
			__byteArray.writeDouble(v);
		});
	}

	/**
		Set a float at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 32-bit floating-point value
	**/
	public static #if !debug inline #end function setFloat(position:Int, v:Float):Void
	{
		#if debug
		if (position < 0 || position + 4 > __length) throw("Bad address");
		#end

		_setPositionTemporarily(position, function()
		{
			__byteArray.writeFloat(v);
		});
	}

	/**
		Set an int at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 16-bit integer value
	**/
	public static #if !debug inline #end function setI16(position:Int, v:Int):Void
	{
		#if debug
		if (position < 0 || position + 2 > __length) throw("Bad address");
		#end

		_setPositionTemporarily(position, function()
		{
			__byteArray.writeShort(v);
		});
	}

	/**
		Set a long int at the specified memory address
		@param	position	An existing address in the selected `ByteArray` memory
		@param	v	A 32-bit integer value
	**/
	public static #if !debug inline #end function setI32(position:Int, v:Int):Void
	{
		#if debug
		if (position < 0 || position + 4 > __length) throw("Bad address");
		#end

		_setPositionTemporarily(position, function()
		{
			__byteArray.writeInt(v);
		});
	}

	@:noCompletion private static function _setPositionTemporarily<T>(position:Int, action:Void->T):T
	{
		var oldPosition:Int = __byteArray.position;
		__byteArray.position = position;
		var value:T = action();
		__byteArray.position = oldPosition;

		return value;
	}
}
#else
typedef Memory = flash.Memory;
#end
