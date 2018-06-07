package openfl.utils;


import openfl.net.ObjectEncoding;

#if flash
@:native("flash.utils.IDataOutput")
#end

extern interface IDataOutput {
	
	#if (flash && !display)
	public var endian:Endian;
	#else
	public var endian (get, set):Endian;
	
	@:noCompletion private function get_endian ():Endian;
	@:noCompletion private function set_endian (value:Endian):Endian;
	#end
	
	public var objectEncoding:ObjectEncoding;
	
	public function writeBoolean (value:Bool):Void;
	public function writeByte (value:Int):Void;
	public function writeBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void;
	public function writeDouble (value:Float):Void;
	public function writeFloat (value:Float):Void;
	public function writeInt (value:Int):Void;
	public function writeMultiByte (value:String, charSet:String):Void;
	
	#if (flash && !display)
	public function writeObject (object:Dynamic):Void;
	#end
	
	public function writeShort (value:Int):Void;
	public function writeUTF (value:String):Void;
	public function writeUTFBytes (value:String):Void;
	public function writeUnsignedInt (value:Int):Void;
	
}