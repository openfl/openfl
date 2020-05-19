package openfl.net;

#if !flash
/**
	The URLRequestMethod class provides values that specify whether the
	URLRequest object should use the `POST` method or the
	`GET` method when sending data to a server.
**/
@:enum abstract URLRequestMethod(String) from String to String
{
	/**
		Specifies that the URLRequest object is a `DELETE`.
	**/
	public var DELETE = "DELETE";

	/**
		Specifies that the URLRequest object is a `GET`.
	**/
	public var GET = "GET";

	/**
		Specifies that the URLRequest object is a `HEAD`.
	**/
	public var HEAD = "HEAD";

	/**
		Specifies that the URLRequest object is `OPTIONS`.
	**/
	public var OPTIONS = "OPTIONS";

	/**
		Specifies that the URLRequest object is a `POST`.

		_Note:_ For content running in Adobe AIR, when using the
		`navigateToURL()` function, the runtime treats a URLRequest
		that uses the POST method(one that has its `method` property
		set to `URLRequestMethod.POST`) as using the GET method.
	**/
	public var POST = "POST";

	/**
		Specifies that the URLRequest object is a `PUT`.
	**/
	public var PUT = "PUT";
}
#else
typedef URLRequestMethod = flash.net.URLRequestMethod;
#end
