package openfl.utils;


@:arrayAccess
class Int32Array extends ArrayBufferView implements ArrayAccess<Int> {
	
	
	static public inline var SBYTES_PER_ELEMENT = 4;
	
	public var BYTES_PER_ELEMENT (default, null):Int;
	public var length (default, null):Int;
	
	
	public function new (bufferOrArray:Dynamic, start:Int = 0, length:Null<Int> = null) {
		
		BYTES_PER_ELEMENT = 4;
		
		if (Std.is (bufferOrArray, Int)) {
			
			super (Std.int (bufferOrArray) << 2);
			this.length = Std.int(bufferOrArray);
			
		} else if (Std.is (bufferOrArray, Array)) {
			
			var ints:Array<Int> = bufferOrArray;
			
			if (length != null) {
				
				this.length = length;
				
			} else {
				
				this.length = ints.length - start;
				
			}
			
			super (this.length << 2);
			
			#if !cpp
			buffer.position = 0;
			#end
			
			for (i in 0...this.length) {
				
				#if cpp
				untyped __global__.__hxcpp_memory_set_i32 (bytes, (i << 2), ints[i]);
				#else
				buffer.writeInt (ints[i + start]);
				#end
				
			}
			
		} else {
			
			super (bufferOrArray, start, length);
			
			if ((byteLength & 0x03) > 0) {
				
				throw ("Invalid array size");
				
			}
			
			this.length = byteLength >> 2;
			
			if ((this.length << 2) != byteLength) {
				
				throw "Invalid length multiple";
				
			}
			
		}
		
	}
	
	
	@:noCompletion @:keep inline public function __get (index:Int):Int { return getInt32 (index << 2); }
	@:noCompletion @:keep inline public function __set (index:Int, value:Int):Void { setInt32 (index << 2, value); }
	
	
}
