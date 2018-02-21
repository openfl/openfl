package openfl.text; #if !openfljs


@:enum abstract TextFormatAlign(Null<Int>) {
	
	public var CENTER = 0;
	public var END = 1;
	public var JUSTIFY = 2;
	public var LEFT = 3;
	public var RIGHT = 4;
	public var START = 5;
	
	@:from private static function fromString (value:String):TextFormatAlign {
		
		return switch (value) {
			
			case "center": CENTER;
			case "end": END;
			case "justify": JUSTIFY;
			case "left": LEFT;
			case "right": RIGHT;
			case "start": START;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case TextFormatAlign.CENTER: "center";
			case TextFormatAlign.END: "end";
			case TextFormatAlign.JUSTIFY: "justify";
			case TextFormatAlign.LEFT: "left";
			case TextFormatAlign.RIGHT: "right";
			case TextFormatAlign.START: "start";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract TextFormatAlign(String) from String to String {
	
	public var CENTER = "center";
	public var END = "end";
	public var JUSTIFY = "justify";
	public var LEFT = "left";
	public var RIGHT = "right";
	public var START = "start";
	
}


#end