package format.swf.data.consts;

import flash.display.InterpolationMethod;

class GradientInterpolationMode
{
	public static inline var NORMAL:Int = 0;
	public static inline var LINEAR:Int = 1;
	
	public static function toEnum(interpolationMode:Int):InterpolationMethod {
		switch(interpolationMode) {
			case NORMAL: return InterpolationMethod.RGB;
			case LINEAR: return InterpolationMethod.LINEAR_RGB;
			default: return InterpolationMethod.RGB;
		}
	}
	
	public static function toString(interpolationMode:Int):String {
		switch(interpolationMode) {
			case NORMAL: return Std.string (InterpolationMethod.RGB).toLowerCase ();
			case LINEAR: return Std.string (InterpolationMethod.LINEAR_RGB).toLowerCase ();
			default: return Std.string (InterpolationMethod.RGB).toLowerCase ();
		}
	}
}