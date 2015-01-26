package openfl.net; #if !flash #if !lime_legacy


/**
 * The URLRequestMethod class provides values that specify whether the
 * URLRequest object should use the <code>POST</code> method or the
 * <code>GET</code> method when sending data to a server.
 */
class URLRequestMethod {
	
	/**
	 * Specifies that the URLRequest object is a <code>DELETE</code>.
	 */
	public static var DELETE:String = "DELETE";
	
	/**
	 * Specifies that the URLRequest object is a <code>GET</code>.
	 */
	public static var GET:String = "GET";
	
	/**
	 * Specifies that the URLRequest object is a <code>HEAD</code>.
	 */
	public static var HEAD:String = "HEAD";
	
	/**
	 * Specifies that the URLRequest object is <code>OPTIONS</code>.
	 */
	public static var OPTIONS:String = "OPTIONS";
	
	/**
	 * Specifies that the URLRequest object is a <code>POST</code>.
	 *
	 * <p><i>Note:</i> For content running in Adobe AIR, when using the
	 * <code>navigateToURL()</code> function, the runtime treats a URLRequest
	 * that uses the POST method(one that has its <code>method</code> property
	 * set to <code>URLRequestMethod.POST</code>) as using the GET method.</p>
	 */
	public static var POST:String = "POST";
	
	/**
	 * Specifies that the URLRequest object is a <code>PUT</code>.
	 */
	public static var PUT:String = "PUT";
	
}


#else
typedef URLRequestMethod = openfl._v2.net.URLRequestMethod;
#end
#else
typedef URLRequestMethod = flash.net.URLRequestMethod;
#end