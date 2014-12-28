package openfl.utils;


import massive.munit.Assert;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.CompressionAlgorithm;


class ByteArrayTest {

	
	@Test public function testWritePos () {
		
		var ba:ByteArray = new ByteArray();
		
		ba.endian = Endian.LITTLE_ENDIAN;
		
		Assert.areEqual(0, ba.length);
		
		ba.writeByte(0xFF);
		Assert.areEqual(1, ba.length);
		Assert.areEqual(1, ba.position);
		
		#if (js || flash) // array access might not be possible :(
		ba.position = 0;
		Assert.areEqual(0xFF, ba.readUnsignedByte ());
		#else
		Assert.areEqual(0xFF, ba[0]);
		#end
		
		ba.position = 0;
		Assert.areEqual(0, ba.position);
		ba.writeByte(0x7F);
		Assert.areEqual(1, ba.length);
		Assert.areEqual(1, ba.position);
		
		#if js
		ba.position = 0;
		Assert.areEqual(0x7F, ba.readUnsignedByte ());
		#else
		Assert.areEqual(0x7F, ba[0]);
		#end
		
		ba.writeShort(0x1234);
		Assert.areEqual(3, ba.length);
		Assert.areEqual(3, ba.position);
		
		#if js
		ba.position = 1;
		Assert.areEqual(0x34, ba.readUnsignedByte ());
		Assert.areEqual(0x12, ba.readUnsignedByte ());
		#else
		Assert.areEqual(0x34, ba[1]);
		Assert.areEqual(0x12, ba[2]);
		#end
		
		ba.clear();
		Assert.areEqual(0, ba.length);
		
		ba.writeUTFBytes("TEST");
		Assert.areEqual(4, ba.length);
		Assert.areEqual(4, ba.position);

		ba.writeInt(0x12345678);
		Assert.areEqual(8, ba.length);
		Assert.areEqual(8, ba.position);

		ba.writeShort(0x1234);
		Assert.areEqual(10, ba.length);
		Assert.areEqual(10, ba.position);
		
		ba.position = 3;
		Assert.areEqual(10, ba.length);
		ba.writeShort(0x1234);
		Assert.areEqual(10, ba.length);
		Assert.areEqual(5, ba.position);
		
	}
	
	
	@Test public function testReadWriteBoolean() {
		
		var data = new ByteArray();
		data.writeBoolean(true);
		data.position = 0;
		Assert.areEqual( true, data.readBoolean() );
		data.writeBoolean(false);
		data.position = 1;
		Assert.areEqual( false, data.readBoolean() );
		
	}
	
	
	@Test public function testReadWriteByte() {
		
		var data = new ByteArray();
		data.writeByte(127);
		data.position = 0;
		Assert.areEqual( 127, data.readByte() );

		data.writeByte(34);
		data.position = 1;
		Assert.areEqual( 34, data.readByte() );

		Assert.areEqual( 2, data.length );
		
	}
	
	
	@Test public function testReadWriteBytes() {
		
		var input = new ByteArray();
		input.writeByte( 118 );
		input.writeByte( 38 );
		input.writeByte( 67 );
		input.writeByte( 89 );
		input.writeByte( 19 );
		input.writeByte( 17 );
		var data = new ByteArray();
	
		data.writeBytes( input, 0, 4 );
		Assert.areEqual( 4, data.length );

		data.position = 0;
		var output = new ByteArray();
		data.readBytes( output, 0, 2 );

		Assert.areEqual( 2, output.length );
		Assert.areEqual( 118, output.readByte() );
		Assert.areEqual( 38, output.readByte() );

		data.position = 2;
		data.writeBytes( input, 2, 4 );
		Assert.areEqual( 6, data.length );

		data.position = 4;
		data.readBytes( output, 2, 2 );
		Assert.areEqual( 4, output.length );
		output.position = 2;

		Assert.areEqual( 19, output.readByte() );
		Assert.areEqual( 17, output.readByte() );
		
	}
	
	
	@Test public function testReadWriteDouble() {
		
		var data = new ByteArray();
		data.writeDouble( Math.PI );
		data.position = 0;

		Assert.areEqual( Math.PI, data.readDouble() );
		Assert.areEqual( 8, data.position );

		data.position = 0;
		Assert.areEqual( Math.PI, data.readDouble() );

		data.writeDouble( 6 );
		data.position = 8;

		Assert.areEqual( 6., data.readDouble() );

		data.writeDouble( 3.121244489 );
		data.position = 16;

		Assert.areEqual( 3.121244489, data.readDouble() );

		data.writeDouble( -0.000244489 );
		data.position = 24;

		Assert.areEqual( -0.000244489, data.readDouble() );

		data.writeDouble( -99.026771 );
		data.position = 32;

		Assert.areEqual( -99.026771, data.readDouble() );
		
	}
	
	
	@Test public function testReadWriteFloat () {
		
		var data = new ByteArray();
		data.writeFloat( 2);
		data.position = 0;

		Assert.areEqual( 2., data.readFloat() );
		Assert.areEqual( 4, data.position );

		data.writeFloat( .18 );
		data.position = 4;
		var actual = data.readFloat();
		Assert.isTrue( .179999 < actual );
		Assert.isTrue( .180001 > actual );
		
		data.writeFloat( 3.452221 );
		data.position = 8;
		var actual = data.readFloat();
		Assert.isTrue( 3.452220 < actual );
		Assert.isTrue( 3.452222 > actual );

		data.writeFloat( 39.19442 );
		data.position = 12;
		var actual = data.readFloat();
		Assert.isTrue( 39.19441 < actual );
		Assert.isTrue( 39.19443 > actual );

		data.writeFloat( .994423 );
		data.position = 16;
		var actual = data.readFloat();
		Assert.isTrue( .994422 < actual );
		Assert.isTrue( .994424 > actual );

		data.writeFloat( -.434423 );
		data.position = 20;
		var actual = data.readFloat();
		Assert.isTrue( -.434421 > actual );
		Assert.isTrue( -.434424 < actual );
		
	}
	
	
	@Test public function testReadWriteInt() {
		
		var data = new ByteArray();
		data.writeInt( 0xFFCC );
		Assert.areEqual( 4, data.length );
		data.position = 0;

		Assert.areEqual( 0xFFCC, data.readInt() );
		Assert.areEqual( 4, data.position );

		data.writeInt( 0xFFCC99 );
		Assert.areEqual( 8, data.length );
		data.position = 4;

		Assert.areEqual( 0xFFCC99, data.readInt() );

		data.writeInt( 0xFFCC99AA );
		Assert.areEqual( 12, data.length );
		data.position = 8;

		Assert.areEqual( 0xFFCC99AA, data.readInt() );
		
	}
	
	
	/* Note: cannot find a test for this
	@Test public function testReadWriteMultiByte()
	{
		var data = new ByteArray();
		var encoding = "utf-8";
		data.writeMultiByte("a", encoding);
		Assert.areEqual(4, data.length );
		data.position = 0;

		Assert.areEqual( "a", data.readMultiByte(4, encoding));
	} */
	
	
	/* TODO: use haxe's serializer
	@Test public function testReadWriteObject()
	{
		var data = new ByteArray();
		var dummy = { txt: "string of dummy text" };
		data.writeObject( dummy );

		data.position = 0;
		Assert.areEqual( dummy.txt, data.readObject().txt );
	}*/
	
	
	@Test public function testReadWriteShort () {
		
		var data = new ByteArray();
		data.writeShort( 5 );
		data.position = 0;

		Assert.areEqual( 5, data.readShort() );
		Assert.areEqual( 2, data.length );

		data.writeShort( 0xFC );
		data.position = 2;

		Assert.areEqual( 0xFC, data.readShort() );
		
	}
	
	@Test public function testReadSignedShort() {
		
		var data:ByteArray = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		data.writeByte(0x10); data.writeByte(0xAA);
		data.writeByte(0x6B); data.writeByte(0xCF);
		data.position = 0;
		
		Assert.areEqual(-22000, data.readShort());
		Assert.areEqual(-12437, data.readShort());
	}
	
	@Test public function testReadSignedByte() {
		
		var data:ByteArray = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
		data.writeByte(0xFF);
		data.writeByte(0x80);
		data.writeByte(0x81);
		data.writeByte(0xE0);
		data.writeByte(0x01);
		data.writeByte(0x00);
		data.position = 0;
		
		Assert.areEqual( -1, data.readByte());
		Assert.areEqual( -128, data.readByte());
		Assert.areEqual( -127, data.readByte());
		Assert.areEqual( -32, data.readByte());
		Assert.areEqual( 1, data.readByte());
		Assert.areEqual(0, data.readByte());
	}
	
	
	@Test public function testReadWriteUTF () {
		
		var data = new ByteArray();
		data.writeUTF("\xE9");

		data.position = 0;
		#if (flash || js)
		Assert.areEqual(2, data.readUnsignedShort() );
		#else
		Assert.areEqual(1, data.readUnsignedShort() );
		#end
		data.position = 0;

		Assert.areEqual( "\xE9", data.readUTF() );
		
	}
	
	
	@Test public function testReadWriteUTFBytes () {
		
		var data = new ByteArray();
		var str = "H\xE9llo World !";
		data.writeUTFBytes(str);
		
		// Flash is adding a byte for a null terminator
		
		#if (flash || js)
		Assert.areEqual(14, data.length);
		#else
		Assert.areEqual(13, data.length);
		#end
		data.position = 0;
		
		Assert.areEqual( str, data.readUTFBytes(data.length) );
		
	}
	
	
	@Test public function testEmptyArray () {
		
		var data = new ByteArray();

		Assert.areEqual(0, data.length);

		var testString : String;

		// Verify that readUTFBytes correctly handles
		// an empty ByteArray and doesn't crash
		testString = data.readUTFBytes(data.length);
		Assert.areEqual( 0, testString.length );

		// Test toString as well just in case it gets changed
		// to not just call readUTFBytes
		testString = data.toString();
		Assert.areEqual( 0, testString.length );
	}
	

	@Test public function testReadWriteUnsigned () {
		
		var data = new ByteArray();
		data.writeByte( 4 );
		Assert.areEqual( 1, data.length );
		data.position = 0;
		Assert.areEqual( 4, data.readUnsignedByte() );
		data.position = 4;

		data.writeShort( 200 );
		Assert.areEqual( 6, data.length );
		data.position = 4;

		Assert.areEqual( 200, data.readUnsignedShort() );

		data.writeUnsignedInt( 65000 );
		Assert.areEqual( 10, data.length );
		data.position = 6;

		Assert.areEqual( 65000, data.readUnsignedInt() );
		
	}
	
	/*static private function serializeByteArray(ba:ByteArray):String {
		var str:String = "";
		for (n in 0 ... ba.length) str += ba[n] + ",";
		return str.substr(0, str.length - 1);
	}*/
	
	//#if (cpp || neko)
	/*#if (cpp)
	@Test public function testCompressUncompressLzma() {
		
		var data:ByteArray = new ByteArray();
		var str:String = "Hello WorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorldWorld!";
		data.writeUTFBytes(str);
		
		Assert.areEqual(str.length, data.length);

		data.compress(CompressionAlgorithm.LZMA);
		
		Assert.areEqual(
			"93,0,0,16,0,112,0,0,0,0,0,0,0,0,36,25,73,152,111,16,17,200,95,230,213,143,173,134,203,110,136,96,0",
			serializeByteArray(data)
		);

		//for (n in 0 ... data.length) TestRunner.print(data[n] + ",");
		//TestRunner.print(" :: " + data.length + "," + str.length + "\n\n");
		
		Assert.isTrue(cast data.length != cast str.length);
		
		data.uncompress(CompressionAlgorithm.LZMA);
		data.position = 0;
		Assert.areEqual(str.length, data.length);
		Assert.areEqual(str, data.readUTFBytes(str.length));
	}
	#end*/
	
	/*@Test public function testUncompress () {
	
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

		Assert.areEqual(104, data.readUnsignedByte());
		Assert.areEqual(101, data.readUnsignedByte());
		Assert.areEqual(108, data.readUnsignedByte());
		Assert.areEqual(108, data.readUnsignedByte());
		Assert.areEqual(111, data.readUnsignedByte());
		Assert.areEqual(32, data.readUnsignedByte());
		Assert.areEqual(104, data.readUnsignedByte());
		Assert.areEqual(101, data.readUnsignedByte());
		Assert.areEqual(108, data.readUnsignedByte());
		Assert.areEqual(108, data.readUnsignedByte());
		Assert.areEqual(111, data.readUnsignedByte());
		
	}*/
	
	
}
