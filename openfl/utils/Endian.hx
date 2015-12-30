package openfl.utils;


@:enum abstract Endian(Int) {
	
	public var BIG_ENDIAN = 0;
	public var LITTLE_ENDIAN = 1;
	
	@:from private static inline function fromString (value:String):Endian {
		
		return switch (value) {
			
			case "littleEndian": LITTLE_ENDIAN;
			default: return BIG_ENDIAN;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case Endian.LITTLE_ENDIAN: "littleEndian";
			default: "bigEndian";
			
		}
		
	}
	
}