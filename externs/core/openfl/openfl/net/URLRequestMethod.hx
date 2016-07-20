package openfl.net; #if (display || !flash)


/**
 * The URLRequestMethod class provides values that specify whether the
 * URLRequest object should use the <code>POST</code> method or the
 * <code>GET</code> method when sending data to a server.
 */
@:enum abstract URLRequestMethod(Null<Int>) {
	
	/**
	 * Specifies that the URLRequest object is a <code>DELETE</code>.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var DELETE = 0;
	
	/**
	 * Specifies that the URLRequest object is a <code>GET</code>.
	 */
	public var GET = 1;
	
	/**
	 * Specifies that the URLRequest object is a <code>HEAD</code>.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var HEAD = 2;
	
	/**
	 * Specifies that the URLRequest object is <code>OPTIONS</code>.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var OPTIONS = 3;
	
	/**
	 * Specifies that the URLRequest object is a <code>POST</code>.
	 *
	 * <p><i>Note:</i> For content running in Adobe AIR, when using the
	 * <code>navigateToURL()</code> function, the runtime treats a URLRequest
	 * that uses the POST method(one that has its <code>method</code> property
	 * set to <code>URLRequestMethod.POST</code>) as using the GET method.</p>
	 */
	public var POST = 4;
	
	/**
	 * Specifies that the URLRequest object is a <code>PUT</code>.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var PUT = 5;
	
	@:from private static function fromString (value:String):URLRequestMethod {
		
		return switch (value) {
			
			case "DELETE": DELETE;
			case "GET": GET;
			case "HEAD": HEAD;
			case "OPTIONS": OPTIONS;
			case "POST": POST;
			case "PUT": PUT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case URLRequestMethod.DELETE: "DELETE";
			case URLRequestMethod.GET: "GET";
			case URLRequestMethod.HEAD: "HEAD";
			case URLRequestMethod.OPTIONS: "OPTIONS";
			case URLRequestMethod.POST: "POST";
			case URLRequestMethod.PUT: "PUT";
			default: null;
			
		}
		
	}
	
}


#else
typedef URLRequestMethod = flash.net.URLRequestMethod;
#end