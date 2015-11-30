package openfl.utils; #if (!display && !flash) #if !openfl_legacy


interface IDataInput {
	
	public var bytesAvailable (get, never):UInt;
	public var endian:Endian;
	public var objectEncoding:UInt;
	
	public function readBoolean ():Bool;
	public function readByte ():Int;
	public function readBytes (bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void;
	public function readDouble ():Float;
	public function readFloat ():Float;
	public function readInt ():Int;
	public function readMultiByte (length:UInt, charSet:String):String;
	//function readObject ():Dynamic;
	public function readShort ():Int;
	public function readUnsignedByte ():Int;
	public function readUnsignedInt ():Int;
	public function readUnsignedShort ():Int;
	public function readUTF ():String;
	public function readUTFBytes (length:Int):String;
	
}


#else
typedef IDataInput = openfl._legacy.utils.IDataInput;
#end
#else


#if flash
@:native("flash.utils.IDataInput")
#end

extern interface IDataInput {
	
	public var bytesAvailable (get, never):UInt;
	public var endian:Endian;
	public var objectEncoding:UInt;
	
	public function readBoolean ():Bool;
	public function readByte ():Int;
	public function readBytes (bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void;
	public function readDouble ():Float;
	public function readFloat ():Float;
	public function readInt ():Int;
	public function readMultiByte (length:UInt, charSet:String):String;
	//function readObject ():Dynamic;
	public function readShort ():Int;
	public function readUnsignedByte ():Int;
	public function readUnsignedInt ():Int;
	public function readUnsignedShort ():Int;
	public function readUTF ():String;
	public function readUTFBytes (length:Int):String;
	
}


#end