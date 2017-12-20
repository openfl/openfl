package openfl.display3D; #if (display || !flash)


@:enum abstract Context3DMipFilter(Null<Int>) {
	
	public var MIPLINEAR = 0;
	public var MIPNEAREST = 1;
	public var MIPNONE = 2;
	
	@:from private static function fromString (value:String):Context3DMipFilter {
		
		return switch (value) {
			
			case "miplinear": MIPLINEAR;
			case "mipnearest": MIPNEAREST;
			case "mipnone": MIPNONE;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DMipFilter.MIPLINEAR: "miplinear";
			case Context3DMipFilter.MIPNEAREST: "mipnearest";
			case Context3DMipFilter.MIPNONE: "mipnone";
			default: null;
			
		}
		
	}
	
}


#else
typedef Context3DMipFilter = flash.display3D.Context3DMipFilter;
#end