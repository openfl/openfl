package openfl.utils._internal.format.amf3;

import haxe.io.Input;
import openfl.net.ObjectEncoding;
import openfl.utils._internal.format.amf.AMFReader as AMFReader;
import openfl.utils._internal.format.amf.AMFTools as AMFTools;
import openfl.utils._internal.format.amf.AMFWriter as AMFWriter;
import openfl.utils._internal.format.amf.AMFValue as AMFValue;
import openfl.utils._internal.format.amf3.AMF3Reader as AMF3Reader;
import openfl.utils._internal.format.amf3.AMF3Tools as AMF3Tools;
import openfl.utils._internal.format.amf3.AMF3Value as AMF3Value;
import openfl.utils._internal.format.amf3.AMF3Writer as AMF3Writer;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.IDataInput;

@:access(openfl.utils._internal.format.amf3.AMF3Reader)
class AMF3ReaderInput implements IDataInput
{
	#if !flash
	public var bytesAvailable(get, never):UInt;
	public var endian(get, set):Endian;
	public var objectEncoding:ObjectEncoding;
	#else
	#if (haxe_ver < 4.3)
	public var bytesAvailable(default, never):UInt;
	public var endian:Endian;
	public var objectEncoding:ObjectEncoding;
	#else
	@:flash.property public var bytesAvailable(get, never):UInt;
	@:flash.property public var endian(get, set):Endian;
	@:flash.property public var objectEncoding(get, set):ObjectEncoding;
	#end
	#end
	private var i:Input;
	private var r:AMF3Reader;

	public function new(r:AMF3Reader)
	{
		this.i = r.i;
		this.r = r;

		#if flash
		endian = i.bigEndian ? BIG_ENDIAN : LITTLE_ENDIAN;
		#end

		objectEncoding = ObjectEncoding.AMF3;
	}

	public function readBoolean():Bool
	{
		return i.readByte() != 0;
	}

	public function readByte():Int
	{
		return i.readByte();
	}

	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void
	{
		i.readBytes(bytes, offset, length);
	}

	public function readDouble():Float
	{
		return i.readDouble();
	}

	public function readFloat():Float
	{
		return i.readFloat();
	}

	public function readInt():Int
	{
		return i.readInt32();
	}

	public function readMultiByte(length:UInt, charSet:String):String
	{
		return i.readString(length);
	}

	public function readObject():Dynamic
	{
		switch (objectEncoding)
		{
			case AMF0:
				var reader = new AMFReader(i);
				var data = AMFTools.unwrapValue(reader.read());
				return data;

			case AMF3:
				var reader = new AMF3Reader(i, r);
				var data = AMF3Tools.decode(reader.read());
				return data;

			default:
				return null;
		}
	}

	public function readShort():Int
	{
		return i.readInt16();
	}

	public function readUnsignedByte():Int
	{
		return i.readByte();
	}

	public function readUnsignedInt():Int
	{
		var ch1 = i.readByte();
		var ch2 = i.readByte();
		var ch3 = i.readByte();
		var ch4 = i.readByte();

		if (endian == LITTLE_ENDIAN)
		{
			return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
		}
		else
		{
			return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
		}
	}

	public function readUnsignedShort():Int
	{
		var ch1 = i.readByte();
		var ch2 = i.readByte();

		if (endian == LITTLE_ENDIAN)
		{
			return (ch2 << 8) + ch1;
		}
		else
		{
			return (ch1 << 8) | ch2;
		}
	}

	public function readUTF():String
	{
		var bytesCount = readUnsignedShort();
		return readUTFBytes(bytesCount);
	}

	public function readUTFBytes(length:Int):String
	{
		return i.readString(length);
	}

	private function get_bytesAvailable():UInt
	{
		return -1;
	}

	private function get_endian():Endian
	{
		return i.bigEndian ? Endian.BIG_ENDIAN : Endian.LITTLE_ENDIAN;
	}

	private function set_endian(value:Endian):Endian
	{
		return value;
	}

	#if flash
	private function get_objectEncoding():ObjectEncoding
	{
		return ObjectEncoding.AMF3;
	}

	private function set_objectEncoding(value:ObjectEncoding):ObjectEncoding
	{
		return value;
	}
	#end
}
