package openfl.utils; #if (display || !flash)


import lime.system.Endian in LimeEndian;


/**
 * The Endian class contains values that denote the byte order used to
 * represent multibyte numbers. The byte order is either bigEndian(most
 * significant byte first) or littleEndian(least significant byte first).
 *
 * Content in Flash Player or Adobe<sup>®</sup> AIR™ can interface with
 * a server by using the binary protocol of that server, directly. Some
 * servers use the bigEndian byte order and some servers use the littleEndian
 * byte order. Most servers on the Internet use the bigEndian byte order
 * because "network byte order" is bigEndian. The littleEndian byte order is
 * popular because the Intel x86 architecture uses it. Use the endian byte
 * order that matches the protocol of the server that is sending or receiving
 * data.
 */
@:enum abstract Endian(Null<Int>) {
	
	
	public var BIG_ENDIAN = 0;
	public var LITTLE_ENDIAN = 1;
	
	
	@:from private static function fromLimeEndian (value:LimeEndian):Endian {
		
		return switch (value) {
			
			case LimeEndian.BIG_ENDIAN: BIG_ENDIAN;
			case LimeEndian.LITTLE_ENDIAN: LITTLE_ENDIAN;
			default: null;
			
		}
		
	}
	
	
	@:from private static function fromString (value:String):Endian {
		
		return switch (value) {
			
			case "bigEndian": BIG_ENDIAN;
			case "littleEndian": LITTLE_ENDIAN;
			default: null;
			
		}
		
	}
	
	
	@:to private static function toLimeEndian (value:Int):LimeEndian {
		
		return switch (value) {
			
			case Endian.BIG_ENDIAN: LimeEndian.BIG_ENDIAN;
			case Endian.LITTLE_ENDIAN: LimeEndian.LITTLE_ENDIAN;
			default: null;
			
		}
		
	}
	
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Endian.BIG_ENDIAN: "bigEndian";
			case Endian.LITTLE_ENDIAN: "littleEndian";
			default: null;
			
		}
		
	}
	
	
}


#else
typedef Endian = flash.utils.Endian;
#end