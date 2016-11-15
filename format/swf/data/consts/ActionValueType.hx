package format.swf.data.consts;

class ActionValueType
{
	public static inline var STRING:Int = 0;
	public static inline var FLOAT:Int = 1;
	public static inline var NULL:Int = 2;
	public static inline var UNDEFINED:Int = 3;
	public static inline var REGISTER:Int = 4;
	public static inline var BOOLEAN:Int = 5;
	public static inline var DOUBLE:Int = 6;
	public static inline var INTEGER:Int = 7;
	public static inline var CONSTANT_8:Int = 8;
	public static inline var CONSTANT_16:Int = 9;
	
	public static function toString(bitmapFormat:Int):String {
		switch(bitmapFormat) {
			case STRING: return "string";
			case FLOAT: return "float";
			case NULL: return "null";
			case UNDEFINED: return "undefined";
			case REGISTER: return "register";
			case BOOLEAN: return "boolean";
			case DOUBLE: return "double";
			case INTEGER: return "integer";
			case CONSTANT_8: return "constant8";
			case CONSTANT_16: return "constant16";
			default: return "unknown";
		}
	}
}