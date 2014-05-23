package openfl.utils;


class Int16Array extends ArrayBufferView implements ArrayAccess<Int> {
	
	
	static public inline var SBYTES_PER_ELEMENT = 2;
	
	public var BYTES_PER_ELEMENT (default, null):Int;
	public var length (default, null):Int;
	
	
	public function new (bufferOrArray:Dynamic, start:Int = 0, length:Null<Int> = null) {
		
		BYTES_PER_ELEMENT = 2;
		
		if (Std.is (bufferOrArray, Int)) {
			
			super (Std.int (bufferOrArray) << 1);
			this.length = Std.int(bufferOrArray);
			
		} else if (Std.is (bufferOrArray, Array)) {
			
			var ints:Array<Int> = bufferOrArray;
			
			if (length != null) {
				
				this.length = length;
				
			} else {
				
				this.length = ints.length - start;
				
			}
			
			super (this.length << 1);
			
			buffer.position = 0;
			
			for (i in 0...this.length) {
				
				buffer.writeShort (ints[i + start]);
				
			}
			
		} else {
			
			super (bufferOrArray, start, length);
			
			if ((byteLength & 0x01) > 0) {
				
				throw ("Invalid array size");
				
			}
			
			this.length = byteLength >> 1;
			
			if ((this.length << 1) != byteLength) {
				
				throw "Invalid length multiple";
				
			}
			
		}
		
	}
	
	
	@:noCompletion @:keep inline public function __get (index:Int):Int { return getInt16 (index << 1); }
	@:noCompletion @:keep inline public function __set (index:Int, value:Int):Void { setInt16 (index << 1, value); }
	
	
}
