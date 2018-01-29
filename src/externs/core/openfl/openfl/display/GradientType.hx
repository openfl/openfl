package openfl.display; #if (display || !flash)


/**
 * The GradientType class provides values for the `type` parameter
 * in the `beginGradientFill()` and
 * `lineGradientStyle()` methods of the openfl.display.Graphics
 * class.
 */
@:enum abstract GradientType(Null<Int>) {
	
	/**
	 * Value used to specify a linear gradient fill.
	 */
	public var LINEAR = 0;
	
	/**
	 * Value used to specify a radial gradient fill.
	 */
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
typedef GradientType = flash.display.GradientType;
#end