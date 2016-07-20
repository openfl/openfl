package flash.utils; #if (!display && flash)


@:enum abstract Endian(String) from String to String {
	
	public var BIG_ENDIAN = "bigEndian";
	public var LITTLE_ENDIAN = "littleEndian";
	
}


#else
typedef Endian = openfl.utils.Endian;
#end