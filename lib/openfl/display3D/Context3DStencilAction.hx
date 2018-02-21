package openfl.display3D; #if (display || !flash)


@:enum abstract Context3DStencilAction(Null<Int>) {
	
	public var DECREMENT_SATURATE = 0;
	public var DECREMENT_WRAP = 1;
	public var INCREMENT_SATURATE = 2;
	public var INCREMENT_WRAP = 3;
	public var INVERT = 4;
	public var KEEP = 5;
	public var SET = 6;
	public var ZERO = 7;
	
	@:from private static function fromString (value:String):Context3DStencilAction {
		
		return switch (value) {
			
			case "decrementSaturate": DECREMENT_SATURATE;
			case "decrementWrap": DECREMENT_WRAP;
			case "incrementSaturate": INCREMENT_SATURATE;
			case "incrementWrap": INCREMENT_WRAP;
			case "invert": INVERT;
			case "keep": KEEP;
			case "set": SET;
			case "zero": ZERO;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case Context3DStencilAction.DECREMENT_SATURATE: "decrementSaturate";
			case Context3DStencilAction.DECREMENT_WRAP: "decrementWrap";
			case Context3DStencilAction.INCREMENT_SATURATE: "incrementSaturate";
			case Context3DStencilAction.INCREMENT_WRAP: "incrementWrap";
			case Context3DStencilAction.INVERT: "invert";
			case Context3DStencilAction.KEEP: "keep";
			case Context3DStencilAction.SET: "set";
			case Context3DStencilAction.ZERO: "zero";
			default: null;
			
		}
		
	}
	
}


#else
typedef Context3DStencilAction = flash.display3D.Context3DStencilAction;
#end