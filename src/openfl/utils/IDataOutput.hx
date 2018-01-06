package openfl.utils;


interface IDataOutput {
	
	public var endian (get, set):Endian;
	public var objectEncoding:UInt;
	
	public function writeBoolean (value:Bool):Void;
	public function writeByte (value:Int):Void;
	public function writeBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void;
	public function writeDouble (value:Float):Void;
	public function writeFloat (value:Float):Void;
	public function writeInt (value:Int):Void;
	public function writeMultiByte (value:String, charSet:String):Void;
	//public function writeObject (object:Dynamic):Void;
	public function writeShort (value:Int):Void;
	public function writeUTF (value:String):Void;
	public function writeUTFBytes (value:String):Void;
	public function writeUnsignedInt (value:Int):Void;
	
}