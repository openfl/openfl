package openfl.utils;


@:enum abstract Endian(Null<Int>) {
	
	public var BIG_ENDIAN = 0;
	public var LITTLE_ENDIAN = 1;
	
	@:from private static function fromString (value:String):Endian {
		
		return switch (value) {
			
			case "bigEndian": BIG_ENDIAN;
			case "littleEndian": LITTLE_ENDIAN;
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