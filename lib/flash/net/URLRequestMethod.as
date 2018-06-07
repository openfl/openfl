package flash.net {
	
	
	/**
	 * @externs
	 * The URLRequestMethod class provides values that specify whether the
	 * URLRequest object should use the `POST` method or the
	 * `GET` method when sending data to a server.
	 */
	final public class URLRequestMethod {
		
		/**
		 * Specifies that the URLRequest object is a `DELETE`.
		 */
		// #if flash
		// @:require(flash10_1)
		// #end
		public static const DELETE:String = "DELETE";
		
		/**
		 * Specifies that the URLRequest object is a `GET`.
		 */
		public static const GET:String = "GET";
		
		/**
		 * Specifies that the URLRequest object is a `HEAD`.
		 */
		// #if flash
		// @:require(flash10_1)
		// #end
		public static const HEAD:String = "HEAD";
		
		/**
		 * Specifies that the URLRequest object is `OPTIONS`.
		 */
		// #if flash
		// @:require(flash10_1)
		// #end
		public static const OPTIONS:String = "OPTIONS";
		
		/**
		 * Specifies that the URLRequest object is a `POST`.
		 *
		 * _Note:_ For content running in Adobe AIR, when using the
		 * `navigateToURL()` function, the runtime treats a URLRequest
		 * that uses the POST method(one that has its `method` property
		 * set to `URLRequestMethod.POST`) as using the GET method.
		 */
		public static const POST:String = "POST";
		
		/**
		 * Specifies that the URLRequest object is a `PUT`.
		 */
		// #if flash
		// @:require(flash10_1)
		// #end
		public static const PUT:String = "PUT";
		
	}
	
	
}