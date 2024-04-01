package flash.utils;

#if flash
import openfl.net.ObjectEncoding;

extern interface IDataInput
{
	#if (haxe_ver < 4.3)
	public var bytesAvailable(default, never):UInt;
	public var endian:Endian;
	public var objectEncoding:ObjectEncoding;
	#else
	@:flash.property var bytesAvailable(get, never):UInt;
	@:flash.property var endian(get, set):Endian;
	@:flash.property var objectEncoding(get, set):ObjectEncoding;
	#end
	public function readBoolean():Bool;
	public function readByte():Int;
	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void;
	public function readDouble():Float;
	public function readFloat():Float;
	public function readInt():Int;
	public function readMultiByte(length:UInt, charSet:String):String;
	public function readObject():Dynamic;
	public function readShort():Int;
	public function readUnsignedByte():Int;
	public function readUnsignedInt():Int;
	public function readUnsignedShort():Int;
	public function readUTF():String;
	public function readUTFBytes(length:Int):String;
	#if (haxe_ver >= 4.3)
	private function get_bytesAvailable():UInt;
	private function get_endian():Endian;
	private function get_objectEncoding():ObjectEncoding;
	private function set_endian(value:Endian):Endian;
	private function set_objectEncoding(value:ObjectEncoding):ObjectEncoding;
	#end
}
#else
typedef IDataInput = openfl.utils.IDataInput;
#end
