package openfl.utils;
#if display
import flash.geom.Matrix3D;


extern class Float32Array extends ArrayBufferView implements ArrayAccess<Float> {
	
	extern public function new (bufferOrArray:Dynamic, start:Int = 0, length:Null<Int> = null);
	extern public static function fromMatrix (matrix:Matrix3D):Float32Array;
	
}


#end