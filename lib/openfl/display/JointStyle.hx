package openfl.display; #if (display || !flash)


/**
 * The JointStyle class is an enumeration of constant values that specify the
 * joint style to use in drawing lines. These constants are provided for use
 * as values in the `joints` parameter of the
 * `openfl.display.Graphics.lineStyle()` method. The method supports
 * three types of joints: miter, round, and bevel, as the following example
 * shows:
 */
@:enum abstract JointStyle(Null<Int>) {
	
	/**
	 * Specifies beveled joints in the `joints` parameter of the
	 * `openfl.display.Graphics.lineStyle()` method.
	 */
	public var BEVEL = 0;
	
	/**
	 * Specifies mitered joints in the `joints` parameter of the
	 * `openfl.display.Graphics.lineStyle()` method.
	 */
	public var MITER = 1;
	
	/**
	 * Specifies round joints in the `joints` parameter of the
	 * `openfl.display.Graphics.lineStyle()` method.
	 */
	public var ROUND = 2;
	
	@:from private static function fromString (value:String):JointStyle {
		
		return switch (value) {
			
			case "bevel": BEVEL;
			case "miter": MITER;
			case "round": ROUND;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case JointStyle.BEVEL: "bevel";
			case JointStyle.MITER: "miter";
			case JointStyle.ROUND: "round";
			default: null;
			
		}
		
	}
	
}


#else
typedef JointStyle = flash.display.JointStyle;
#end