package openfl.net; #if (display || !flash)


/**
 * The URLRequestMethod class provides values that specify whether the
 * URLRequest object should use the `POST` method or the
 * `GET` method when sending data to a server.
 */
@:enum abstract URLRequestMethod(String) from String to String {
	
	/**
	 * Specifies that the URLRequest object is a `DELETE`.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var DELETE = "DELETE";
	
	/**
	 * Specifies that the URLRequest object is a `GET`.
	 */
	public var GET = "GET";
	
	/**
	 * Specifies that the URLRequest object is a `HEAD`.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var HEAD = "HEAD";
	
	/**
	 * Specifies that the URLRequest object is `OPTIONS`.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var OPTIONS = "OPTIONS";
	
	/**
	 * Specifies that the URLRequest object is a `POST`.
	 *
	 * _Note:_ For content running in Adobe AIR, when using the
	 * `navigateToURL()` function, the runtime treats a URLRequest
	 * that uses the POST method(one that has its `method` property
	 * set to `URLRequestMethod.POST`) as using the GET method.
	 */
	public var POST = "POST";
	
	/**
	 * Specifies that the URLRequest object is a `PUT`.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var PUT = "PUT";
	
}


#else
typedef URLRequestMethod = flash.net.URLRequestMethod;
#end