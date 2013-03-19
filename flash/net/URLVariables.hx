package flash.net;
#if (flash || display)


/**
 * The URLVariables class allows you to transfer variables between an
 * application and a server. Use URLVariables objects with methods of the
 * URLLoader class, with the <code>data</code> property of the URLRequest
 * class, and with flash.net package functions.
 */
extern class URLVariables implements Dynamic {

	/**
	 * Creates a new URLVariables object. You pass URLVariables objects to the
	 * <code>data</code> property of URLRequest objects.
	 *
	 * <p>If you call the URLVariables constructor with a string, the
	 * <code>decode()</code> method is automatically called to convert the string
	 * to properties of the URLVariables object.</p>
	 * 
	 * @param source A URL-encoded string containing name/value pairs.
	 */
	function new(?source : String) : Void;

	/**
	 * Converts the variable string to properties of the specified URLVariables
	 * object.
	 *
	 * <p>This method is used internally by the URLVariables events. Most users
	 * do not need to call this method directly.</p>
	 * 
	 * @param source A URL-encoded query string containing name/value pairs.
	 * @throws Error The source parameter must be a URL-encoded query string
	 *               containing name/value pairs.
	 */
	function decode(source : String) : Void;

	/**
	 * Returns a string containing all enumerable variables, in the MIME content
	 * encoding <i>application/x-www-form-urlencoded</i>.
	 * 
	 * @return A URL-encoded string containing name/value pairs.
	 */
	function toString() : String;
}


#end
