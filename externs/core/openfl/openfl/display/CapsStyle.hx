package openfl.display; #if (display || !flash)


/**
 * The CapsStyle class is an enumeration of constant values that specify the
 * caps style to use in drawing lines. The constants are provided for use as
 * values in the <code>caps</code> parameter of the
 * <code>openfl.display.Graphics.lineStyle()</code> method. You can specify the
 * following three types of caps:
 */
@:enum abstract CapsStyle(Null<Int>) {
	
	/**
	 * Used to specify no caps in the <code>caps</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	public var NONE = 0;
	
	/**
	 * Used to specify round caps in the <code>caps</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	public var ROUND = 1;
	
	/**
	 * Used to specify square caps in the <code>caps</code> parameter of the
	 * <code>openfl.display.Graphics.lineStyle()</code> method.
	 */
	public var SQUARE = 2;
	
	@:from private static function fromString (value:String):CapsStyle {
		
		return switch (value) {
			
			case "none": NONE;
			case "round": ROUND;
			case "square": SQUARE;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case CapsStyle.NONE: "none";
			case CapsStyle.ROUND: "round";
			case CapsStyle.SQUARE: "square";
			default: null;
			
		}
		
	}
	
}


#else
typedef CapsStyle = flash.display.CapsStyle;
#end