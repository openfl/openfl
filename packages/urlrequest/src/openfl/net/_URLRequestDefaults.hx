package openfl.net;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _URLRequestDefaults
{
	public static var followRedirects:Bool = true;
	public static var idleTimeout:Float = 0;
	public static var manageCookies:Bool = false;
	public static var userAgent:String;
}
