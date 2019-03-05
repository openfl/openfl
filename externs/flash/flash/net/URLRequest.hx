package flash.net;

#if flash
@:final extern class URLRequest
{
	#if air
	public var authenticate:Bool;
	public var cacheResponse:Bool;
	#end
	public var contentType:String;
	public var data:Dynamic;
	#if flash
	public var digest:String;
	#end
	#if (air || !flash)
	public var followRedirects:Bool;
	public var idleTimeout:Float;
	#else
	public var followRedirects(get, set):Bool;
	@:noCompletion private inline function get_followRedirects():Bool
	{
		return true;
	}
	@:noCompletion private inline function set_followRedirects(value:Bool):Bool
	{
		return value;
	}
	public var idleTimeout(get, set):Float;
	@:noCompletion private inline function get_idleTimeout():Float
	{
		return 30000;
	}
	@:noCompletion private inline function set_idleTimeout(value:Float):Float
	{
		return value;
	}
	#end
	#if (air || !flash)
	public var manageCookies:Bool;
	#else
	public var manageCookies(get, set):Bool;
	@:noCompletion private inline function get_manageCookies():Bool
	{
		return true;
	}
	@:noCompletion private inline function set_manageCookies(value:Bool):Bool
	{
		return value;
	}
	#end
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	#if air
	public var useCache:Bool;
	#end
	#if (air || !flash)
	public var userAgent:String;
	#else
	public var userAgent(get, set):String;
	@:noCompletion private inline function get_userAgent():String
	{
		return null;
	}
	@:noCompletion private inline function set_userAgent(value:String):String
	{
		return value;
	}
	#end
	public function new(url:String = null);
	#if flash
	public function useRedirectedURL(sourceRequest:URLRequest, wholeURL:Bool = false, pattern:Dynamic = null, replace:String = null):Void;
	#end
}
#else
typedef URLRequest = openfl.net.URLRequest;
#end
