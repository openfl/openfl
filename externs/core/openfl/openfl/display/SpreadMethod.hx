package openfl.display; #if (display || !flash)


/**
 * The SpreadMethod class provides values for the `spreadMethod`
 * parameter in the `beginGradientFill()` and
 * `lineGradientStyle()` methods of the Graphics class.
 *
 * The following example shows the same gradient fill using various spread
 * methods:
 */
@:enum abstract SpreadMethod(Null<Int>) {
	
	/**
	 * Specifies that the gradient use the _pad_ spread method.
	 */
	public var PAD = 0;
	
	/**
	 * Specifies that the gradient use the _reflect_ spread method.
	 */
	public var REFLECT = 1;
	
	/**
	 * Specifies that the gradient use the _repeat_ spread method.
	 */
	public var REPEAT = 2;
	
	@:from private static function fromString (value:String):SpreadMethod {
		
		return switch (value) {
			
			case "pad": PAD;
			case "reflect": REFLECT;
			case "repeat": REPEAT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case SpreadMethod.PAD: "pad";
			case SpreadMethod.REFLECT: "reflect";
			case SpreadMethod.REPEAT: "repeat";
			default: null;
			
		}
		
	}
	
}


#else
typedef SpreadMethod = flash.display.SpreadMethod;
#end