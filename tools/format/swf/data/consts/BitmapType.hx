package format.swf.data.consts;

class BitmapType
{
	public static inline var JPEG:Int = 1;
	public static inline var GIF89A:Int = 2;
	public static inline var PNG:Int = 3;
	
	public static function toString(bitmapFormat:Int):String {
		switch(bitmapFormat) {
			case JPEG: return "JPEG";
			case GIF89A: return "GIF89a";
			case PNG: return "PNG";
			default: return "unknown";
		}
	}
}