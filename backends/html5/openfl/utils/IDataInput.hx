package openfl.utils;


import openfl.utils.UInt;


interface IDataInput {
	
	var bytesAvailable (default, null):Int;
	var endian:Endian;
	var objectEncoding:Int;
	
	function readBoolean ():Bool;
	function readByte ():Int;
	function readBytes (bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void;
	function readDouble ():Float;
	function readFloat ():Float;
	function readInt ():Int;
	function readMultiByte (length:UInt, charSet:String):String;
	function readObject ():Dynamic;
	function readShort ():Int;
	function readUTF ():String;
	function readUTFBytes (length:Int):String;
	function readUnsignedByte ():Int;
	function readUnsignedInt ():Int;
	function readUnsignedShort ():Int;
	
}