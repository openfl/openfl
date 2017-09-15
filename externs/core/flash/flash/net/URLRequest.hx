package flash.net; #if (!display && flash)


@:final extern class URLRequest {
	
	
	#if air
	public var authenticate:Bool;
	public var cacheResponse:Bool;
	#end
	
	public var contentType:String;
	public var data:Dynamic;
	
	#if flash
	public var digest:String;
	#end
	
	#if air
	public var followRedirects:Bool;
	public var idleTimeout:Float;
	public var manageCookies:Bool;
	#end
	
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	
	#if air
	public var useCache:Bool;
	public var userAgent:String;
	#end
	
	public function new (url:String = null);
	
	#if flash
	public function useRedirectedURL (sourceRequest:URLRequest, wholeURL:Bool = false, pattern:Dynamic = null, replace:String = null):Void;
	#end
	
	
}


#else
typedef URLRequest = openfl.net.URLRequest;
#end