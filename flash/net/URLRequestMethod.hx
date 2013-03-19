package flash.net;
#if (flash || display)


/**
 * The URLRequestMethod class provides values that specify whether the
 * URLRequest object should use the <code>POST</code> method or the
 * <code>GET</code> method when sending data to a server.
 */
extern class URLRequestMethod {

	/**
	 * Specifies that the URLRequest object is a <code>DELETE</code>.
	 */
	@:require(flash10_1) static var DELETE : String;

	/**
	 * Specifies that the URLRequest object is a <code>GET</code>.
	 */
	static var GET : String;

	/**
	 * Specifies that the URLRequest object is a <code>HEAD</code>.
	 */
	@:require(flash10_1) static var HEAD : String;

	/**
	 * Specifies that the URLRequest object is <code>OPTIONS</code>.
	 */
	@:require(flash10_1) static var OPTIONS : String;

	/**
	 * Specifies that the URLRequest object is a <code>POST</code>.
	 *
	 * <p><i>Note:</i> For content running in Adobe AIR, when using the
	 * <code>navigateToURL()</code> function, the runtime treats a URLRequest
	 * that uses the POST method(one that has its <code>method</code> property
	 * set to <code>URLRequestMethod.POST</code>) as using the GET method.</p>
	 */
	static var POST : String;

	/**
	 * Specifies that the URLRequest object is a <code>PUT</code>.
	 */
	@:require(flash10_1) static var PUT : String;
}


#end
