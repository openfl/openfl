package openfl.utils;


import openfl.utils.ByteArray;


class ArrayBufferView {
	
	
	public var buffer (default, null):ByteArray;
	public var byteOffset (default, null):Int;
	public var byteLength (default, null):Int;
	
	private static var invalidDataIndex = "Invalid data index";
	
	
	private function new (lengthOrBuffer:Dynamic, byteOffset:UInt = 0, length:Null<Int> = null) {
		
		if (Std.is (lengthOrBuffer, Int)) {
			
			byteLength = Std.int (lengthOrBuffer);
			this.byteOffset = 0;
			buffer = new ArrayBuffer ();
			
			while (byteLength > 0) {
				
				buffer.writeByte (0);
				byteLength--;
			}
			
			buffer.position = 0;
			
		} else {
			
			buffer = lengthOrBuffer;
			
			if (buffer == null) {
				
				throw ("Invalid input buffer");
				
			}
			
			this.byteOffset = byteOffset;
			
			if (byteOffset > buffer.length) {
				
				throw ("Invalid starting position");
				
			}
			
			if (length == null) {
				
				byteLength = buffer.length - byteOffset;
				
			} else {
				
				byteLength = length;
				
				if (byteLength + byteOffset > buffer.length) {
					
					throw ("Invalid buffer length");
					
				}
				
			}
			
		}
		
	}
	
	
	public function getByteBuffer ():ByteArray {
		
		return buffer;
		
	}
	
	
	inline public function getFloat32 (position:Int):Float {
		
		buffer.position = position + byteOffset;
		return buffer.readFloat ();
		
	}
	
	
	inline public function getInt16 (position:Int):Int {
		
		buffer.position = position + byteOffset;
		return buffer.readShort ();
		
	}
	
	
	inline public function getInt32 (position:Int):Int {
		
		buffer.position = position + byteOffset;
		return buffer.readInt ();
		
	}
	
	
	public function getLength ():Int {
		
		return byteLength;
		
	}
	
	
	public function getStart ():Int {
		
		return byteOffset;
		
	}
	
	
	inline public function getUInt8 (position:Int):Int {
		
		buffer.position = position + byteOffset;
		return buffer.readByte ();
		
	}
	
	
	inline public function setFloat32 (position:Int, value:Float):Void {
		
		buffer.position = position + byteOffset;
		buffer.writeFloat (value);
		
	}
	
	
	inline public function setInt16 (position:Int, value:Int):Void {
		
		buffer.position = position + byteOffset;
		buffer.writeShort (Std.int (value));
		
	}
	
	
	inline public function setInt32 (position:Int, value:Int):Void {
		
		buffer.position = position + byteOffset;
		buffer.writeInt (Std.int (value));
		
	}
	
	
	inline public function setUInt8 (position:Int, value:Int):Void {
		
		buffer.position = position + byteOffset;
		buffer.writeByte (value);
		
	}
	
	
}
