package openfl.text;


/**
 * The TextFieldType class is an enumeration of constant values used in
 * setting the <code>type</code> property of the TextField class.
 */
@:enum abstract TextFieldType(String) from String to String {
	
	/**
	 * Used to specify a <code>dynamic</code> TextField.
	 */
	public var DYNAMIC = "dynamic";
	
	/**
	 * Used to specify an <code>input</code> TextField.
	 */
	public var INPUT = "input";
	
}