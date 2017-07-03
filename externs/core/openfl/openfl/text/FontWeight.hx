package openfl.text; #if (display || !flash)

@:enum abstract FontWeight(Null<Int>) {

	/**
	 * Defines the normal font weight. Use the syntax
	 * <code>FontWeight.REGULAR</code>.
	 */
	public var NORMAL = 0;

	/**
	 * Defines the standard bold font weight. Use the syntax
	 * <code>FontWeight.BOLD</code>.
	 */
	public var BOLD = 1;

	/**
	 * Defines the bolder font weight. Use the syntax
	 * <code>FontWeight.BOLDER</code>.
	 */
	public var BOLDER = 2;

	/**
	 * Defines the standard light font weight. Use the syntax
	 * <code>FontWeight.LIGHTER</code>.
	 */
	public var LIGHTER = 3;

	/**
	 * Defines the thin 100 font weight. Use the syntax
	 * <code>FontWeight.THIN_100</code>.
	 */
	public var THIN_100 = 100;

	/**
	 * Defines the thin 200 font weight. Use the syntax
	 * <code>FontWeight.THIN_200</code>.
	 */
	public var THIN_200 = 200;

	/**
	 * Defines the light 300 font weight. Use the syntax
	 * <code>FontWeight.LIGHT_300</code>.
	 */
	public var LIGHT_300 = 300;

	/**
	 * Defines the regular 400 font weight. Use the syntax
	 * <code>FontWeight.REGULAR_400</code>.
	 */
	public var REGULAR_400 = 400;

	/**
	 * Defines the medium 500 font weight. Use the syntax
	 * <code>FontWeight.MEDIUM_500</code>.
	 */
	public var MEDIUM_500 = 500;

	/**
	 * Defines the medium 600 font weight. Use the syntax
	 * <code>FontWeight.MEDIUM_600</code>.
	 */
	public var MEDIUM_600 = 600;

	/**
	 * Defines the bold 700 font weight. Use the syntax
	 * <code>FontWeight.BOLD_700</code>.
	 */
	public var BOLD_700 = 700;

	/**
	 * Defines the bold 800 font weight. Use the syntax
	 * <code>FontWeight.BOLD_800</code>.
	 */
	public var BOLD_800 = 800;

	/**
	 * Defines the black 900 font weight. Use the syntax
	 * <code>FontWeight.BLACK_900</code>.
	 */
	public var BLACK_900 = 900;

}
#end