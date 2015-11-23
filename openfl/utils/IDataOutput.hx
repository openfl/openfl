package openfl.utils; #if (!display && !flash) #if !openfl_legacy


interface IDataOutput {
	
	//var endian:Endian;
	var endian (get, set):String;
	var objectEncoding:Int;
	
	function writeBoolean (value:Bool):Void;
	function writeByte (value:Int):Void;
	function writeBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void;
	function writeDouble (value:Float):Void;
	function writeFloat (value:Float):Void;
	function writeInt (value:Int):Void;
	function writeMultiByte (value:String, charSet:String):Void;
	function writeObject (object:Dynamic):Void;
	function writeShort (value:Int):Void;
	function writeUTF (value:String):Void;
	function writeUTFBytes (value:String):Void;
	function writeUnsignedInt (value:Int):Void;
	
}


#else
typedef IDataOutput = openfl._legacy.utils.IDataOutput;
#end
#else


#if flash
@:native("flash.utils.IDataOutput")
#end

extern interface IDataOutput {
	//var endian:Endian;
	#if flash
	var endian:Endian;
	#else
	var endian (get, set):String;
	#end
	var objectEncoding : UInt;
	function writeBoolean(value : Bool) : Void;
	function writeByte(value : Int) : Void;
	function writeBytes(bytes : ByteArray, offset : UInt = 0, length : UInt = 0) : Void;
	function writeDouble(value : Float) : Void;
	function writeFloat(value : Float) : Void;
	function writeInt(value : Int) : Void;
	function writeMultiByte(value : String, charSet : String) : Void;
	function writeObject(object : Dynamic) : Void;
	function writeShort(value : Int) : Void;
	function writeUTF(value : String) : Void;
	function writeUTFBytes(value : String) : Void;
	function writeUnsignedInt(value : UInt) : Void;
}


#end