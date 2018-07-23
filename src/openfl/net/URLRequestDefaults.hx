package openfl.net; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class URLRequestDefaults {
	
	
	//public static var authenticate:Bool;
	//public static var cacheResponse:Bool;
	public static var followRedirects:Bool = true;
	public static var idleTimeout:Float = 0;
	public static var manageCookies:Bool = false;
	//public static var useCache:Bool;
	public static var userAgent:String;
	
	
	// public static function setLoginCredentialsForHost (hostname:String, user:String, password:String):Dynamic {
		
	// 	openfl._internal.Lib.notImplemented ();
	// 	return null;
		
	// }
	
	
}


#else
typedef URLRequestDefaults = flash.net.URLRequestDefaults;
#end