package format.swf.data.consts;

class BlendMode
{
	public static inline var NORMAL_0:Int = 0;
	public static inline var NORMAL_1:Int = 1;
	public static inline var LAYER:Int = 2;
	public static inline var MULTIPLY:Int = 3;
	public static inline var SCREEN:Int = 4;
	public static inline var LIGHTEN:Int = 5;
	public static inline var DARKEN:Int = 6;
	public static inline var DIFFERENCE:Int = 7;
	public static inline var ADD:Int = 8;
	public static inline var SUBTRACT:Int = 9;
	public static inline var INVERT:Int = 10;
	public static inline var ALPHA:Int = 11;
	public static inline var ERASE:Int = 12;
	public static inline var OVERLAY:Int = 13;
	public static inline var HARDLIGHT:Int = 14;
	
	public static function toString(blendMode:Int):String {
		switch(blendMode) {
			case NORMAL_0, NORMAL_1: 
				return "normal";
			case LAYER: return "layer";
			case MULTIPLY: return "multiply";
			case SCREEN: return "screen";
			case LIGHTEN: return "lighten";
			case DARKEN: return "darken";
			case DIFFERENCE: return "difference";
			case ADD: return "add";
			case SUBTRACT: return "subtract";
			case INVERT: return "invert";
			case ALPHA: return "alpha";
			case ERASE: return "erase";
			case OVERLAY: return "overlay";
			case HARDLIGHT: return "hardlight";
			default: return "unknown";
		}
	}
}