package openfl.net;


#if (flash && !display)

@:native("flash.net.URLRequestMethod")

extern class URLRequestMethod {
	
	@:require(flash10_1) public static var DELETE:String;
	public static var GET:String;
	@:require(flash10_1) public static var HEAD:String;
	@:require(flash10_1) public static var OPTIONS:String;
	public static var POST:String;
	@:require(flash10_1) public static var PUT:String;
	
}

#else


/**
 * The URLRequestMethod class provides values that specify whether the
 * URLRequest object should use the <code>POST</code> method or the
 * <code>GET</code> method when sending data to a server.
 */
@:enum abstract URLRequestMethod(String) from String to String {
	
	/**
	 * Specifies that the URLRequest object is a <code>DELETE</code>.
	 */
	var DELETE = "DELETE";
	
	/**
	 * Specifies that the URLRequest object is a <code>GET</code>.
	 */
	var GET = "GET";
	
	/**
	 * Specifies that the URLRequest object is a <code>HEAD</code>.
	 */
	var HEAD = "HEAD";
	
	/**
	 * Specifies that the URLRequest object is <code>OPTIONS</code>.
	 */
	var OPTIONS = "OPTIONS";
	
	/**
	 * Specifies that the URLRequest object is a <code>POST</code>.
	 *
	 * <p><i>Note:</i> For content running in Adobe AIR, when using the
	 * <code>navigateToURL()</code> function, the runtime treats a URLRequest
	 * that uses the POST method(one that has its <code>method</code> property
	 * set to <code>URLRequestMethod.POST</code>) as using the GET method.</p>
	 */
	var POST = "POST";
	
	/**
	 * Specifies that the URLRequest object is a <code>PUT</code>.
	 */
	var PUT = "PUT";
	
}


#end