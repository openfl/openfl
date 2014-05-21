/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.net;
#if display


/**
 * The URLLoaderDataFormat class provides values that specify how downloaded
 * data is received.
 */
@:fakeEnum(String) extern enum URLLoaderDataFormat {

	/**
	 * Specifies that downloaded data is received as raw binary data.
	 */
	BINARY;

	/**
	 * Specifies that downloaded data is received as text.
	 */
	TEXT;

	/**
	 * Specifies that downloaded data is received as URL-encoded variables.
	 */
	VARIABLES;
}


#end
