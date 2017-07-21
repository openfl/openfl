package format.swf.data.consts;

class CSMTableHint
{
	public static inline var THIN:Int = 0;
	public static inline var MEDIUM:Int = 1;
	public static inline var THICK:Int = 2;
	
	public static function toString(csmTableHint:Int):String {
		switch(csmTableHint) {
			case THIN: return "thin";
			case MEDIUM: return "medium";
			case THICK: return "thick";
			default: return "unknown";
		}
	}
}