/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.text;
#if display


/**
 * The TextFieldType class is an enumeration of constant values used in
 * setting the <code>type</code> property of the TextField class.
 */
@:fakeEnum(String) extern enum TextFieldType {

	/**
	 * Used to specify a <code>dynamic</code> TextField.
	 */
	DYNAMIC;

	/**
	 * Used to specify an <code>input</code> TextField.
	 */
	INPUT;
}


#end
