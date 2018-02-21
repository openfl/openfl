package openfl.text;


@:enum abstract TextFieldAutoSize(Null<Int>) {
	
	public var CENTER = 0;
	public var LEFT = 1;
	public var NONE = 2;
	public var RIGHT = 3;
	
	@:from private static function fromString (value:String):TextFieldAutoSize {
		
		return switch (value) {
			
			case "center": CENTER;
			case "left": LEFT;
			case "none": NONE;
			case "right": RIGHT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case TextFieldAutoSize.CENTER: "center";
			case TextFieldAutoSize.LEFT: "left";
			case TextFieldAutoSize.NONE: "none";
			case TextFieldAutoSize.RIGHT: "right";
			default: null;
			
		}
		
	}
	
}