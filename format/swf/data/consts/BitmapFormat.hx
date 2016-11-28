package format.swf.data.consts;

class BitmapFormat
{
	public static inline var BIT_8:Int = 3;
	public static inline var BIT_15:Int = 4;
	public static inline var BIT_24:Int = 5;
	
	public static function toString(bitmapFormat:Int):String {
		switch(bitmapFormat) {
			case BIT_8: return "8 BPP";
			case BIT_15: return "15 BPP";
			case BIT_24: return "24 BPP";
			default: return "unknown";
		}
	}
}