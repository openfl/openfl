package openfl.utils; #if (!display && !flash) #if !openfl_legacy


interface IDataInput {
	
	//var bytesAvailable (default, null):Int;
	var bytesAvailable (get, null):Int;
	//var endian:Endian;
	var endian (get, set):String;
	var objectEncoding:Int;
	
	function readBoolean ():Bool;
	function readByte ():Int;
	function readBytes (bytes:ByteArray, offset:UInt = 0, length:Int = 0):Void;
	function readDouble ():Float;
	function readFloat ():Float;
	function readInt ():Int;
	function readMultiByte (length:UInt, charSet:String):String;
	//function readObject ():Dynamic;
	function readShort ():Int;
	function readUTF ():String;
	function readUTFBytes (length:Int):String;
	function readUnsignedByte ():Int;
	function readUnsignedInt ():Int;
	function readUnsignedShort ():Int;
	
}


#else
typedef IDataInput = openfl._legacy.utils.IDataInput;
#end
#else


#if flash
@:native("flash.utils.IDataInput")
#end

extern interface IDataInput {
	//var bytesAvailable(default,null) : UInt;
	var bytesAvailable (get, null):Int;
	//var endian:Endian;
	#if flash
	var endian:Endian;
	#else
	var endian (get, set):String;
	#end
	//var objectEncoding : UInt;
	var objectEncoding : Int;
	function readBoolean() : Bool;
	function readByte() : Int;
	function readBytes(bytes : ByteArray, offset : UInt = 0, length : UInt = 0) : Void;
	function readDouble() : Float;
	function readFloat() : Float;
	function readInt() : Int;
	function readMultiByte(length : UInt, charSet : String) : String;
	//function readObject() : Dynamic;
	function readShort() : Int;
	function readUTF() : String;
	function readUTFBytes(length : UInt) : String;
	function readUnsignedByte() : UInt;
	function readUnsignedInt() : UInt;
	function readUnsignedShort() : UInt;
}


#end