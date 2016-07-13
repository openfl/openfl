package openfl.display3D;


@:enum abstract Context3DRenderMode(Null<Int>) {
	
	public var AUTO = 0;
	public var SOFTWARE = 1;
	
	@:from private static function fromString (value:String):Context3DRenderMode {
		
		return switch (value) {
			
			case "auto": AUTO;
			case "software": SOFTWARE;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DRenderMode.AUTO: "auto";
			case Context3DRenderMode.SOFTWARE: "software";
			default: null;
			
		}
		
	}
	
}