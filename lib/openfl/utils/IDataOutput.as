package openfl.utils {
	
	
	// import openfl.net.ObjectEncoding;
	
	
	// #if flash
	// @:native("flash.utils.IDataOutput")
	// #end
	
	/**
	 * @externs
	 */
	public interface IDataOutput {
		
		// #if (flash && !display)
		// var endian:Endian;
		// #else
		// var endian:String;
		
		// function get_endian ():String;
		// function set_endian (value:String):String;
		// #end
		
		// var objectEncoding:String;
		
		function writeBoolean (value:Boolean):void;
		function writeByte (value:int):void;
		function writeBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void;
		function writeDouble (value:Number):void;
		function writeFloat (value:Number):void;
		function writeInt (value:int):void;
		function writeMultiByte (value:String, charSet:String):void;
		
		// #if (flash && !display)
		// function writeObject (object:Object):void;
		// #end
		
		function writeShort (value:int):void;
		function writeUTF (value:String):void;
		function writeUTFBytes (value:String):void;
		function writeUnsignedInt (value:uint):void;
		
	}
	
	
}
