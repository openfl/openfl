package openfl._internal.renderer.context3D.batcher;

@SuppressWarnings("checkstyle:FieldDocComment")
class BitHacks
{
	// http://graphics.stanford.edu/~seander/bithacks.html#IntegerLog
	public static function log2(v:Int):Int
	{
		var r, shift;
		r = if (v > 0xFFFF) 1 << 4 else 0;
		v >>>= r;
		shift = if (v > 0xFF) 1 << 3 else 0;
		v >>>= shift;
		r |= shift;
		shift = if (v > 0xF) 1 << 2 else 0;
		v >>>= shift;
		r |= shift;
		shift = if (v > 0x3) 1 << 1 else 0;
		v >>>= shift;
		r |= shift;
		return r | (v >> 1);
	}

	// http://graphics.stanford.edu/~seander/bithacks.html#RoundUpPowerOf2
	public static function nextPow2(v:Int):Int
	{
		v--;
		v |= v >>> 1;
		v |= v >>> 2;
		v |= v >>> 4;
		v |= v >>> 8;
		v |= v >>> 16;
		return v + 1;
	}
}
