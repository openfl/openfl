package openfl.utils;


import lime.system.Endian in LimeEndian;


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
	
	
	@:to private function toLimeEndian ():LimeEndian {
		
		return switch (cast this) {
			
			case Endian.BIG_ENDIAN: LimeEndian.BIG_ENDIAN;
			case Endian.LITTLE_ENDIAN: LimeEndian.LITTLE_ENDIAN;
			default: null;
			
		}
		
	}
	
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case Endian.BIG_ENDIAN: "bigEndian";
			case Endian.LITTLE_ENDIAN: "littleEndian";
			default: null;
			
		}
		
	}
	
	
}