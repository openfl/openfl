package openfl._v2.utils; #if lime_legacy


import openfl.geom.Matrix3D;

#if neko
import haxe.ds.Vector;
import openfl._v2.Vector.VectorData;
#end


class Float32Array extends ArrayBufferView implements ArrayAccess<Float> {
	
	
	static public inline var SBYTES_PER_ELEMENT = 4;
	
	public var BYTES_PER_ELEMENT (default, null):Int;
	public var length (default, null):Int;
	
	
	public function new (bufferOrArray:Dynamic, start:Int = 0, elements:Null<Int> = null) {
		
		BYTES_PER_ELEMENT = 4;
		
		if (Std.is (bufferOrArray, Int)) {
			
			super (Std.int (bufferOrArray) * BYTES_PER_ELEMENT);
			this.length = Std.int(bufferOrArray);
			
		} else if (Std.is (bufferOrArray, Array)) {
				
			var floats:Array<Float> = bufferOrArray;
			
			if (elements != null) {
				
				this.length = elements;
				
			} else {
				
				this.length = floats.length - start;
				
			}
			
			super (this.length << 2);
			
			#if !cpp
			buffer.position = 0;
			#end
			
			for (i in 0...this.length) {
				
				#if cpp
				untyped __global__.__hxcpp_memory_set_float (bytes, (i << 2), floats[i]);
				#else
				buffer.writeFloat (floats[i + start]);
				#end
				
			}
		
		#if neko
		
		} else if (Std.is (bufferOrArray, VectorData)) {
			
			var floats:Vector<Float> = bufferOrArray.data;
			
			if (elements != null) {
				
				this.length = elements;
				
			} else {
				
				this.length = floats.length - start;
				
			}
			
			super (this.length << 2);
			
			#if !cpp
			buffer.position = 0;
			#end
			
			for (i in 0...this.length) {
				
				#if cpp
				untyped __global__.__hxcpp_memory_set_float (bytes, (i << 2), floats[i]);
				#else
				buffer.writeFloat (floats[i + start]);
				#end
				
			}
		
		#end
			
		} else {
			
			super (bufferOrArray, start, elements != null ? elements * 4 : null);
			
			if ((byteLength & 0x03) > 0) {
				
				throw("Invalid array size");
				
			}
			
			this.length = byteLength >> 2;
			
			if ((this.length << 2) != byteLength) {
				
				throw "Invalid length multiple";
				
			}
			
		}
		
	}
	
	public inline function __setLength( nbFloat : Int) {
		length = nbFloat;
		byteLength = nbFloat << 2;
		buffer.setLength(byteLength);
	}
	
	public static function fromMatrix (matrix:Matrix3D):Float32Array {
		
		return new Float32Array (matrix.rawData);
		
	}
	
	
	@:noCompletion @:keep inline public function __get (index:Int):Float { return getFloat32 (index << 2); }
	@:noCompletion @:keep inline public function __set (index:Int, value:Float):Void { setFloat32 (index << 2, value); }
	
	
}


#end