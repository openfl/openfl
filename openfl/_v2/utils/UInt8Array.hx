package openfl._v2.utils; #if lime_legacy


#if neko
import haxe.ds.Vector;
import openfl._v2.Vector.VectorData;
#end


class UInt8Array extends ArrayBufferView implements ArrayAccess<Int> {
	
	
	static public inline var SBYTES_PER_ELEMENT = 1;
	
	public var BYTES_PER_ELEMENT (default, null):Int;
	public var length (default, null):Int;
	
	
	public function new (bufferOrArray:Dynamic, start:Int = 0, elements:Null<Int> = null) {
		
		BYTES_PER_ELEMENT = 1;
		
		if (Std.is (bufferOrArray, Int)) {
			
			super (Std.int (bufferOrArray));
			this.length = Std.int(bufferOrArray);
			
		} else if (Std.is (bufferOrArray, Array)) {
			
			var ints:Array<Int> = bufferOrArray;
			
			if (elements != null) {
				
				this.length = elements;
				
			} else {
				
				this.length = ints.length - start;
				
			}
			
			super (this.length);
			
			#if !cpp
			buffer.position = 0;
			#end
			
			for (i in 0...this.length) {
				
				#if cpp
				untyped __global__.__hxcpp_memory_set_byte (bytes, i, ints[i + start]);
				#else
				buffer.writeByte(ints[i + start]);
				#end
				
			}
			
		#if neko
		
		} else if (Std.is (bufferOrArray, VectorData)) {
			
			var ints:Vector<Int> = bufferOrArray.data;
			
			if (elements != null) {
				
				this.length = elements;
				
			} else {
				
				this.length = ints.length - start;
				
			}
			
			super (this.length);
			
			#if !cpp
			buffer.position = 0;
			#end
			
			for (i in 0...this.length) {
				
				#if cpp
				untyped __global__.__hxcpp_memory_set_byte (bytes, i, ints[i + start]);
				#else
				buffer.writeByte(ints[i + start]);
				#end
				
			}
		
		#end
			
		} else {
			
			super (bufferOrArray, start, elements);
			this.length = byteLength;
			
		}
		
	}
	
	
	@:noCompletion @:keep inline public function __get (index:Int):Int { return getUInt8 (index); }
	@:noCompletion @:keep inline public function __set (index:Int, value:Int):Void { setUInt8 (index, value); }
	
	
}


#end