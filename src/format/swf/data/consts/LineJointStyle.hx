package format.swf.data.consts;

import flash.display.JointStyle;

class LineJointStyle
{
	public static inline var ROUND:Int = 0;
	public static inline var BEVEL:Int = 1;
	public static inline var MITER:Int = 2;
	
	public static function toEnum(lineJointStyle:Int):JointStyle {
		switch(lineJointStyle) {
			case ROUND: return JointStyle.ROUND;
			case BEVEL: return JointStyle.BEVEL;
			case MITER: return JointStyle.MITER;
			default: return JointStyle.ROUND;
		}
	}
	
	public static function toString(lineJointStyle:Int):String {
		switch(lineJointStyle) {
			case ROUND: return Std.string (JointStyle.ROUND).toLowerCase ();
			case BEVEL: return Std.string (JointStyle.BEVEL).toLowerCase ();
			case MITER: return Std.string (JointStyle.MITER).toLowerCase ();
			default: return "null";
		}
	}
}