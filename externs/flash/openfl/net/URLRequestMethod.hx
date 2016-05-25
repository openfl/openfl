package openfl.net;


/**
 * The URLRequestMethod class provides values that specify whether the
 * URLRequest object should use the <code>POST</code> method or the
 * <code>GET</code> method when sending data to a server.
 */
@:enum abstract URLRequestMethod(String) from String to String {
	
	/**
	 * Specifies that the URLRequest object is a <code>DELETE</code>.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var DELETE = "DELETE";
	
	/**
	 * Specifies that the URLRequest object is a <code>GET</code>.
	 */
	public var GET = "GET";
	
	/**
	 * Specifies that the URLRequest object is a <code>HEAD</code>.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var HEAD = "HEAD";
	
	/**
	 * Specifies that the URLRequest object is <code>OPTIONS</code>.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var OPTIONS = "OPTIONS";
	
	/**
	 * Specifies that the URLRequest object is a <code>POST</code>.
	 *
	 * <p><i>Note:</i> For content running in Adobe AIR, when using the
	 * <code>navigateToURL()</code> function, the runtime treats a URLRequest
	 * that uses the POST method(one that has its <code>method</code> property
	 * set to <code>URLRequestMethod.POST</code>) as using the GET method.</p>
	 */
	public var POST = "POST";
	
	/**
	 * Specifies that the URLRequest object is a <code>PUT</code>.
	 */
	#if flash
	@:require(flash10_1)
	#end
	public var PUT = "PUT";
	
}