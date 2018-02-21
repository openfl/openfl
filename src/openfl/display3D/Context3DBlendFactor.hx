package openfl.display3D; #if !openfljs


#if cs
import openfl._internal.utils.NullUtils;
#end


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
	
	#if cs
	@:noCompletion @:op(A == B) private static function equals (a:Context3DBlendFactor, b:Context3DBlendFactor):Bool {
		
		return NullUtils.valueEquals (a, b, Int);
		
	}
	#end
	
	#if cs
	@:noCompletion @:op(A != B) private static function notEquals (a:Context3DBlendFactor, b:Context3DBlendFactor):Bool {
		
		return !equals (a, b);
		
	}
	#end
	
}


#else


@:enum abstract Context3DBlendFactor(String) from String to String {
	
	public var DESTINATION_ALPHA = "destinationAlpha";
	public var DESTINATION_COLOR = "destinationColor";
	public var ONE = "one";
	public var ONE_MINUS_DESTINATION_ALPHA = "oneMinusDestinationAlpha";
	public var ONE_MINUS_DESTINATION_COLOR = "oneMinusDestinationColor";
	public var ONE_MINUS_SOURCE_ALPHA = "oneMinusSourceAlpha";
	public var ONE_MINUS_SOURCE_COLOR = "oneMinusSourceColor";
	public var SOURCE_ALPHA = "sourceAlpha";
	public var SOURCE_COLOR = "sourceColor";
	public var ZERO = "zero";
	
}


#end