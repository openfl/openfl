package openfl;

import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Memory
{
	public static var __byteArray:ByteArray;
	public static var __length:Int;

	public static #if !debug inline #end function getByte(position:Int):Int
	{
		#if debug
		if (position < 0 || position + 1 > __length) throw("Bad address");
		#end

		return __byteArray[position];
	}

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

	public static function select(byteArray:ByteArray):Void
	{
		__byteArray = byteArray;
		__length = (byteArray != null) ? byteArray.length : 0;
	}

	public static #if !debug inline #end function setByte(position:Int, v:Int):Void
	{
		#if debug
		if (position < 0 || position + 1 > __length) throw("Bad address");
		#end

		__byteArray[position] = v;
	}

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

	public static function _setPositionTemporarily<T>(position:Int, action:Void->T):T
	{
		var oldPosition:Int = __byteArray.position;
		__byteArray.position = position;
		var value:T = action();
		__byteArray.position = oldPosition;

		return value;
	}
}
