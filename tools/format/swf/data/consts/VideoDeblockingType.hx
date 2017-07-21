package format.swf.data.consts;

class VideoDeblockingType
{
	public static inline var VIDEOPACKET:Int = 0;
	public static inline var OFF:Int = 1;
	public static inline var LEVEL1:Int = 2;
	public static inline var LEVEL2:Int = 3;
	public static inline var LEVEL3:Int = 4;
	public static inline var LEVEL4:Int = 5;
	
	public static function toString(deblockingType:Int):String {
		switch(deblockingType) {
			case VIDEOPACKET: return "videopacket";
			case OFF: return "off";
			case LEVEL1: return "level 1";
			case LEVEL2: return "level 2";
			case LEVEL3: return "level 3";
			case LEVEL4: return "level 4";
			default: return "unknown";
		}
	}
}