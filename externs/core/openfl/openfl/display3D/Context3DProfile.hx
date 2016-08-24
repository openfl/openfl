package openfl.display3D; #if (display || !flash)


@:enum abstract Context3DProfile(Null<Int>) {
	
	public var BASELINE = 0;
	public var BASELINE_CONSTRAINED = 1;
	public var BASELINE_EXTENDED = 2;
	public var STANDARD = 3;
	public var STANDARD_CONSTRAINED = 4;
	
	@:from private static function fromString (value:String):Context3DProfile {
		
		return switch (value) {
			
			case "baseline": BASELINE;
			case "baselineConstrained": BASELINE_CONSTRAINED;
			case "baselineExtended": BASELINE_EXTENDED;
			case "standard": STANDARD;
			case "standardConstrained": STANDARD_CONSTRAINED;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DProfile.BASELINE: "baseline";
			case Context3DProfile.BASELINE_CONSTRAINED: "baselineConstrained";
			case Context3DProfile.BASELINE_EXTENDED: "baselineExtended";
			case Context3DProfile.STANDARD: "standard";
			case Context3DProfile.STANDARD_CONSTRAINED: "standardConstrained";
			default: null;
			
		}
		
	}
	
}


#else
typedef Context3DProfile = flash.display3D.Context3DProfile;
#end