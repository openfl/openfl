package openfl._v2.utils; #if lime_legacy


interface IDataInput {
	
	
	public var bytesAvailable (get, null):Int;
	public var endian (get, set):String;
	
	public function readBoolean ():Bool;
	public function readByte ():Int;
	public function readBytes (data:ByteArray, offset:Int = 0, length:Int = 0):Void;
	public function readDouble ():Float;
	public function readFloat ():Float;
	public function readInt ():Int;
	public function readShort ():Int;
	public function readUnsignedByte ():Int;
	public function readUnsignedInt ():Int;
	public function readUnsignedShort ():Int;
	public function readUTF ():String;
	public function readUTFBytes (length:Int):String;
	
	
}


#end