package format.swf.data.consts;

class SoundSize
{
	public static inline var BIT_8:Int = 0;
	public static inline var BIT_16:Int = 1;
	
	public static function toString(soundSize:Int):String {
		switch(soundSize) {
			case BIT_8: return "8bit";
			case BIT_16: return "16bit";
			default: return "unknown";
		}
	}
}