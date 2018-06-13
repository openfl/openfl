package openfl._internal.renderer.kha;


class KhaUtils {

	public static inline function convertMatrix (matrix:Array<Float>):kha.math.FastMatrix4 {
		
		var m = kha.math.FastMatrix4.identity();

		m._00 = matrix[ 0];
		m._01 = matrix[ 1];
		m._02 = matrix[ 2];
		m._03 = matrix[ 3];

		m._10 = matrix[ 4];
		m._11 = matrix[ 5];
		m._12 = matrix[ 6];
		m._13 = matrix[ 7];

		m._20 = matrix[ 8];
		m._21 = matrix[ 9];
		m._22 = matrix[10];
		m._23 = matrix[11];

		m._30 = matrix[12];
		m._31 = matrix[13];
		m._32 = matrix[14];
		m._33 = matrix[15];

		return m;

	}
}
