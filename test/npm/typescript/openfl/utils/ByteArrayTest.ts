import ByteArray from "openfl/utils/ByteArray";
import Endian from "openfl/utils/Endian";
import CompressionAlgorithm from "openfl/utils/CompressionAlgorithm";
import * as assert from "assert";


describe ("TypeScript | ByteArray", function () {
	
	
	var uint = function (value:number):number {
		
		return value >>> 0;
		
	}
	
	
	var flipBytes = function (read:ByteArray, write:ByteArray, readOffset:number, writeLength:number):void {
		
		for (var i = 0; i < writeLength; i++) {
			
			read.position = readOffset + (writeLength - 1 - i);
			write.writeByte (read.readByte ());
			
		}
		
	}
	
	
	var nearEquals = function (a:number, b:number):boolean {
		
		if (a == b) return true;
		
		var diff = (b / a);
		if (diff < 1.001 && diff > 0.999) return true;
		
		console.log ("Value [" + b + "] was not near expected value [" + a + "]");
		return false;
		
	}
	
	
	var getSystemEndianness = function () {
		
		// #if lime
		// return lime.system.System.endianness;
		// #elseif js
		var arrayBuffer = new ArrayBuffer (2);
		var uint8Array = new Uint8Array (arrayBuffer);
		var uint16array = new Uint16Array (arrayBuffer);
		uint8Array[0] = 0xAA;
		uint8Array[1] = 0xBB;
		if (uint16array[0] == 0xAABB) return Endian.BIG_ENDIAN;
		else return Endian.LITTLE_ENDIAN;
		// #end
		
	}
	
	
	it ("testWritePos", function () {
		
		var ba:ByteArray = new ByteArray();
		
		ba.endian = Endian.LITTLE_ENDIAN;
		
		assert.equal (ba.length, 0);
		
		ba.writeByte (0xFF);
		assert.equal (ba.length, 1);
		assert.equal (ba.position, 1);
		
		// #if (js || flash) // array access might not be possible :(
		ba.position = 0;
		assert.equal (ba.readUnsignedByte (), 0xFF);
		// #else
		// assert.equal (ba[0], 0xFF);
		// #end
		
		ba.position = 0;
		assert.equal (ba.position, 0);
		ba.writeByte(0x7F);
		assert.equal (ba.length, 1);
		assert.equal (ba.position, 1);
		
		// #if js
		ba.position = 0;
		assert.equal (ba.readUnsignedByte (), 0x7F);
		// #else
		// assert.equal (ba[0], 0x7F);
		// #end
		
		ba.writeShort(0x1234);
		assert.equal (ba.length, 3);
		assert.equal (ba.position, 3);
		
		// #if js
		ba.position = 1;
		assert.equal (ba.readUnsignedByte (), 0x34);
		assert.equal (ba.readUnsignedByte (), 0x12);
		// #else
		// assert.equal (ba[1], 0x34);
		// assert.equal (ba[2], 0x12);
		// #end
		
		ba.clear();
		assert.equal (ba.length, 0);
		
		ba.writeUTFBytes("TEST");
		assert.equal (ba.length, 4);
		assert.equal (ba.position, 4);
		
		ba.writeInt(0x12345678);
		assert.equal (ba.length, 8);
		assert.equal (ba.position, 8);
		
		ba.writeShort(0x1234);
		assert.equal (ba.length, 10);
		assert.equal (ba.position, 10);
		
		ba.position = 3;
		assert.equal (ba.length, 10);
		ba.writeShort(0x1234);
		assert.equal (ba.length, 10);
		assert.equal (ba.position, 5);
		
	});
	
	
	it ("testReadWriteBoolean", function () {
		
		var data = new ByteArray();
		data.writeBoolean(true);
		data.position = 0;
		assert(data.readBoolean());
		data.writeBoolean(false);
		data.position = 1;
		assert(!data.readBoolean());
		
	});
	
	
	it ("testReadWriteByte", function() {
		
		var data = new ByteArray();
		data.writeByte(127);
		data.position = 0;
		assert.equal (data.readByte(), 127);
		
		data.writeByte(34);
		data.position = 1;
		assert.equal (data.readByte(), 34);
		
		assert.equal (data.length, 2);
		
	});
	
	
	it ("testReadWriteBytes", function() {
		
		var input = new ByteArray();
		input.writeByte( 118 );
		input.writeByte( 38 );
		input.writeByte( 67 );
		input.writeByte( 89 );
		input.writeByte( 19 );
		input.writeByte( 17 );
		var data = new ByteArray();
		
		data.writeBytes( input, 0, 4 );
		assert.equal (data.length, 4);
		
		data.position = 0;
		var output = new ByteArray();
		data.readBytes( output, 0, 2 );
		
		assert.equal (output.length, 2);
		assert.equal (output.readByte(), 118);
		assert.equal (output.readByte(), 38);
		
		data.position = 2;
		data.writeBytes( input, 2, 4 );
		assert.equal (data.length, 6);
		
		data.position = 4;
		data.readBytes( output, 2, 2 );
		assert.equal (output.length, 4);
		output.position = 2;
		
		assert.equal (output.readByte(), 19);
		assert.equal (output.readByte(), 17);
		
		var data = new ByteArray ();
		//data.writeBytes (input, 0, input.length * 2);
		data.writeBytes (input, 0, input.length); // docs say it should clamp to size?
		
		assert.equal (data.length, input.length);
		
	});
	
	
	it ("testReadWriteDouble", function() {
		
		var data = new ByteArray();
		data.writeDouble( Math.PI );
		data.position = 0;
		
		assert.equal (data.readDouble(), Math.PI);
		assert.equal (data.position, 8);
		
		data.position = 0;
		assert.equal (data.readDouble(), Math.PI);
		
		data.writeDouble( 6 );
		data.position = 8;
		
		assert.equal (data.readDouble(), 6.0);
		
		data.writeDouble( 3.121244489 );
		data.position = 16;
		
		assert.equal (data.readDouble(), 3.121244489);
		
		data.writeDouble( -0.000244489 );
		data.position = 24;
		
		assert.equal (data.readDouble(), -0.000244489);
		
		data.writeDouble( -99.026771 );
		data.position = 32;
		
		assert.equal (data.readDouble(), -99.026771);
		
	});
	
	
	it ("testReadWriteFloat", function () {
		
		var data = new ByteArray();
		data.writeFloat( 2);
		data.position = 0;
		
		assert.equal (data.readFloat(), 2.0);
		assert.equal (data.position, 4);
		
		data.writeFloat( .18 );
		data.position = 4;
		var actual = data.readFloat();
		assert( .179999 < actual );
		assert( .180001 > actual );
		
		data.writeFloat( 3.452221 );
		data.position = 8;
		var actual = data.readFloat();
		assert( 3.452220 < actual );
		assert( 3.452222 > actual );
		
		data.writeFloat( 39.19442 );
		data.position = 12;
		var actual = data.readFloat();
		assert( 39.19441 < actual );
		assert( 39.19443 > actual );
		
		data.writeFloat( .994423 );
		data.position = 16;
		var actual = data.readFloat();
		assert( .994422 < actual );
		assert( .994424 > actual );
		
		data.writeFloat( -.434423 );
		data.position = 20;
		var actual = data.readFloat();
		assert( -.434421 > actual );
		assert( -.434424 < actual );
		
	});
	
	
	it ("testReadWriteInt", function () {
		
		var data = new ByteArray();
		data.writeInt( 0xFFCC );
		assert.equal (data.length, 4);
		data.position = 0;
		
		assert.equal (data.readInt(), 0xFFCC);
		assert.equal (data.position, 4);
		
		data.writeInt( 0xFFCC99 );
		assert.equal (data.length, 8);
		data.position = 4;
		
		assert.equal (data.readInt(), 0xFFCC99);
		
		data.writeInt( 0xFFCC99AA );
		assert.equal (data.length, 12);
		data.position = 8;
		
		assert.equal (uint (data.readInt()), 0xFFCC99AA);
		
	});
	
	
	/* Note: cannot find a test for this
	it ("testReadWriteMultiByte()
	{
		var data = new ByteArray();
		var encoding = "utf-8";
		data.writeMultiByte("a", encoding);
		assert.equal(4, data.length );
		data.position = 0;
		
		assert.equal( "a", data.readMultiByte(4, encoding));
	} */
	
	
	/* TODO: use haxe's serializer
	it ("testReadWriteObject()
	{
		var data = new ByteArray();
		var dummy = { txt: "string of dummy text" };
		data.writeObject( dummy );

		data.position = 0;
		assert.equal( dummy.txt, data.readObject().txt );
	}*/
	
	
	it ("testReadWriteShort", function () {
		
		var data = new ByteArray();
		data.writeShort( 5 );
		data.position = 0;
		
		assert.equal (data.readShort(), 5);
		assert.equal (data.length, 2);
		
		data.writeShort( 0xFC );
		data.position = 2;
		
		assert.equal (data.readShort(), 0xFC);
		
	});
	
	it ("testReadSignedShort", function () {
		
		var data:ByteArray = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		data.writeByte(0x10); data.writeByte(0xAA);
		data.writeByte(0x6B); data.writeByte(0xCF);
		data.position = 0;
		
		assert.equal(data.readShort(), -22000);
		assert.equal(data.readShort(), -12437);
	});
	
	it ("testReadSignedByte", function () {
		
		var data:ByteArray = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		data.writeByte(0xFF);
		data.writeByte(0x80);
		data.writeByte(0x81);
		data.writeByte(0xE0);
		data.writeByte(0x01);
		data.writeByte(0x00);
		data.position = 0;
		
		assert.equal (data.readByte(), -1);
		assert.equal (data.readByte(), -128);
		assert.equal (data.readByte(), -127);
		assert.equal (data.readByte(), -32);
		assert.equal (data.readByte(), 1);
		assert.equal (data.readByte(), 0);
	});
	
	
	it ("testReadWriteUTF", function () {
		
		var data = new ByteArray();
		data.writeUTF("\xE9");
		
		data.position = 0;
		// #if (flash || js)
		assert.equal(data.readUnsignedShort(), 2);
		// #else
		// assert.equal(data.readUnsignedShort(), 1);
		// #end
		data.position = 0;
		
		assert.equal( "\xE9", data.readUTF() );
		
	});
	
	
	it ("testReadWriteUTFBytes", function () {
		
		var data = new ByteArray();
		var str = "H\xE9llo World !";
		data.writeUTFBytes(str);
		
		// Flash is adding a byte for a null terminator
		
		// #if (flash || js)
		assert.equal(data.length, 14);
		// #else
		// assert.equal(data.length, 13);
		// #end
		data.position = 0;
		
		assert.equal( str, data.readUTFBytes(data.length) );
		
	});
	
	
	it ("testEmptyArray", function () {
		
		var data = new ByteArray();
		
		assert.equal(data.length, 0);
		
		var testString : String;
		
		// Verify that readUTFBytes correctly handles
		// an empty ByteArray and doesn't crash
		testString = data.readUTFBytes(data.length);
		assert.equal(testString.length, 0);
		
		// Test toString as well just in case it gets changed
		// to not just call readUTFBytes
		testString = data.toString();
		assert.equal(testString.length, 0);
	});
	
	
	it ("testReadWriteUnsigned", function () {
		
		var data = new ByteArray();
		data.writeByte( 4 );
		assert.equal(data.length, 1);
		data.position = 0;
		assert.equal(data.readUnsignedByte(), 4);
		data.position = 4;
		
		data.writeShort( 200 );
		assert.equal(data.length, 6);
		data.position = 4;
		
		assert.equal(data.readUnsignedShort(), 200);
		
		data.writeUnsignedInt( 65000 );
		assert.equal(data.length, 10);
		data.position = 6;
		
		assert.equal(data.readUnsignedInt(),  65000);
		
	});
	
	
	it ("testEndianness", function () {
		
		var byteArray = new ByteArray ();
		var defaultEndian:Endian = getSystemEndianness ();
		assert.equal (byteArray.endian, defaultEndian);
		
		var short:number = 3000;
		var int:number = 200000000;
		var float:number = 3.0E+38;
		var double = 1.7E+308;
		var utf = "Hello World";
		
		var byteArray = new ByteArray ();
		byteArray.endian = Endian.LITTLE_ENDIAN;
		
		byteArray.writeShort (short);
		byteArray.writeInt (int);
		byteArray.writeFloat (float);
		byteArray.writeDouble (double);
		byteArray.writeUTFBytes (utf);
		
		var stringLength = byteArray.length - 18;
		
		var flip = new ByteArray ();
		flipBytes (byteArray, flip, 0, 2);
		flipBytes (byteArray, flip, 2, 4);
		flipBytes (byteArray, flip, 6, 4);
		flipBytes (byteArray, flip, 10, 8);
		
		byteArray.position = byteArray.length - stringLength;
		flip.writeBytes (byteArray, flip.position, stringLength);
		//flipBytes (byteArray, flip, 18, stringLength);
		
		flip.endian = Endian.BIG_ENDIAN;
		flip.position = 0;
		
		assert.equal (flip.readShort (), short);
		assert.equal (uint (flip.readInt ()), int);
		assert (nearEquals (float, flip.readFloat ()));
		assert.equal (flip.readDouble (), double);
		assert.equal (flip.readUTFBytes (stringLength), utf);
		
		var byteArray = new ByteArray ();
		byteArray.endian = Endian.BIG_ENDIAN;
		
		byteArray.writeShort (short);
		byteArray.writeInt (int);
		byteArray.writeFloat (float);
		byteArray.writeDouble (double);
		byteArray.writeUTFBytes (utf);
		
		var flip = new ByteArray ();
		flipBytes (byteArray, flip, 0, 2);
		flipBytes (byteArray, flip, 2, 4);
		flipBytes (byteArray, flip, 6, 4);
		flipBytes (byteArray, flip, 10, 8);
		
		byteArray.position = byteArray.length - stringLength;
		flip.writeBytes (byteArray, flip.position, stringLength);
		//flipBytes (byteArray, flip, 18, stringLength);
		
		flip.endian = Endian.LITTLE_ENDIAN;
		flip.position = 0;
		
		assert.equal (flip.readShort (), short);
		assert.equal (flip.readInt (), int);
		assert (nearEquals (float, flip.readFloat ()));
		assert.equal (flip.readDouble (), double);
		assert.equal (flip.readUTFBytes (stringLength), utf);
		
		var littleEndian = new ByteArray ();
		littleEndian.endian = Endian.LITTLE_ENDIAN;
		
		var bigEndian = new ByteArray ();
		bigEndian.endian = Endian.BIG_ENDIAN;
		
		littleEndian.writeByte (0x12);
		littleEndian.writeByte (0xCD);
		
		bigEndian.writeByte (0xCD);
		bigEndian.writeByte (0x12);
		
		littleEndian.position = 0;
		bigEndian.position = 0;
		
		assert.equal (bigEndian.readShort (), littleEndian.readShort ());
		
		littleEndian.position = 0;
		assert.equal (littleEndian.readShort (), -13038);
		
		littleEndian.position = 0;
		bigEndian.position = 0;
		
		littleEndian.writeByte (0x90);
		littleEndian.writeByte (0xAB);
		littleEndian.writeByte (0x12);
		littleEndian.writeByte (0xCD);
		
		bigEndian.writeByte (0xCD);
		bigEndian.writeByte (0x12);
		bigEndian.writeByte (0xAB);
		bigEndian.writeByte (0x90);
		
		littleEndian.position = 0;
		bigEndian.position = 0;
		
		assert.equal (bigEndian.readInt (), littleEndian.readInt ());
		
		littleEndian.position = 0;
		assert.equal (uint (littleEndian.readInt ()), 0xCD12AB90);
		
		littleEndian.position = 0;
		bigEndian.position = 0;
		
		assert.equal (bigEndian.readFloat (), littleEndian.readFloat ());
		
		littleEndian.position = 0;
		assert.equal (littleEndian.readFloat (), -153794816);
		
		littleEndian.position = 0;
		bigEndian.position = 0;
		
		littleEndian.writeByte (0x0D);
		littleEndian.writeByte (0x0C);
		littleEndian.writeByte (0x0B);
		littleEndian.writeByte (0x0A);
		littleEndian.writeByte (0x90);
		littleEndian.writeByte (0xAB);
		littleEndian.writeByte (0x12);
		littleEndian.writeByte (0xCD);
		
		bigEndian.writeByte (0xCD);
		bigEndian.writeByte (0x12);
		bigEndian.writeByte (0xAB);
		bigEndian.writeByte (0x90);
		bigEndian.writeByte (0x0A);
		bigEndian.writeByte (0x0B);
		bigEndian.writeByte (0x0C);
		bigEndian.writeByte (0x0D);
		
		littleEndian.position = 0;
		bigEndian.position = 0;
		
		assert.equal (bigEndian.readDouble (), littleEndian.readDouble ());
		
		littleEndian.position = 0;
		assert (nearEquals (-1.92011526560524e+63, littleEndian.readDouble ()));
		
	});
	
	
	it ("testZeroMemory", function () {
		
		var byteArray:ByteArray;
		var length = 20;
		
		for (var i = 0; i < 100; i++) {
			
			byteArray = new ByteArray (length);
			
			for (var j = 0; j < length; j++) {
				
				assert.equal (byteArray.readByte (), 0);
				
			}
			
		}
		
	});
	
	/*static private function serializeByteArray(ba:ByteArray):String {
		var str:String = "";
		for (n in 0 ... ba.length) str += ba[n] + ",";
		return str.substr(0, str.length - 1);
	}*/
	
	//#if (cpp || neko)
	/*#if (cpp)
	it ("testCompressUncompressLzma", function() {
		
		var data:ByteArray = new ByteArray();
		var str:String = "Hello WorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorld!";
		data.writeUTFBytes(str);
		
		assert.equal(str.length, data.length);

		data.compress(CompressionAlgorithm.LZMA);
		
		assert.equal(
			"93,0,0,16,0,112,0,0,0,0,0,0,0,0,36,25,73,152,111,16,17,200,95,230,213,143,173,134,203,110,136,96,0",
			serializeByteArray(data)
		);

		//for (n in 0 ... data.length) TestRunner.print(data[n] + ",");
		//TestRunner.print(" :: " + data.length + "," + str.length + "\n\n");
		
		assert(cast data.length != cast str.length);
		
		data.uncompress(CompressionAlgorithm.LZMA);
		data.position = 0;
		assert.equal(str.length, data.length);
		assert.equal(str, data.readUTFBytes(str.length));
	}
	#end*/
	
	/*it ("testUncompress", function () {
	
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

		assert.equal(104, data.readUnsignedByte());
		assert.equal(101, data.readUnsignedByte());
		assert.equal(108, data.readUnsignedByte());
		assert.equal(108, data.readUnsignedByte());
		assert.equal(111, data.readUnsignedByte());
		assert.equal(32, data.readUnsignedByte());
		assert.equal(104, data.readUnsignedByte());
		assert.equal(101, data.readUnsignedByte());
		assert.equal(108, data.readUnsignedByte());
		assert.equal(108, data.readUnsignedByte());
		assert.equal(111, data.readUnsignedByte());
		
	}*/
	
	
});