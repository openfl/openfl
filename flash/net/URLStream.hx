package flash.net;


#if flash

extern class URLStream extends flash.events.EventDispatcher implements flash.utils.IDataInput {
	var bytesAvailable(default,null) : Int;
	var connected(default,null) : Bool;
	@:require(flash11_4) var diskCacheEnabled(default,null) : Bool;
	var endian : flash.utils.Endian;
	@:require(flash11_4) var length(default,null) : Float;
	var objectEncoding : Int;
	@:require(flash11_4) var position : Float;
	function new() : Void;
	function close() : Void;
	function load(request : URLRequest) : Void;
	function readBoolean() : Bool;
	function readByte() : Int;
	function readBytes(bytes : flash.utils.ByteArray, offset : Int = 0, length : Int = 0) : Void;
	function readDouble() : Float;
	function readFloat() : Float;
	function readInt() : Int;
	function readMultiByte(length : Int, charSet : String) : String;
	function readObject() : Dynamic;
	function readShort() : Int;
	function readUTF() : String;
	function readUTFBytes(length : Int) : String;
	function readUnsignedByte() : Int;
	function readUnsignedInt() : Int;
	function readUnsignedShort() : Int;
	@:require(flash11_4) function stop() : Void;
}

#end