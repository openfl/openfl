package openfl.utils; #if !flash #if !lime_legacy


interface IDataOutput {
	
	var endian:Endian;
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
typedef IDataOutput = openfl._v2.utils.IDataOutput;
#end
#else
typedef IDataOutput = flash.utils.IDataOutput;
#end