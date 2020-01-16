package openfl.text;

/**
 * The TextFieldType class is an enumeration of constant values used in
 * setting the `type` property of the TextField class.
 */
@:enum abstract TextFieldType(String) from String to String
{
	/**
	 * Used to specify a `dynamic` TextField.
	 */
	public var DYNAMIC = "dynamic";

	/**
	 * Used to specify an `input` TextField.
	 */
	public var INPUT = "input";
}
