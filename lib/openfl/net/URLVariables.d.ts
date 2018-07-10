declare namespace openfl.net {
	
	
	/**
	 * The URLVariables class allows you to transfer variables between an
	 * application and a server. Use URLVariables objects with methods of the
	 * URLLoader class, with the `data` property of the URLRequest
	 * class, and with flash.net package functions.
	 */
	export class URLVariables extends Object {
		
		
		/**
		 * Creates a new URLVariables object. You pass URLVariables objects to the
		 * `data` property of URLRequest objects.
		 *
		 * If you call the URLVariables constructor with a string, the
		 * `decode()` method is automatically called to convert the string
		 * to properties of the URLVariables object.
		 * 
		 * @param source A URL-encoded string containing name/value pairs.
		 */
		public constructor (source?:string);
		
		
		/**
		 * Converts the variable string to properties of the specified URLVariables
		 * object.
		 *
		 * This method is used internally by the URLVariables events. Most users
		 * do not need to call this method directly.
		 * 
		 * @param source A URL-encoded query string containing name/value pairs.
		 * @throws Error The source parameter must be a URL-encoded query string
		 *               containing name/value pairs.
		 */
		public decode (source:string):void;
		
		
		/**
		 * Returns a string containing all enumerable variables, in the MIME content
		 * encoding _application/x-www-form-urlencoded_.
		 * 
		 * @return A URL-encoded string containing name/value pairs.
		 */
		public toString ():string;
		
		
		[key:string]:any;
		
		
	}
	
	
}


export default openfl.net.URLVariables;