package openfl.utils {
	
	
	// import openfl.net.ObjectEncoding;
	
	
	// #if flash
	// @:native("flash.utils.IDataInput")
	// #end
	
	/**
	 * @externs
	 */
	public interface IDataInput {
		
		// #if (flash && !display)
		// var bytesAvailable (default, null):UInt;
		// #else
		function get bytesAvailable ():uint;
		
		// function get_bytesAvailable ():uint;
		// #end
		
		// #if (flash && !display)
		// var endian:Endian;
		// #else
		// var endian:String;
		
		// function get_endian ():String;
		// function set_endian (value:String):String;
		// #end
		
		// var objectEncoding:ObjectEncoding;
		
		function readBoolean ():Boolean;
		function readByte ():int;
		function readBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void;
		function readDouble ():Number;
		function readFloat ():Number;
		function readInt ():int;
		function readMultiByte (length:uint, charSet:String):String;
		
		// #if (flash && !display)
		// function readObject ():Dynamic;
		// #end
		
		function readShort ():int;
		function readUnsignedByte ():uint;
		function readUnsignedInt ():uint;
		function readUnsignedShort ():uint;
		function readUTF ():String;
		function readUTFBytes (length:uint):String;
		
	}
	
	
}
