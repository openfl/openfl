package flash.net;

#if flash
import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.IDataInput;

extern class URLStream extends EventDispatcher implements IDataInput
{
	#if (haxe_ver < 4.3)
	public var bytesAvailable(default, never):UInt;
	public var connected(default, never):Bool;
	@:require(flash11_4) public var diskCacheEnabled(default, never):Bool;
	public var endian:Endian;
	@:require(flash11_4) public var length(default, never):Float;
	public var objectEncoding:ObjectEncoding;
	@:require(flash11_4) public var position:Float;
	#else
	@:flash.property var bytesAvailable(get, never):UInt;
	@:flash.property var connected(get, never):Bool;
	@:flash.property @:require(flash11_4) var diskCacheEnabled(get, never):Bool;
	@:flash.property var endian(get, set):Endian;
	@:flash.property @:require(flash11_4) var length(get, never):Float;
	@:flash.property var objectEncoding(get, set):ObjectEncoding;
	@:flash.property @:require(flash11_4) var position(get, set):Float;
	#end

	public function new():Void;
	public function close():Void;
	public function load(request:URLRequest):Void;
	public function readBoolean():Bool;
	public function readByte():Int;
	public function readBytes(bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void;
	public function readDouble():Float;
	public function readFloat():Float;
	public function readInt():Int;
	public function readMultiByte(length:UInt, charSet:String):String;
	public function readObject():Dynamic;
	public function readShort():Int;
	public function readUTF():String;
	public function readUTFBytes(length:UInt):String;
	public function readUnsignedByte():UInt;
	public function readUnsignedInt():UInt;
	public function readUnsignedShort():UInt;
	@:require(flash11_4) public function stop():Void;

	#if (haxe_ver >= 4.3)
	private function get_bytesAvailable():UInt;
	private function get_connected():Bool;
	private function get_diskCacheEnabled():Bool;
	private function get_endian():Endian;
	private function get_length():Float;
	private function get_objectEncoding():ObjectEncoding;
	private function get_position():Float;
	private function set_endian(value:Endian):Endian;
	private function set_objectEncoding(value:ObjectEncoding):ObjectEncoding;
	private function set_position(value:Float):Float;
	#end
}
#else
typedef URLStream = openfl.net.URLStream;
#end
