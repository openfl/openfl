package openfl.text;


@:enum abstract GridFitType(Int) {
	
	public var NONE = 0;
	public var PIXEL = 1;
	public var SUBPIXEL = 2;
	
	@:from private static inline function fromString (value:String):GridFitType {
		
		return switch (value) {
			
			case "none": NONE;
			case "subpixel": SUBPIXEL;
			default: return PIXEL;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case GridFitType.NONE: "none";
			case GridFitType.SUBPIXEL: "subpixel";
			default: "pixel";
			
		}
		
	}
	
}