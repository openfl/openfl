package openfl.display; #if (display || !flash)


/**
 * The SpreadMethod class provides values for the <code>spreadMethod</code>
 * parameter in the <code>beginGradientFill()</code> and
 * <code>lineGradientStyle()</code> methods of the Graphics class.
 *
 * <p>The following example shows the same gradient fill using various spread
 * methods:</p>
 */
@:enum abstract SpreadMethod(Null<Int>) {
	
	/**
	 * Specifies that the gradient use the <i>pad</i> spread method.
	 */
	public var PAD = 0;
	
	/**
	 * Specifies that the gradient use the <i>reflect</i> spread method.
	 */
	public var REFLECT = 1;
	
	/**
	 * Specifies that the gradient use the <i>repeat</i> spread method.
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