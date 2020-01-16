package openfl._internal.backend.dummy;

import openfl.net.Socket;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

class DummySocketBackend
{
	public function new(parent:Socket) {}

	public function close():Void {}

	public function connect(host:String = null, port:Int = 0):Void {}

	public function flush():Void {}

	public function getBytesAvailable():Int
	{
		return input.bytesAvailable;
	}

	public function getBytesPending():Int
	{
		return output.length;
	}

	public function getEndian():Endian
	{
		return endian;
	}

	public function readBoolean():Bool
	{
		return false;
	}

	public function readByte():Int
	{
		return 0;
	}

	public function readBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void {}

	public function readDouble():Float
	{
		return 0;
	}

	public function readFloat():Float
	{
		return 0;
	}

	public function readInt():Int
	{
		return 0;
	}

	public function readMultiByte(length:Int, charSet:String):String
	{
		return null;
	}

	public function readShort():Int
	{
		return 0;
	}

	public function readUnsignedByte():Int
	{
		return 0;
	}

	public function readUnsignedInt():Int
	{
		return 0;
	}

	public function readUnsignedShort():Int
	{
		return 0;
	}

	public function readUTF():String
	{
		return null;
	}

	public function readUTFBytes(length:Int):String
	{
		return null;
	}

	public function setEndian(value:Endian):Endian
	{
		endian = value;

		if (input != null) input.endian = value;
		if (output != null) output.endian = value;

		return endian;
	}

	public function writeBoolean(value:Bool):Void {}

	public function writeByte(value:Int):Void {}

	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void {}

	public function writeDouble(value:Float):Void {}

	public function writeFloat(value:Float):Void {}

	public function writeInt(value:Int):Void {}

	public function writeMultiByte(value:String, charSet:String):Void {}

	public function writeShort(value:Int):Void {}

	public function writeUnsignedInt(value:Int):Void {}

	public function writeUTF(value:String):Void {}

	public function writeUTFBytes(value:String):Void {}
}
