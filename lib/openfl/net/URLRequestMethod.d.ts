declare namespace openfl.net {
	
	/**
	 * The URLRequestMethod class provides values that specify whether the
	 * URLRequest object should use the `POST` method or the
	 * `GET` method when sending data to a server.
	 */
	export enum URLRequestMethod {
		
		/**
		 * Specifies that the URLRequest object is a `DELETE`.
		 */
		DELETE = "DELETE",
		
		/**
		 * Specifies that the URLRequest object is a `GET`.
		 */
		GET = "GET",
		
		/**
		 * Specifies that the URLRequest object is a `HEAD`.
		 */
		HEAD = "HEAD",
		
		/**
		 * Specifies that the URLRequest object is `OPTIONS`.
		 */
		OPTIONS = "OPTIONS",
		
		/**
		 * Specifies that the URLRequest object is a `POST`.
		 *
		 * _Note:_ For content running in Adobe AIR, when using the
		 * `navigateToURL()` function, the runtime treats a URLRequest
		 * that uses the POST method(one that has its `method` property
		 * set to `URLRequestMethod.POST`) as using the GET method.
		 */
		POST = "POST",
		
		/**
		 * Specifies that the URLRequest object is a `PUT`.
		 */
		PUT = "PUT"
		
	}
	
}


export default openfl.net.URLRequestMethod;