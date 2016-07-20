package openfl.display3D; #if (display || !flash)


@:enum abstract Context3DProgramType(Null<Int>) {
	
	public var FRAGMENT = 0;
	public var VERTEX = 1;
	
	@:from private static function fromString (value:String):Context3DProgramType {
		
		return switch (value) {
			
			case "fragment": FRAGMENT;
			case "vertex": VERTEX;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DProgramType.FRAGMENT: "fragment";
			case Context3DProgramType.VERTEX: "vertex";
			default: null;
			
		}
		
	}
	
}


#else
typedef Context3DProgramType = flash.display3D.Context3DProgramType;
#end