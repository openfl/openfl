package openfl.printing; #if !openfljs


@:enum abstract PrintJobOrientation(Null<Int>) {
	
	public var LANDSCAPE = 0;
	public var PORTRAIT = 1;
	
	@:from private static function fromString (value:String):PrintJobOrientation {
		
		return switch (value) {
			
			case "landscape": LANDSCAPE;
			case "portrait": PORTRAIT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case PrintJobOrientation.LANDSCAPE: "landscape";
			case PrintJobOrientation.PORTRAIT: "portrait";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract PrintJobOrientation(String) from String to String {
	
	public var LANDSCAPE = "landscape";
	public var PORTRAIT = "portrait";
	
}


#end