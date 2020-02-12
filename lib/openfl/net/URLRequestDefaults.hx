package openfl.net;

#if (display || !flash)
@:jsRequire("openfl/net/URLRequestDefaults", "default")
extern class URLRequestDefaults
{
	// public static var authenticate:Bool;
	// public static var cacheResponse:Bool;
	public static var followRedirects:Bool;
	public static var idleTimeout:Float;
	public static var manageCookies:Bool;
	// public static var useCache:Bool;
	public static var userAgent:String;
	// public static function setLoginCredentialsForHost (hostname:String, user:String, password:String):Dynamic {
	// 	openfl.Lib.notImplemented ();
	// 	return null;
	// }
}
#else
typedef URLRequestDefaults = flash.net.URLRequestDefaults;
#end
