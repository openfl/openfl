package openfl.display3D; #if (display || !flash)


@:enum abstract Context3DTriangleFace(Null<Int>) {
	
	public var BACK = 0;
	public var FRONT = 1;
	public var FRONT_AND_BACK = 2;
	public var NONE = 3;
	
	@:from private static function fromString (value:String):Context3DTriangleFace {
		
		return switch (value) {
			
			case "back": BACK;
			case "front": FRONT;
			case "frontAndBack": FRONT_AND_BACK;
			case "none": NONE;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DTriangleFace.BACK: "back";
			case Context3DTriangleFace.FRONT: "front";
			case Context3DTriangleFace.FRONT_AND_BACK: "frontAndBack";
			case Context3DTriangleFace.NONE: "none";
			default: null;
			
		}
		
	}
	
}


#else
typedef Context3DTriangleFace = flash.display3D.Context3DTriangleFace;
#end