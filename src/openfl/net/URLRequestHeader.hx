package openfl.net;

#if !flash
/**
	A URLRequestHeader object encapsulates a single HTTP request header and
	consists of a name/value pair. URLRequestHeader objects are used in the
	`requestHeaders` property of the URLRequest class.

	In Adobe<sup>®</sup> AIR<sup>®</sup>, content in the application
	security sandbox(such as content installed with the AIR application) can
	use any request headers, without error. However, for content running in
	Adobe AIR that is in a different security sandbox, or for content running
	in Flash<sup>®</sup> Player, using following request headers cause a
	runtime error to be thrown, and the restricted terms are not case-sensitive
	(for example, `Get`, `get`, and `GET` are
	each not allowed):

	In Flash Player and in Adobe AIR content outside of the application
	security sandbox, the following request headers cannot be used, and the
	restricted terms are not case-sensitive(for example, `Get`,
	`get`, and `GET` are all not allowed). Also,
	hyphenated terms apply if an underscore character is used(for example,
	both `Content-Length` and `Content_Length` are not
	allowed):

	`Accept-Charset`, `Accept-Encoding`,
	`Accept-Ranges`, `Age`, `Allow`,
	`Allowed`, `Authorization`, `Charge-To`,
	`Connect`, `Connection`, `Content-Length`,
	`Content-Location`, `Content-Range`,
	`Cookie`, `Date`, `Delete`,
	`ETag`, `Expect`, `Get`,
	`Head`, `Host`, `If-Modified-Since`,
	`Keep-Alive`, `Last-Modified`, `Location`,
	`Max-Forwards`, `Options`, `Origin`,
	`Post`, `Proxy-Authenticate`,
	`Proxy-Authorization`, `Proxy-Connection`,
	`Public`, `Put`, `Range`,
	`Referer`, `Request-Range`, `Retry-After`,
	`Server`, `TE`, `Trace`,
	`Trailer`, `Transfer-Encoding`, `Upgrade`,
	`URI`, `User-Agent`, `Vary`,
	`Via`, `Warning`, `WWW-Authenticate`,
	`x-flash-version`.

	URLRequestHeader objects are restricted in length. If the cumulative
	length of a URLRequestHeader object(the length of the `name`
	property plus the `value` property) or an array of
	URLRequestHeader objects used in the `URLRequest.requestHeaders`
	property exceeds the acceptable length, an exception is thrown.

	Content running in Adobe AIR sets the `ACCEPT` header to the
	following, unless you specify a setting for the `ACCEPT` header
	in the `requestHeaders` property of the URLRequest class:

	```
	text/xml, application/xml, application/xhtml+xml, text/html;q=0.9, text/plain;q=0.8, image/png, application/x-shockwave-flash, video/mp4;q=0.9, flv-application/octet-stream;q=0.8, video/x-flv;q=0.7, audio/mp4, * /*;q=0.5
	```

	Not all methods that accept URLRequest parameters support the
	`requestHeaders` property, consult the documentation for the
	method you are calling. For example, the
	`FileReference.upload()` and
	`FileReference.download()` methods do not support the
	`URLRequest.requestHeaders` property.

	Due to browser limitations, custom HTTP request headers are only
	supported for `POST` requests, not for `GET`
	requests.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class URLRequestHeader
{
	/**
		An HTTP request header name(such as `Content-Type` or
		`SOAPAction`).
	**/
	public var name:String;

	/**
		The value associated with the `name` property(such as
		`text/plain`).
	**/
	public var value:String;

	/**
		Creates a new URLRequestHeader object that encapsulates a single HTTP
		request header. URLRequestHeader objects are used in the
		`requestHeaders` property of the URLRequest class.

		@param name  An HTTP request header name(such as
					 `Content-Type` or `SOAPAction`).
		@param value The value associated with the `name` property
					(such as `text/plain`).
	**/
	public function new(name:String = "", value:String = "")
	{
		this.name = name;
		this.value = value;
	}
}
#else
typedef URLRequestHeader = flash.net.URLRequestHeader;
#end
