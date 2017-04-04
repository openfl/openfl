package format.swf.data.consts;

import flash.display.SpreadMethod;

class GradientSpreadMode
{
	public static inline var PAD:Int = 0;
	public static inline var REFLECT:Int = 1;
	public static inline var REPEAT:Int = 2;
	
	public static function toEnum(spreadMode:Int):SpreadMethod {
		switch(spreadMode) {
			case PAD: return SpreadMethod.PAD;
			case REFLECT: return SpreadMethod.REFLECT;
			case REPEAT: return SpreadMethod.REPEAT;
			default: return SpreadMethod.PAD;
		}
	}
	
	public static function toString(spreadMode:Int):String {
		switch(spreadMode) {
			case PAD: return Std.string (SpreadMethod.PAD).toLowerCase ();
			case REFLECT: return Std.string (SpreadMethod.REFLECT).toLowerCase ();
			case REPEAT: return Std.string (SpreadMethod.REPEAT).toLowerCase ();
			default: return "unknown";
		}
	}
}