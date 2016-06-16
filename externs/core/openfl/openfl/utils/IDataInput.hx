package openfl.utils;


#if flash
@:native("flash.utils.IDataInput")
#end

extern interface IDataInput {
	
	#if (flash && !display)
	public var bytesAvailable (default, null):UInt;
	#else
	public var bytesAvailable (get, never):UInt;
	#end
	
	#if (flash && !display)
	public var endian:Endian;
	#else
	public var endian (get, set):Endian;
	#end
	
	public var objectEncoding:UInt;
	
	public function readBoolean ():Bool;
	public function readByte ():Int;
	public function readBytes (bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void;
	public function readDouble ():Float;
	public function readFloat ():Float;
	public function readInt ():Int;
	public function readMultiByte (length:UInt, charSet:String):String;
	
	#if (flash && !display)
	public function readObject ():Dynamic;
	#end
	
	public function readShort ():Int;
	public function readUnsignedByte ():Int;
	public function readUnsignedInt ():Int;
	public function readUnsignedShort ():Int;
	public function readUTF ():String;
	public function readUTFBytes (length:Int):String;
	
}