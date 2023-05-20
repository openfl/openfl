package flash.utils;

#if flash
import openfl.net.ObjectEncoding;

extern interface IDataOutput
{
	#if (haxe_ver < 4.3)
	public var endian:Endian;
	public var objectEncoding:ObjectEncoding;
	#else
	@:flash.property var endian(get, set):Endian;
	@:flash.property var objectEncoding(get, set):ObjectEncoding;
	#end
	public function writeBoolean(value:Bool):Void;
	public function writeByte(value:Int):Void;
	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void;
	public function writeDouble(value:Float):Void;
	public function writeFloat(value:Float):Void;
	public function writeInt(value:Int):Void;
	public function writeMultiByte(value:String, charSet:String):Void;
	public function writeObject(object:Dynamic):Void;
	public function writeShort(value:Int):Void;
	public function writeUTF(value:String):Void;
	public function writeUTFBytes(value:String):Void;
	public function writeUnsignedInt(value:Int):Void;

	#if (haxe_ver >= 4.3)
	private function get_endian():Endian;
	private function get_objectEncoding():ObjectEncoding;
	private function set_endian(value:Endian):Endian;
	private function set_objectEncoding(value:ObjectEncoding):ObjectEncoding;
	#end
}
#else
typedef IDataOutput = openfl.utils.IDataOutput;
#end
