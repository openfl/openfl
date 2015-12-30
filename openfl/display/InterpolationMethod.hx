package openfl.display; #if !openfl_legacy


@:enum abstract InterpolationMethod(Int) {
	
	public var LINEAR_RGB = 0;
	public var RGB = 1;
	
	@:from private static inline function fromString (value:String):InterpolationMethod {
		
		return switch (value) {
			
			case "linearRGB": LINEAR_RGB;
			default: return RGB;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case InterpolationMethod.LINEAR_RGB: "linearRGB";
			default: "rgb";
			
		}
		
	}
	
}


#else
typedef InterpolationMethod = openfl._legacy.display.InterpolationMethod;
#end