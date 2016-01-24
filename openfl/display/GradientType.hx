package openfl.display; #if !openfl_legacy


@:enum abstract GradientType(Null<Int>) {
	
	public var LINEAR = 0;
	public var RADIAL = 1;
	
	@:from private static function fromString (value:String):GradientType {
		
		return switch (value) {
			
			case "linear": LINEAR;
			case "radial": RADIAL;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case GradientType.LINEAR: "linear";
			case GradientType.RADIAL: "radial";
			default: null;
			
		}
		
	}
	
}


#else
typedef GradientType = openfl._legacy.display.GradientType;
#end