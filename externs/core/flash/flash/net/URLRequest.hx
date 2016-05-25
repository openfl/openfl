package flash.net; #if (!display && flash)


@:final extern class URLRequest {
	
	
	public var contentType:String;
	public var data:Dynamic;
	
	#if flash
	@:noCompletion @:dox(hide) public var digest:String;
	#end
	
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	//public var userAgent:String;
	
	public function new (url:String = null);
	
	#if flash
	@:noCompletion @:dox(hide) public function useRedirectedURL (sourceRequest:URLRequest, wholeURL:Bool = false, pattern:Dynamic = null, replace:String = null):Void;
	#end
	
	
}


#else
typedef URLRequest = openfl.net.URLRequest;
#end