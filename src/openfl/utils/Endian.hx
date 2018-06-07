package openfl.utils; #if !openfljs


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


import lime.system.Endian in LimeEndian;


@:enum abstract Endian(String) from String to String {
	
	
	public var BIG_ENDIAN = "bigEndian";
	public var LITTLE_ENDIAN = "littleEndian";
	
	
	@:from private static function fromLimeEndian (value:LimeEndian):Endian {
		
		return switch (value) {
			
			case LimeEndian.BIG_ENDIAN: BIG_ENDIAN;
			case LimeEndian.LITTLE_ENDIAN: LITTLE_ENDIAN;
			default: null;
			
		}
		
	}
	
	
	@:to private static function toLimeEndian (value:String):LimeEndian {
		
		return switch (value) {
			
			case Endian.BIG_ENDIAN: LimeEndian.BIG_ENDIAN;
			case Endian.LITTLE_ENDIAN: LimeEndian.LITTLE_ENDIAN;
			default: null;
			
		}
		
	}
	
	
}


#end