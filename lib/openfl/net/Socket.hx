package openfl.net; #if (display || !flash)


import openfl.events.EventDispatcher;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.IDataInput;
import openfl.utils.IDataOutput;

@:jsRequire("openfl/net/Socket", "default")


extern class Socket extends EventDispatcher implements IDataInput implements IDataOutput {
	
	
	public var bytesAvailable (default, never):UInt;
	public var bytesPending (default, never):UInt;
	public var connected (default, never):Bool;
	public var endian (default, set):Endian;
	public var objectEncoding:UInt;
	public var timeout:UInt;
	
	@:noCompletion private function get_bytesAvailable ():UInt;
	@:noCompletion private function get_endian ():Endian;
	@:noCompletion private function set_endian (value:Endian):Endian;
	
	public function new (host:String = null, port:Int = 0);
	public function close ():Void;
	public function connect (host:String = null, port:Int = 0):Void;
	public function flush ():Void;
	public function readBoolean ():Bool;
	public function readByte ():Int;
	public function readBytes (bytes: ByteArray, offset: Int = 0, length: Int = 0):Void;
	public function readDouble ():Float;
	public function readFloat ():Float;
	public function readInt ():Int;
	public function readMultiByte (length:Int, charSet:String):String;
	
	#if flash
	@:noCompletion @:dox(hide) public function readObject ():Dynamic;
	#end
	
	public function readShort ():Int;
	public function readUnsignedByte ():Int;
	public function readUnsignedInt ():Int;
	public function readUnsignedShort ():Int;
	public function readUTF ():String;
	public function readUTFBytes (length:Int):String;
	public function writeBoolean (value:Bool):Void;
	public function writeByte (value:Int):Void;
	public function writeBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void;
	public function writeDouble (value:Float):Void;
	public function writeFloat (value:Float):Void;
	public function writeInt (value:Int):Void;
	public function writeMultiByte (value:String, charSet:String):Void;
	
	#if flash
	@:noCompletion @:dox(hide) public function writeObject (object:Dynamic):Void;
	#end
	
	public function writeShort (value:Int):Void;
	public function writeUnsignedInt (value:Int):Void;
	public function writeUTF (value:String):Void;
	public function writeUTFBytes (value:String):Void;
	
	
}


#else
typedef Socket = flash.net.Socket;
#end