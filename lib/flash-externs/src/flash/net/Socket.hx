package flash.net;

#if flash
import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.IDataInput;
import openfl.utils.IDataOutput;

extern class Socket extends EventDispatcher implements IDataInput implements IDataOutput
{
	#if (haxe_ver < 4.3)
	public var bytesAvailable(default, never):UInt;
	@:require(flash11) public var bytesPending(default, never):UInt;
	public var connected(default, never):Bool;
	public var endian:Endian;
	public var objectEncoding:ObjectEncoding;
	@:require(flash10) public var timeout:UInt;
	#if air
	public var localAddress(default, never):String;
	public var localPort(default, never):Int;
	public var remoteAddress(default, never):String;
	public var remotePort(default, never):Int;
	#end
	#else
	@:flash.property var bytesAvailable(get, never):UInt;
	@:flash.property @:require(flash11) var bytesPending(get, never):UInt;
	@:flash.property var connected(get, never):Bool;
	@:flash.property var endian(get, set):Endian;
	@:flash.property var objectEncoding(get, set):ObjectEncoding;
	@:flash.property @:require(flash10) var timeout(get, set):UInt;
	#if air
	@:flash.property var localAddress(get, never):String;
	@:flash.property var localPort(get, never):Int;
	@:flash.property var remoteAddress(get, never):String;
	@:flash.property var remotePort(get, never):Int;
	#end
	#end
	public function new(host:String = null, port:Int = 0);
	public function close():Void;
	public function connect(host:String = null, port:Int = 0):Void;
	public function flush():Void;
	public function readBoolean():Bool;
	public function readByte():Int;
	public function readBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void;
	public function readDouble():Float;
	public function readFloat():Float;
	public function readInt():Int;
	public function readMultiByte(length:Int, charSet:String):String;
	public function readObject():Dynamic;
	public function readShort():Int;
	public function readUnsignedByte():Int;
	public function readUnsignedInt():Int;
	public function readUnsignedShort():Int;
	public function readUTF():String;
	public function readUTFBytes(length:Int):String;
	public function writeBoolean(value:Bool):Void;
	public function writeByte(value:Int):Void;
	public function writeBytes(bytes:ByteArray, offset:Int = 0, length:Int = 0):Void;
	public function writeDouble(value:Float):Void;
	public function writeFloat(value:Float):Void;
	public function writeInt(value:Int):Void;
	public function writeMultiByte(value:String, charSet:String):Void;
	public function writeObject(object:Dynamic):Void;
	public function writeShort(value:Int):Void;
	public function writeUnsignedInt(value:Int):Void;
	public function writeUTF(value:String):Void;
	public function writeUTFBytes(value:String):Void;

	#if (haxe_ver >= 4.3)
	private function get_bytesAvailable():UInt;
	private function get_bytesPending():UInt;
	private function get_connected():Bool;
	private function get_endian():Endian;
	private function get_objectEncoding():ObjectEncoding;
	private function get_timeout():UInt;
	#if air
	private function get_localAddress():String;
	private function get_localPort():Int;
	private function get_remoteAddress():String;
	private function get_remotePort():Int;
	#end
	private function set_endian(value:Endian):Endian;
	private function set_objectEncoding(value:ObjectEncoding):ObjectEncoding;
	private function set_timeout(value:UInt):UInt;
	#end
}
#else
typedef Socket = openfl.net.Socket;
#end
