package;

import haxe.Int64;
import openfl.net.ObjectEncoding;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.CompressionAlgorithm;
import utest.Assert;
import utest.Test;
#if lime
import lime.system.System;
#end

class ByteArrayTest extends Test
{
	// Is this right?
	private static var uncompressedValues = [100, 100, 100, 100];
	private static var compressedValues = [120, 156, 75, 73, 73, 73, 1, 0, 3, 236, 1, 145];

	#if !integration
	@Ignored
	#end
	public function test_compress():Void
	{
		var byteArray = new ByteArray();
		byteArray.endian = LITTLE_ENDIAN;

		for (value in uncompressedValues)
		{
			byteArray.writeByte(value);
		}

		byteArray.compress();

		// TODO: at least one assert is required
		// remove this if other asserts are enabled in the future
		Assert.pass();

		#if (!flash && integration)
		// byteArray.position = 0;
		// for (i in 0...byteArray.length) {
		// 	trace (byteArray.readUnsignedByte ());
		// }

		// Assert.equals(compressedValues.length, byteArray.length);
		// Assert.equals(byteArray.length, byteArray.position);

		// byteArray.position = 0;

		// for (value in compressedValues)
		// {
		// 	Assert.equals(value, byteArray.readUnsignedByte());
		// }
		#end
	}

	public function test_defaultEndian():Void
	{
		#if lime
		if (System.endianness == BIG_ENDIAN)
		{
			Assert.equals(Endian.BIG_ENDIAN, ByteArray.defaultEndian);
		}
		else
		{
			Assert.equals(Endian.LITTLE_ENDIAN, ByteArray.defaultEndian);
		}
		#end

		ByteArray.defaultEndian = BIG_ENDIAN;
		Assert.equals(Endian.BIG_ENDIAN, ByteArray.defaultEndian);
		#if !flash
		ByteArray.defaultEndian = LITTLE_ENDIAN;
		Assert.equals(Endian.LITTLE_ENDIAN, ByteArray.defaultEndian);
		#end
	}

	public function test_defaultObjectEncoding():Void
	{
		Assert.equals(ObjectEncoding.DEFAULT, ByteArray.defaultObjectEncoding);
		var byteArray = new ByteArray();
		Assert.equals(ObjectEncoding.DEFAULT, byteArray.objectEncoding);

		ByteArray.defaultObjectEncoding = AMF0;
		Assert.equals(ObjectEncoding.AMF0, ByteArray.defaultObjectEncoding);
		var byteArray = new ByteArray();
		Assert.equals(ObjectEncoding.AMF0, byteArray.objectEncoding);
	}

	#if !integration
	@Ignored
	#end
	public function test_uncompress():Void
	{
		var byteArray = new ByteArray();
		byteArray.endian = LITTLE_ENDIAN;

		for (value in compressedValues)
		{
			byteArray.writeByte(value);
		}

		byteArray.uncompress();

		#if integration
		Assert.equals(uncompressedValues.length, byteArray.length);
		Assert.equals(0, byteArray.position);

		for (value in uncompressedValues)
		{
			Assert.equals(value, byteArray.readUnsignedByte());
		}
		#end
	}

	public function test_testWritePos()
	{
		var ba:ByteArray = new ByteArray();

		ba.endian = Endian.LITTLE_ENDIAN;

		Assert.equals(0, ba.length);

		ba.writeByte(0xFF);
		Assert.equals(1, ba.length);
		Assert.equals(1, ba.position);

		#if (js || flash) // array access might not be possible :(
		ba.position = 0;
		Assert.equals(0xFF, ba.readUnsignedByte());
		#else
		Assert.equals(0xFF, ba[0]);
		#end

		ba.position = 0;
		Assert.equals(0, ba.position);
		ba.writeByte(0x7F);
		Assert.equals(1, ba.length);
		Assert.equals(1, ba.position);

		#if js
		ba.position = 0;
		Assert.equals(0x7F, ba.readUnsignedByte());
		#else
		Assert.equals(0x7F, ba[0]);
		#end

		ba.writeShort(0x1234);
		Assert.equals(3, ba.length);
		Assert.equals(3, ba.position);

		#if js
		ba.position = 1;
		Assert.equals(0x34, ba.readUnsignedByte());
		Assert.equals(0x12, ba.readUnsignedByte());
		#else
		Assert.equals(0x34, ba[1]);
		Assert.equals(0x12, ba[2]);
		#end

		ba.clear();
		Assert.equals(0, ba.length);

		ba.writeUTFBytes("TEST");
		Assert.equals(4, ba.length);
		Assert.equals(4, ba.position);

		ba.writeInt(0x12345678);
		Assert.equals(8, ba.length);
		Assert.equals(8, ba.position);

		ba.writeShort(0x1234);
		Assert.equals(10, ba.length);
		Assert.equals(10, ba.position);

		ba.position = 3;
		Assert.equals(10, ba.length);
		ba.writeShort(0x1234);
		Assert.equals(10, ba.length);
		Assert.equals(5, ba.position);
	}

	public function test_testReadWriteBoolean()
	{
		var data = new ByteArray();
		data.writeBoolean(true);
		data.position = 0;
		Assert.equals(true, data.readBoolean());
		data.writeBoolean(false);
		data.position = 1;
		Assert.equals(false, data.readBoolean());
	}

	public function test_testReadWriteByte()
	{
		var data = new ByteArray();
		data.writeByte(127);
		data.position = 0;
		Assert.equals(127, data.readByte());

		data.writeByte(34);
		data.position = 1;
		Assert.equals(34, data.readByte());

		Assert.equals(2, data.length);
	}

	public function test_testReadWriteBytes()
	{
		var input = new ByteArray();
		input.writeByte(118);
		input.writeByte(38);
		input.writeByte(67);
		input.writeByte(89);
		input.writeByte(19);
		input.writeByte(17);
		var data = new ByteArray();

		data.writeBytes(input, 0, 4);
		Assert.equals(4, data.length);

		data.position = 0;
		var output = new ByteArray();
		data.readBytes(output, 0, 2);

		Assert.equals(2, output.length);
		Assert.equals(118, output.readByte());
		Assert.equals(38, output.readByte());

		data.position = 2;
		data.writeBytes(input, 2, 4);
		Assert.equals(6, data.length);

		data.position = 4;
		data.readBytes(output, 2, 2);
		Assert.equals(4, output.length);
		output.position = 2;

		Assert.equals(19, output.readByte());
		Assert.equals(17, output.readByte());

		var data = new ByteArray();
		// data.writeBytes (input, 0, input.length * 2);
		data.writeBytes(input, 0, input.length); // docs say it should clamp to size?

		Assert.equals(input.length, data.length);
	}

	public function test_testReadWriteDouble()
	{
		var data = new ByteArray();
		data.writeDouble(Math.PI);
		data.position = 0;

		Assert.equals(Math.PI, data.readDouble());
		Assert.equals(8, data.position);

		data.position = 0;
		Assert.equals(Math.PI, data.readDouble());

		data.writeDouble(6);
		data.position = 8;

		Assert.equals(6., data.readDouble());

		data.writeDouble(3.121244489);
		data.position = 16;

		Assert.equals(3.121244489, data.readDouble());

		data.writeDouble(-0.000244489);
		data.position = 24;

		Assert.equals(-0.000244489, data.readDouble());

		data.writeDouble(-99.026771);
		data.position = 32;

		Assert.equals(-99.026771, data.readDouble());
	}

	public function test_testReadWriteFloat()
	{
		var data = new ByteArray();
		data.writeFloat(2);
		data.position = 0;

		Assert.equals(2., data.readFloat());
		Assert.equals(4, data.position);

		data.writeFloat(.18);
		data.position = 4;
		var actual = data.readFloat();
		Assert.isTrue(.179999 < actual);
		Assert.isTrue(.180001 > actual);

		data.writeFloat(3.452221);
		data.position = 8;
		var actual = data.readFloat();
		Assert.isTrue(3.452220 < actual);
		Assert.isTrue(3.452222 > actual);

		data.writeFloat(39.19442);
		data.position = 12;
		var actual = data.readFloat();
		Assert.isTrue(39.19441 < actual);
		Assert.isTrue(39.19443 > actual);

		data.writeFloat(.994423);
		data.position = 16;
		var actual = data.readFloat();
		Assert.isTrue(.994422 < actual);
		Assert.isTrue(.994424 > actual);

		data.writeFloat(-.434423);
		data.position = 20;
		var actual = data.readFloat();
		Assert.isTrue(-.434421 > actual);
		Assert.isTrue(-.434424 < actual);
	}

	public function test_testReadWriteInt()
	{
		var data = new ByteArray();
		data.writeInt(0xFFCC);
		Assert.equals(4, data.length);
		data.position = 0;

		Assert.equals(0xFFCC, data.readInt());
		Assert.equals(4, data.position);

		data.writeInt(0xFFCC99);
		Assert.equals(8, data.length);
		data.position = 4;

		Assert.equals(0xFFCC99, data.readInt());

		data.writeInt(0xFFCC99AA);
		Assert.equals(12, data.length);
		data.position = 8;

		Assert.equals(0xFFCC99AA, data.readInt());
	}

	/* Note: cannot find a test for this
		public function test_testReadWriteMultiByte()
		{
			var data = new ByteArray();
			var encoding = "utf-8";
			data.writeMultiByte("a", encoding);
			Assert.equals(4, data.length );
			data.position = 0;

			Assert.equals( "a", data.readMultiByte(4, encoding));
	}*/
	/* TODO: use haxe's serializer
		public function test_testReadWriteObject()
		{
			var data = new ByteArray();
			var dummy = { txt: "string of dummy text" };
			data.writeObject( dummy );

			data.position = 0;
			Assert.equals( dummy.txt, data.readObject().txt );
	}*/
	public function test_testReadWriteShort()
	{
		var data = new ByteArray();
		data.writeShort(5);
		data.position = 0;

		Assert.equals(5, data.readShort());
		Assert.equals(2, data.length);

		data.writeShort(0xFC);
		data.position = 2;

		Assert.equals(0xFC, data.readShort());
	}

	public function test_testReadSignedShort()
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		data.writeByte(0x10);
		data.writeByte(0xAA);
		data.writeByte(0x6B);
		data.writeByte(0xCF);
		data.position = 0;

		Assert.equals(-22000, data.readShort());
		Assert.equals(-12437, data.readShort());
	}

	public function test_testReadSignedByte()
	{
		var data:ByteArray = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		data.writeByte(0xFF);
		data.writeByte(0x80);
		data.writeByte(0x81);
		data.writeByte(0xE0);
		data.writeByte(0x01);
		data.writeByte(0x00);
		data.position = 0;

		Assert.equals(-1, data.readByte());
		Assert.equals(-128, data.readByte());
		Assert.equals(-127, data.readByte());
		Assert.equals(-32, data.readByte());
		Assert.equals(1, data.readByte());
		Assert.equals(0, data.readByte());
	}

	public function test_testReadWriteUTF()
	{
		var data = new ByteArray();
		data.writeUTF("é");

		data.position = 0;

		#if (haxe_ver >= "4.0.0")
		#if js
		Assert.equals(4, data.readUnsignedShort());
		#else
		Assert.equals(2, data.readUnsignedShort());
		#end
		#else
		Assert.equals(2, data.readUnsignedShort());
		#end

		data.position = 0;

		Assert.equals("é", data.readUTF());
	}

	public function test_testReadWriteUTFBytes()
	{
		var data = new ByteArray();
		var str = "Héllo World !";
		data.writeUTFBytes(str);

		// Flash is adding a byte for a null terminator

		#if (haxe_ver >= "4.0.0")
		#if js
		Assert.equals(16, data.length);
		#else
		Assert.equals(14, data.length);
		#end
		#else
		Assert.equals(14, data.length);
		#end

		data.position = 0;

		Assert.equals(str, data.readUTFBytes(data.length));
	}

	public function test_testEmptyArray()
	{
		var data = new ByteArray();

		Assert.equals(0, data.length);

		var testString:String;

		// Verify that readUTFBytes correctly handles
		// an empty ByteArray and doesn't crash
		testString = data.readUTFBytes(data.length);
		Assert.equals(0, testString.length);

		// Test toString as well just in case it gets changed
		// to not just call readUTFBytes
		testString = data.toString();
		Assert.equals(0, testString.length);
	}

	public function test_testReadWriteUnsigned()
	{
		var data = new ByteArray();
		data.writeByte(4);
		Assert.equals(1, data.length);
		data.position = 0;
		Assert.equals(4, data.readUnsignedByte());
		data.position = 4;

		data.writeShort(200);
		Assert.equals(6, data.length);
		data.position = 4;

		Assert.equals(200, data.readUnsignedShort());

		data.writeUnsignedInt(65000);
		Assert.equals(10, data.length);
		data.position = 6;

		Assert.equals(65000, data.readUnsignedInt());
	}

	private function flipBytes(read:ByteArray, write:ByteArray, readOffset:Int, writeLength:Int):Void
	{
		for (i in 0...writeLength)
		{
			read.position = readOffset + (writeLength - 1 - i);
			write.writeByte(read.readByte());
		}
	}

	private function nearEquals(a:Float, b:Float):Bool
	{
		if (a == b) return true;

		var diff = (b / a);
		if (diff < 1.001 && diff > 0.999) return true;

		trace("Value [" + b + "] was not near expected value [" + a + "]");
		return false;
	}

	public function test_testEndianness()
	{
		var byteArray = new ByteArray();
		var defaultEndian:Endian = #if lime System.endianness #else LITTLE_ENDIAN #end;
		Assert.equals(defaultEndian, byteArray.endian);

		var short:Int = 3000;
		var int:Int = 200000000;
		var float:Float = 3.0E+38;
		var double = 1.7E+308;
		var utf = "Hello World";

		var byteArray = new ByteArray();
		byteArray.endian = LITTLE_ENDIAN;

		byteArray.writeShort(short);
		byteArray.writeInt(int);
		byteArray.writeFloat(float);
		byteArray.writeDouble(double);
		byteArray.writeUTFBytes(utf);

		var stringLength = byteArray.length - 18;

		var flip = new ByteArray();
		flipBytes(byteArray, flip, 0, 2);
		flipBytes(byteArray, flip, 2, 4);
		flipBytes(byteArray, flip, 6, 4);
		flipBytes(byteArray, flip, 10, 8);

		byteArray.position = byteArray.length - stringLength;
		flip.writeBytes(byteArray, flip.position, stringLength);
		// flipBytes (byteArray, flip, 18, stringLength);

		flip.endian = BIG_ENDIAN;
		flip.position = 0;

		Assert.equals(short, flip.readShort());
		Assert.equals(int, flip.readInt());
		Assert.isTrue(nearEquals(float, flip.readFloat()));
		Assert.equals(double, flip.readDouble());
		Assert.equals(utf, flip.readUTFBytes(stringLength));

		var byteArray = new ByteArray();
		byteArray.endian = BIG_ENDIAN;

		byteArray.writeShort(short);
		byteArray.writeInt(int);
		byteArray.writeFloat(float);
		byteArray.writeDouble(double);
		byteArray.writeUTFBytes(utf);

		var flip = new ByteArray();
		flipBytes(byteArray, flip, 0, 2);
		flipBytes(byteArray, flip, 2, 4);
		flipBytes(byteArray, flip, 6, 4);
		flipBytes(byteArray, flip, 10, 8);

		byteArray.position = byteArray.length - stringLength;
		flip.writeBytes(byteArray, flip.position, stringLength);
		// flipBytes (byteArray, flip, 18, stringLength);

		flip.endian = LITTLE_ENDIAN;
		flip.position = 0;

		Assert.equals(short, flip.readShort());
		Assert.equals(int, flip.readInt());
		Assert.isTrue(nearEquals(float, flip.readFloat()));
		Assert.equals(double, flip.readDouble());
		Assert.equals(utf, flip.readUTFBytes(stringLength));

		var littleEndian = new ByteArray();
		littleEndian.endian = LITTLE_ENDIAN;

		var bigEndian = new ByteArray();
		bigEndian.endian = BIG_ENDIAN;

		littleEndian.writeByte(0x12);
		littleEndian.writeByte(0xCD);

		bigEndian.writeByte(0xCD);
		bigEndian.writeByte(0x12);

		littleEndian.position = 0;
		bigEndian.position = 0;

		Assert.equals(littleEndian.readShort(), bigEndian.readShort());

		littleEndian.position = 0;
		Assert.equals(-13038, littleEndian.readShort());

		littleEndian.position = 0;
		bigEndian.position = 0;

		littleEndian.writeByte(0x90);
		littleEndian.writeByte(0xAB);
		littleEndian.writeByte(0x12);
		littleEndian.writeByte(0xCD);

		bigEndian.writeByte(0xCD);
		bigEndian.writeByte(0x12);
		bigEndian.writeByte(0xAB);
		bigEndian.writeByte(0x90);

		littleEndian.position = 0;
		bigEndian.position = 0;

		Assert.equals(littleEndian.readInt(), bigEndian.readInt());

		littleEndian.position = 0;
		Assert.equals(0xCD12AB90, littleEndian.readInt());

		littleEndian.position = 0;
		bigEndian.position = 0;

		Assert.equals(littleEndian.readFloat(), bigEndian.readFloat());

		littleEndian.position = 0;
		Assert.equals(-153794816, littleEndian.readFloat());

		littleEndian.position = 0;
		bigEndian.position = 0;

		littleEndian.writeByte(0x0D);
		littleEndian.writeByte(0x0C);
		littleEndian.writeByte(0x0B);
		littleEndian.writeByte(0x0A);
		littleEndian.writeByte(0x90);
		littleEndian.writeByte(0xAB);
		littleEndian.writeByte(0x12);
		littleEndian.writeByte(0xCD);

		bigEndian.writeByte(0xCD);
		bigEndian.writeByte(0x12);
		bigEndian.writeByte(0xAB);
		bigEndian.writeByte(0x90);
		bigEndian.writeByte(0x0A);
		bigEndian.writeByte(0x0B);
		bigEndian.writeByte(0x0C);
		bigEndian.writeByte(0x0D);

		littleEndian.position = 0;
		bigEndian.position = 0;

		Assert.equals(littleEndian.readDouble(), bigEndian.readDouble());

		littleEndian.position = 0;
		Assert.isTrue(nearEquals(-1.92011526560524e+63, littleEndian.readDouble()));
	}

	public function test_testZeroMemory()
	{
		var byteArray:ByteArray;
		var length = 20;

		for (i in 0...100)
		{
			byteArray = new ByteArray(length);

			for (i in 0...length)
			{
				Assert.equals(0, byteArray.readByte());
			}
		}
	}
	/*static private function serializeByteArray(ba:ByteArray):String {
		var str:String = "";
		for (n in 0 ... ba.length) str += ba[n] + ",";
		return str.substr(0, str.length - 1);
	}*/
	// #if (cpp || neko)
	/*#if (cpp)
		public function test_testCompressUncompressLzma() {

			var data:ByteArray = new ByteArray();
			var str:String = "Hello WorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorld!";
			data.writeUTFBytes(str);

			Assert.equals(str.length, data.length);

			data.compress(CompressionAlgorithm.LZMA);

			Assert.equals(
				"93,0,0,16,0,112,0,0,0,0,0,0,0,0,36,25,73,152,111,16,17,200,95,230,213,143,173,134,203,110,136,96,0",
				serializeByteArray(data)
			);

			//for (n in 0 ... data.length) TestRunner.print(data[n] + ",");
			//TestRunner.print(" :: " + data.length + "," + str.length + "\n\n");

			Assert.isTrue(cast data.length != cast str.length);

			data.uncompress(CompressionAlgorithm.LZMA);
			data.position = 0;
			Assert.equals(str.length, data.length);
			Assert.equals(str, data.readUTFBytes(str.length));
		}
		#end */
	/*public function test_testUncompress () {

		var data = new ByteArray();

		data.writeByte(120);
		data.writeByte(156);
		data.writeByte(203);
		data.writeByte(72);
		data.writeByte(205);
		data.writeByte(201);
		data.writeByte(201);
		data.writeByte(87);
		data.writeByte(200);
		data.writeByte(0);
		data.writeByte(145);
		data.writeByte(0);
		data.writeByte(25);
		data.writeByte(145);
		data.writeByte(4);
		data.writeByte(73);

		data.position = 0;

		data.uncompress();

		Assert.equals(104, data.readUnsignedByte());
		Assert.equals(101, data.readUnsignedByte());
		Assert.equals(108, data.readUnsignedByte());
		Assert.equals(108, data.readUnsignedByte());
		Assert.equals(111, data.readUnsignedByte());
		Assert.equals(32, data.readUnsignedByte());
		Assert.equals(104, data.readUnsignedByte());
		Assert.equals(101, data.readUnsignedByte());
		Assert.equals(108, data.readUnsignedByte());
		Assert.equals(108, data.readUnsignedByte());
		Assert.equals(111, data.readUnsignedByte());

	}*/
}
