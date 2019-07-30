package openfl.text; #if (display || !flash)


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
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case GridFitType.NONE: "none";
			case GridFitType.PIXEL: "pixel";
			case GridFitType.SUBPIXEL: "subpixel";
			default: null;
			
		}
		
	}
	
}


#else
typedef GridFitType = flash.text.GridFitType;
#end