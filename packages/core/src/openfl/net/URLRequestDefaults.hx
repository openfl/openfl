package openfl.net;

#if !flash
/**
	The URLRequestDefaults class includes static properties that you can set to define
	default values for the properties of the URLRequest class. It also includes a static
	method, `URLRequestDefaults.setLoginCredentialsForHost()`, which lets you define
	default authentication credentials for requests. The URLRequest class defines the
	information to use in an HTTP request.

	Any properties set in a URLRequest object override those static properties set for the
	URLRequestDefaults class.

	URLRequestDefault settings only apply to content in the caller's application domain,
	with one exception: settings made by calling
	`URLRequestDefaults.setLoginCredentialsForHost()` apply to all application domains in
	the currently running application.

	Only Adobe® AIR® content running in the application security sandbox can use the
	URLRequestDefaults class. Other content will result in a SecurityError being thrown
	when accessing the members or properties of this class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class URLRequestDefaults
{
	// public static var authenticate:Bool;
	// public static var cacheResponse:Bool;

	/**
		The default setting for the `followRedirects` property of URLRequest objects.
		Setting the `followRedirects` property in a URLRequest object overrides this
		default setting. This setting does not apply to URLRequest objects used in file
		upload or RTMP requests.

		The default value is `true`.
	**/
	public static var followRedirects(get, set):Bool;

	/**
		The default setting for the `idleTimeout` property of URLRequest objects and
		HTMLLoader objects.

		The idle timeout is the amount of time (in milliseconds) that the client waits for
		a response from the server, after the connection is established, before abandoning
		the request.

		This defines the default idle timeout used by the URLRequest or HTMLLoader object.
		Setting the `idleTimeout` property in a URLRequest object or an HTMLLoader object
		overrides this default setting.

		When this property is set to 0 (the default), the runtime uses the default idle
		timeout value defined by the operating system. The default idle timeout value
		varies between operating systems (such as Mac OS, Linux, or Windows) and between
		operating system versions.

		This setting does not apply to URLRequest objects used in file upload or RTMP
		requests.

		The default value is 0.
	**/
	public static var idleTimeout(get, set):Float;

	/**
		The default setting for the manageCookies property of URLRequest objects. Setting
		the manageCookies property in a URLRequest object overrides this default setting.

		**Note:** This setting does not apply to URLRequest objects used in file upload
		or RTMP requests.

		The default value is `true`.
	**/
	public static var manageCookies(get, set):Bool;

	// public static var useCache:Bool;

	/**
		The default setting for the `userAgent` property of URLRequest objects. Setting the
		`userAgent` property in a URLRequest object overrides this default setting.

		This is also the default user agent string for all HTMLLoader objects (used when
		you call the `load()` method of the HTMLLoader object). Setting the `userAgent`
		property of the HTMLLoader object overrides the `URLRequestDefaults.userAgent`
		setting.

		This default value varies depending on the runtime operating system (such as Mac OS,
		Linux or Windows), the runtime language, and the runtime version, as in the
		following examples:

		* `"Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/526.9+ (KHTML, like Gecko) AdobeAIR/1.5"`
		* `"Mozilla/5.0 (Windows; U; en) AppleWebKit/526.9+ (KHTML, like Gecko) AdobeAIR/1.5"`
		* `"Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/526.9+ (KHTML, like Gecko) AdobeAIR/1.5"`
	**/
	public static var userAgent(get, set):String;

	// public static function setLoginCredentialsForHost (hostname:String, user:String, password:String):Dynamic {
	// 	openfl._internal.Lib.notImplemented ();
	// 	return null;
	// }
	// Get & Set Methods

	@:noCompletion private static function get_followRedirects():Bool
	{
		return _URLRequestDefaults.followRedirects;
	}

	@:noCompletion private static function set_followRedirects(value:Bool):Bool
	{
		return _URLRequestDefaults.followRedirects = value;
	}

	@:noCompletion private static function get_idleTimeout():Float
	{
		return _URLRequestDefaults.idleTimeout;
	}

	@:noCompletion private static function set_idleTimeout(value:Float):Float
	{
		return _URLRequestDefaults.idleTimeout = value;
	}

	@:noCompletion private static function get_manageCookies():Bool
	{
		return _URLRequestDefaults.manageCookies;
	}

	@:noCompletion private static function set_manageCookies(value:Bool):Bool
	{
		return _URLRequestDefaults.manageCookies = value;
	}

	@:noCompletion private static function get_userAgent():String
	{
		return _URLRequestDefaults.userAgent;
	}

	@:noCompletion private static function set_userAgent(value:String):String
	{
		return _URLRequestDefaults.userAgent = value;
	}
}
#else
typedef URLRequestDefaults = flash.net.URLRequestDefaults;
#end
