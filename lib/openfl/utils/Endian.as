package openfl.utils {
	
	
	// import lime.system.Endian in LimeEndian;
	
	
	/**
	 * @externs
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
	final public class Endian {
		
		
		public static const BIG_ENDIAN:String = "bigEndian";
		public static const LITTLE_ENDIAN:String = "littleEndian";
		
		
		// @:from private static function fromLimeEndian (value:LimeEndian):Endian {
			
		// 	return switch (value) {
				
		// 		case LimeEndian.BIG_ENDIAN: BIG_ENDIAN;
		// 		case LimeEndian.LITTLE_ENDIAN: LITTLE_ENDIAN;
		// 		default: null;
				
		// 	}
			
		// }
		
		
		// @:to private static function toLimeEndian (value:String):LimeEndian {
			
		// 	return switch (value) {
				
		// 		case Endian.BIG_ENDIAN: LimeEndian.BIG_ENDIAN;
		// 		case Endian.LITTLE_ENDIAN: LimeEndian.LITTLE_ENDIAN;
		// 		default: null;
				
		// 	}
			
		// }
		
		
	}
	
	
}