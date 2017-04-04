package format.swf.data.consts;

class SoundRate
{
	public static inline var KHZ_5:Int = 0;
	public static inline var KHZ_11:Int = 1;
	public static inline var KHZ_22:Int = 2;
	public static inline var KHZ_44:Int = 3;
	
	public static function toString(soundRate:Int):String {
		switch(soundRate) {
			case KHZ_5: return "5.5kHz";
			case KHZ_11: return "11kHz";
			case KHZ_22: return "22kHz";
			case KHZ_44: return "44kHz";
			default: return "unknown";
		}
	}
}