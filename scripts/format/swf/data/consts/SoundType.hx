package format.swf.data.consts;

class SoundType
{
	public static inline var MONO:Int = 0;
	public static inline var STEREO:Int = 1;
	
	public static function toString(soundType:Int):String {
		switch(soundType) {
			case MONO: return "mono";
			case STEREO: return "stereo";
			default: return "unknown";
		}
	}
}