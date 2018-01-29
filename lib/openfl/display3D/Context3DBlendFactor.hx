package openfl.display3D; #if (display || !flash)


@:enum abstract Context3DBlendFactor(Null<Int>) {
	
	public var DESTINATION_ALPHA = 0;
	public var DESTINATION_COLOR = 1;
	public var ONE = 2;
	public var ONE_MINUS_DESTINATION_ALPHA = 3;
	public var ONE_MINUS_DESTINATION_COLOR = 4;
	public var ONE_MINUS_SOURCE_ALPHA = 5;
	public var ONE_MINUS_SOURCE_COLOR = 6;
	public var SOURCE_ALPHA = 7;
	public var SOURCE_COLOR = 8;
	public var ZERO = 9;
	
	@:from private static function fromString (value:String):Context3DBlendFactor {
		
		return switch (value) {
			
			case "destinationAlpha": DESTINATION_ALPHA;
			case "destinationColor": DESTINATION_COLOR;
			case "one": ONE;
			case "oneMinusDestinationAlpha": ONE_MINUS_DESTINATION_ALPHA;
			case "oneMinusDestinationColor": ONE_MINUS_DESTINATION_COLOR;
			case "oneMinusSourceAlpha": ONE_MINUS_SOURCE_ALPHA;
			case "oneMinusSourceColor": ONE_MINUS_SOURCE_COLOR;
			case "sourceAlpha": SOURCE_ALPHA;
			case "sourceColor": SOURCE_COLOR;
			case "zero": ZERO;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DBlendFactor.DESTINATION_ALPHA: "destinationAlpha";
			case Context3DBlendFactor.DESTINATION_COLOR: "destinationColor";
			case Context3DBlendFactor.ONE: "one";
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA: "oneMinusDestinationAlpha";
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR: "oneMinusDestinationColor";
			case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA: "oneMinusSourceAlpha";
			case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR: "oneMinusSourceColor";
			case Context3DBlendFactor.SOURCE_ALPHA: "sourceAlpha";
			case Context3DBlendFactor.SOURCE_COLOR: "sourceColor";
			case Context3DBlendFactor.ZERO: "zero";
			default: null;
			
		}
		
	}
	
}


#else
typedef Context3DBlendFactor = flash.display3D.Context3DBlendFactor;
#end