package flash.utils;

#if flash
import openfl.net.ObjectEncoding;

extern interface IDataInput
{
	// #if flash
	public var bytesAvailable(default, never):UInt;
	// #else
	// public var bytesAvailable (get, never):UInt;
	// @:noCompletion private function get_bytesAvailable ():UInt;
	// #end
	// #if flash
	public var endian:Endian;
	// #else
	// public var endian (get, set):Endian;
	// @:noCompletion private function get_endian ():Endian;
	// @:noCompletion private function set_endian (value:Endian):Endian;
	// #end
	public var objectEncoding:ObjectEncoding;
	public function readBoolean():Bool;
	public function readByte():Int;
	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void;
	public function readDouble():Float;
	public function readFloat():Float;
	public function readInt():Int;
	public function readMultiByte(length:UInt, charSet:String):String;
	// #if flash
	public function readObject():Dynamic;
	// #end
	public function readShort():Int;
	public function readUnsignedByte():Int;
	public function readUnsignedInt():Int;
	public function readUnsignedShort():Int;
	public function readUTF():String;
	public function readUTFBytes(length:Int):String;
}
#else
typedef IDataInput = openfl.utils.IDataInput;
#end
