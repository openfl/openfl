package openfl.display; #if !openfl_legacy


@:enum abstract GradientType(Int) {
	
	public var LINEAR = 0;
	public var RADIAL = 1;
	
	@:from private static inline function fromString (value:String):GradientType {
		
		return switch (value) {
			
			case "radial": RADIAL;
			default: return LINEAR;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case GradientType.RADIAL: "radial";
			default: "linear";
			
		}
		
	}
	
}


#else
typedef GradientType = openfl._legacy.display.GradientType;
#end