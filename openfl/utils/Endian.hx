package openfl.utils; #if !flash


class Endian {
	
	
	public static inline var BIG_ENDIAN:String = "bigEndian";
	public static inline var LITTLE_ENDIAN:String = "littleEndian";
	
	
}


#else
typedef Endian = flash.utils.Endian;
#end