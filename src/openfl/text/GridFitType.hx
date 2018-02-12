package openfl.text; #if !openfljs


@:enum abstract GridFitType(Null<Int>) {
	
	public var NONE = 0;
	public var PIXEL = 1;
	public var SUBPIXEL = 2;
	
	@:from private static function fromString (value:String):GridFitType {
		
		return switch (value) {
			
			case "none": NONE;
			case "pixel": PIXEL;
			case "subpixel": SUBPIXEL;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case GridFitType.NONE: "none";
			case GridFitType.PIXEL: "pixel";
			case GridFitType.SUBPIXEL: "subpixel";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract GridFitType(String) from String to String {
	
	public var NONE = "none";
	public var PIXEL = "pixel";
	public var SUBPIXEL = "subpixel";
	
}


#end