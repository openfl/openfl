package flash.display {
	
	
	/**
	 * @externs
	 * The JointStyle class is an enumeration of constant values that specify the
	 * joint style to use in drawing lines. These constants are provided for use
	 * as values in the `joints` parameter of the
	 * `flash.display.Graphics.lineStyle()` method. The method supports
	 * three types of joints: miter, round, and bevel, as the following example
	 * shows:
	 */
	public class JointStyle {
		
		/**
		 * Specifies beveled joints in the `joints` parameter of the
		 * `flash.display.Graphics.lineStyle()` method.
		 */
		public static const BEVEL:String = "bevel";
		
		/**
		 * Specifies mitered joints in the `joints` parameter of the
		 * `flash.display.Graphics.lineStyle()` method.
		 */
		public static const MITER:String = "miter";
		
		/**
		 * Specifies round joints in the `joints` parameter of the
		 * `flash.display.Graphics.lineStyle()` method.
		 */
		public static const ROUND:String = "round";
		
	}
	
	
}