package flash.net;

#if flash
extern class URLRequestDefaults
{
	#if air
	public static var authenticate:Bool;
	public static var cacheResponse:Bool;
	public static var followRedirects:Bool;
	public static var idleTimeout:Float;
	public static var manageCookies:Bool;
	public static var useCache:Bool;
	public static var userAgent:String;
	#else
	public static var followRedirects(get, set):Bool;
	private inline static function get_followRedirects():Bool
	{
		return true;
	}
	private inline static function set_followRedirects(value:Bool):Bool
	{
		return value;
	}
	public static var idleTimeout(get, set):Float;
	private inline static function get_idleTimeout():Float
	{
		return 30000;
	}
	private inline static function set_idleTimeout(value:Float):Float
	{
		return value;
	}
	public static var manageCookies(get, set):Bool;
	private inline static function get_manageCookies():Bool
	{
		return true;
	}
	private inline static function set_manageCookies(value:Bool):Bool
	{
		return value;
	}
	public static var userAgent(get, set):String;
	private inline static function get_userAgent():String
	{
		return null;
	}
	private inline static function set_userAgent(value:String):String
	{
		return value;
	}
	#end

	#if air
	public static function setLoginCredentialsForHost(hostname:String, user:String, password:String):Dynamic;
	#end
}
#else
typedef URLRequestDefaults = openfl.net.URLRequestDefaults;
#end
