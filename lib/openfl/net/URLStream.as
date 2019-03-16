package openfl.net {
	
	
	import openfl.events.EventDispatcher;
	import openfl.utils.ByteArray;
	import openfl.utils.Endian;
	import openfl.utils.IDataInput;
	
	
	/**
	 * @externs
	 */
	public class URLStream extends EventDispatcher implements IDataInput {
		
		
		public function get bytesAvailable ():uint { return 0; }
		
		protected function get_bytesAvailable ():uint { return 0; }
		
		public function get connected ():Boolean { return false; }
		
		//@:require(flash11_4) public var diskCacheEnabled (default, null):Bool;
		
		public function get endian ():String { return null; }
		public function set endian (value:String):void {}
		// public var endian:String;
		
		protected function get_endian ():String { return null; }
		protected function set_endian (value:String):String { return null; }
		
		//@:require(flash11_4) public var length (default, null):Float;
		
		public function get objectEncoding ():uint { return null; }
		public function set objectEncoding (value:uint):void {}
		// public var objectEncoding:uint;
		//@:require(flash11_4) public var position:Float;
		
		public function new ():void {}
		public function close ():void {}
		public function load (request:URLRequest):void {}
		public function readBoolean ():Boolean { return false; }
		public function readByte ():int { return 0; }
		public function readBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void {}
		public function readDouble ():Number { return 0; }
		public function readFloat ():Number { return 0; }
		public function readInt ():int { return 0; }
		public function readMultiByte (length:uint, charSet:String):String { return null; }
		public function readObject ():Object { return null; }
		public function readShort ():int { return 0; }
		public function readUTF ():String { return null; }
		public function readUTFBytes (length:uint):String { return null; }
		public function readUnsignedByte ():uint { return 0; }
		public function readUnsignedInt ():uint { return 0; }
		public function readUnsignedShort ():uint { return 0; }
		//@:require(flash11_4) public function stop ():void {}
		
	}
	
	
}