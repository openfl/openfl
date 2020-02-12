package flash.net {
	
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	
	/**
	 * @externs
	 */
	public class Socket extends EventDispatcher implements IDataInput, IDataOutput {
		
		
		public function get bytesAvailable ():uint { return 0; }
		
		protected function get_bytesAvailable ():uint { return 0; }
		
		public function get bytesPending ():uint { return 0; }
		
		protected function get_bytesPending ():uint { return 0; }
		
		public function get connected ():Boolean { return false; }
		
		protected function get_connected ():Boolean { return false; }
		
		public function get endian ():String { return null; }
		public function set endian (value:String):void {}
		// public var endian:String;
		
		protected function get_endian ():String { return null; }
		protected function set_endian (value:String):String { return null; }
		
		public function get objectEncoding ():uint { return null; }
		public function set objectEncoding (value:uint):void {}
		// public var objectEncoding:uint;
		public var timeout:uint;
		
		public function Socket (host:String = null, port:int = 0) {}
		public function close ():void {}
		public function connect (host:String = null, port:int = 0):void {}
		public function flush ():void {}
		public function readBoolean ():Boolean { return false; }
		public function readByte ():int { return 0; }
		public function readBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void {}
		public function readDouble ():Number { return 0; }
		public function readFloat ():Number { return 0; }
		public function readInt ():int { return 0; }
		public function readMultiByte (length:uint, charSet:String):String { return null; }
		
		// #if flash
		// @:noCompletion @:dox(hide) public function readObject ():Dynamic;
		// #end
		
		public function readShort ():int { return 0; }
		public function readUnsignedByte ():uint { return 0; }
		public function readUnsignedInt ():uint { return 0; }
		public function readUnsignedShort ():uint { return 0; }
		public function readUTF ():String { return null; }
		public function readUTFBytes (length:uint):String { return null; }
		public function writeBoolean (value:Boolean):void {}
		public function writeByte (value:int):void {}
		public function writeBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void {}
		public function writeDouble (value:Number):void {}
		public function writeFloat (value:Number):void {}
		public function writeInt (value:int):void {}
		public function writeMultiByte (value:String, charSet:String):void {}
		
		// #if flash
		// @:noCompletion @:dox(hide) public function writeObject (object:Dynamic):void {}
		// #end
		
		public function writeShort (value:int):void {}
		public function writeUnsignedInt (value:uint):void {}
		public function writeUTF (value:String):void {}
		public function writeUTFBytes (value:String):void {}
		
		
	}
	
	
}