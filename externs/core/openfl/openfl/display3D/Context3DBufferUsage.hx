package openfl.display3D; #if (display || !flash)


@:enum abstract Context3DBufferUsage(Null<Int>) {
	
	public var DYNAMIC_DRAW = 0;
	public var STATIC_DRAW = 1;
	
	@:from private static function fromString (value:String):Context3DBufferUsage {
		
		return switch (value) {
			
			case "dynamicDraw": DYNAMIC_DRAW;
			case "staticDraw": STATIC_DRAW;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DBufferUsage.DYNAMIC_DRAW: "dynamicDraw";
			case Context3DBufferUsage.STATIC_DRAW: "staticDraw";
			default: null;
			
		}
		
	}
	
}


#else
typedef Context3DBufferUsage = flash.display3D.Context3DBufferUsage;
#end