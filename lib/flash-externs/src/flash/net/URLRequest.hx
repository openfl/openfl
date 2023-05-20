package flash.net;

#if flash
@:final extern class URLRequest
{
	#if (haxe_ver < 4.3)
	public var contentType:String;
	public var data:Dynamic;
	public var digest:String;
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	#if air
	public var authenticate:Bool;
	public var cacheResponse:Bool;
	public var followRedirects:Bool;
	public var idleTimeout:Float;
	public var manageCookies:Bool;
	public var useCache:Bool;
	public var userAgent:String;
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
	public var manageCookies(get, set):Bool;
	@:noCompletion private inline function get_manageCookies():Bool
	{
		return true;
	}
	@:noCompletion private inline function set_manageCookies(value:Bool):Bool
	{
		return value;
	}
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
	#else
	@:flash.property var contentType(get, set):String;
	@:flash.property var data(get, set):Dynamic;
	@:flash.property var digest(get, set):String;
	@:flash.property var method(get, set):String;
	@:flash.property var requestHeaders(get, set):Array<URLRequestHeader>;
	@:flash.property var url(get, set):String;
	#if air
	@:flash.property public var authenticate(get, set):Bool;
	@:flash.property public var cacheResponse(get, set):Bool;
	@:flash.property public var followRedirects(get, set):Bool;
	@:flash.property public var idleTimeout(get, set):Float;
	@:flash.property public var manageCookies(get, set):Bool;
	@:flash.property public var useCache(get, set):Bool;
	@:flash.property public var userAgent(get, set):String;
	#else
	@:flash.property public var followRedirects(get, set):Bool;
	@:noCompletion private inline function get_followRedirects():Bool
	{
		return true;
	}
	@:noCompletion private inline function set_followRedirects(value:Bool):Bool
	{
		return value;
	}
	@:flash.property public var idleTimeout(get, set):Float;
	@:noCompletion private inline function get_idleTimeout():Float
	{
		return 30000;
	}
	@:noCompletion private inline function set_idleTimeout(value:Float):Float
	{
		return value;
	}
	@:flash.property public var manageCookies(get, set):Bool;
	@:noCompletion private inline function get_manageCookies():Bool
	{
		return true;
	}
	@:noCompletion private inline function set_manageCookies(value:Bool):Bool
	{
		return value;
	}
	@:flash.property public var userAgent(get, set):String;
	@:noCompletion private inline function get_userAgent():String
	{
		return null;
	}
	@:noCompletion private inline function set_userAgent(value:String):String
	{
		return value;
	}
	#end
	#end
	public function new(url:String = null);
	public function useRedirectedURL(sourceRequest:URLRequest, wholeURL:Bool = false, pattern:Dynamic = null, replace:String = null):Void;

	#if (haxe_ver >= 4.3)
	private function get_contentType():String;
	private function get_data():Dynamic;
	private function get_digest():String;
	private function get_method():String;
	private function get_requestHeaders():Array<URLRequestHeader>;
	private function get_url():String;
	private function set_contentType(value:String):String;
	private function set_data(value:Dynamic):Dynamic;
	private function set_digest(value:String):String;
	private function set_method(value:String):String;
	private function set_requestHeaders(value:Array<URLRequestHeader>):Array<URLRequestHeader>;
	private function set_url(value:String):String;
	#if air
	private function get_authenticate():Bool;
	private function get_cacheResponse():Bool;
	private function get_followRedirects():Bool;
	private function get_idleTimeout():Float;
	private function get_manageCookies():Bool;
	private function get_useCache():Bool;
	private function get_userAgent():String;
	private function set_authenticate(value:Bool):Bool;
	private function set_cacheResponse(value:Bool):Bool;
	private function set_followRedirects(value:Bool):Bool;
	private function set_idleTimeout(value:Float):Float;
	private function set_manageCookies(value:Bool):Bool;
	private function set_useCache(value:Bool):Bool;
	private function set_userAgent(value:String):String;
	#end
	#end
}
#else
typedef URLRequest = openfl.net.URLRequest;
#end
