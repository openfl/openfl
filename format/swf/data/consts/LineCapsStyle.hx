package format.swf.data.consts;

import flash.display.CapsStyle;

class LineCapsStyle
{
	public static inline var ROUND:Int = 0;
	public static inline var NO:Int = 1;
	public static inline var SQUARE:Int = 2;
	
	public static function toEnum(lineCapsStyle:Int):CapsStyle {
		switch(lineCapsStyle) {
			case ROUND: CapsStyle.ROUND;
			case NO: CapsStyle.NONE;
			case SQUARE: CapsStyle.SQUARE;
		}
		return CapsStyle.ROUND;
	}
	
	public static function toString(lineCapsStyle:Int):String {
		switch(lineCapsStyle) {
			case ROUND: return Std.string (CapsStyle.ROUND).toLowerCase ();
			case NO: return Std.string (CapsStyle.NONE).toLowerCase ();
			case SQUARE: return Std.string (CapsStyle.SQUARE).toLowerCase ();
			default: return "unknown";
		}
	}
}