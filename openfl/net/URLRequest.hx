package openfl.net; #if !flash #if (display || openfl_next || js)


import openfl.utils.ByteArray;


class URLRequest {
	
	
	public var contentType:String;
	public var data:Dynamic;
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	public var userAgent:String;
	
	
	public function new (inURL:String = null) {
		
		if (inURL != null) {
			
			url = inURL;
			
		}
		
		requestHeaders = [];
		method = URLRequestMethod.GET;
		contentType = null; // "application/x-www-form-urlencoded";
		
	}
	
	
	public function formatRequestHeaders ():Array<URLRequestHeader> {
		
		var res = requestHeaders;
		if (res == null) res = [];
		
		if (method == URLRequestMethod.GET || data == null) return res;
		
		if (Std.is (data, String) || Std.is (data, ByteArray)) {
			
			res = res.copy ();
			res.push (new URLRequestHeader ("Content-Type", contentType != null ? contentType : "application/x-www-form-urlencoded"));
			
		}
		
		return res;
		
	}
	
	
}


#else
typedef URLRequest = openfl._v2.net.URLRequest;
#end
#else
typedef URLRequest = flash.net.URLRequest;
#end