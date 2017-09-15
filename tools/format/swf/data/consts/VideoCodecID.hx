package format.swf.data.consts;

class VideoCodecID
{
	public static inline var H263:Int = 2;
	public static inline var SCREEN:Int = 3;
	public static inline var VP6:Int = 4;
	public static inline var VP6ALPHA:Int = 5;
	public static inline var SCREENV2:Int = 6;
	
	public static function toString(codecId:Int):String {
		switch(codecId) {
			case H263: return "H.263";
			case SCREEN: return "Screen Video";
			case VP6: return "VP6";
			case VP6ALPHA: return "VP6 With Alpha";
			case SCREENV2: return "Screen Video V2";
			default: return "unknown";
		}
	}
}