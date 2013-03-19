package flash.net;
#if (flash || display)


/**
 * A URLRequestHeader object encapsulates a single HTTP request header and
 * consists of a name/value pair. URLRequestHeader objects are used in the
 * <code>requestHeaders</code> property of the URLRequest class.
 *
 * <p>In Adobe<sup>®</sup> AIR<sup>®</sup>, content in the application
 * security sandbox(such as content installed with the AIR application) can
 * use any request headers, without error. However, for content running in
 * Adobe AIR that is in a different security sandbox, or for content running
 * in Flash<sup>®</sup> Player, using following request headers cause a
 * runtime error to be thrown, and the restricted terms are not case-sensitive
 * (for example, <code>Get</code>, <code>get</code>, and <code>GET</code> are
 * each not allowed): </p>
 *
 * <p>In Flash Player and in Adobe AIR content outside of the application
 * security sandbox, the following request headers cannot be used, and the
 * restricted terms are not case-sensitive(for example, <code>Get</code>,
 * <code>get</code>, and <code>GET</code> are all not allowed). Also,
 * hyphenated terms apply if an underscore character is used(for example,
 * both <code>Content-Length</code> and <code>Content_Length</code> are not
 * allowed): </p>
 *
 * <p><code>Accept-Charset</code>, <code>Accept-Encoding</code>,
 * <code>Accept-Ranges</code>, <code>Age</code>, <code>Allow</code>,
 * <code>Allowed</code>, <code>Authorization</code>, <code>Charge-To</code>,
 * <code>Connect</code>, <code>Connection</code>, <code>Content-Length</code>,
 * <code>Content-Location</code>, <code>Content-Range</code>,
 * <code>Cookie</code>, <code>Date</code>, <code>Delete</code>,
 * <code>ETag</code>, <code>Expect</code>, <code>Get</code>,
 * <code>Head</code>, <code>Host</code>, <code>If-Modified-Since</code>,
 * <code>Keep-Alive</code>, <code>Last-Modified</code>, <code>Location</code>,
 * <code>Max-Forwards</code>, <code>Options</code>, <code>Origin</code>,
 * <code>Post</code>, <code>Proxy-Authenticate</code>,
 * <code>Proxy-Authorization</code>, <code>Proxy-Connection</code>,
 * <code>Public</code>, <code>Put</code>, <code>Range</code>,
 * <code>Referer</code>, <code>Request-Range</code>, <code>Retry-After</code>,
 * <code>Server</code>, <code>TE</code>, <code>Trace</code>,
 * <code>Trailer</code>, <code>Transfer-Encoding</code>, <code>Upgrade</code>,
 * <code>URI</code>, <code>User-Agent</code>, <code>Vary</code>,
 * <code>Via</code>, <code>Warning</code>, <code>WWW-Authenticate</code>,
 * <code>x-flash-version</code>.</p>
 *
 * <p>URLRequestHeader objects are restricted in length. If the cumulative
 * length of a URLRequestHeader object(the length of the <code>name</code>
 * property plus the <code>value</code> property) or an array of
 * URLRequestHeader objects used in the <code>URLRequest.requestHeaders</code>
 * property exceeds the acceptable length, an exception is thrown.</p>
 *
 * <p>Content running in Adobe AIR sets the <code>ACCEPT</code> header to the
 * following, unless you specify a setting for the <code>ACCEPT</code> header
 * in the <code>requestHeaders</code> property of the URLRequest class:</p>
 * <code>text/xml, application/xml, application/xhtml+xml, text/html;q=0.9,
 * text/plain;q=0.8, image/png, application/x-shockwave-flash,
 * video/mp4;q=0.9, flv-application/octet-stream;q=0.8, video/x-flv;q=0.7,
 * audio/mp4, ~~/~~;q=0.5</code>
 *
 * <p>Not all methods that accept URLRequest parameters support the
 * <code>requestHeaders</code> property, consult the documentation for the
 * method you are calling. For example, the
 * <code>FileReference.upload()</code> and
 * <code>FileReference.download()</code> methods do not support the
 * <code>URLRequest.requestHeaders</code> property.</p>
 *
 * <p>Due to browser limitations, custom HTTP request headers are only
 * supported for <code>POST</code> requests, not for <code>GET</code>
 * requests.</p>
 */
@:final extern class URLRequestHeader {

	/**
	 * An HTTP request header name(such as <code>Content-Type</code> or
	 * <code>SOAPAction</code>).
	 */
	var name : String;

	/**
	 * The value associated with the <code>name</code> property(such as
	 * <code>text/plain</code>).
	 */
	var value : String;

	/**
	 * Creates a new URLRequestHeader object that encapsulates a single HTTP
	 * request header. URLRequestHeader objects are used in the
	 * <code>requestHeaders</code> property of the URLRequest class.
	 * 
	 * @param name  An HTTP request header name(such as
	 *              <code>Content-Type</code> or <code>SOAPAction</code>).
	 * @param value The value associated with the <code>name</code> property
	 *             (such as <code>text/plain</code>).
	 */
	function new(?name : String, ?value : String):Void;
}


#end
