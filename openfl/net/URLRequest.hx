package openfl.net; #if (!openfl_legacy || disable_legacy_networking)


import openfl.utils.ByteArray;


@:final class URLRequest {
	
	
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
		
		if (Std.is (data, String) || Std.is (data, ByteArrayData)) {
			
			res = res.copy ();
			res.push (new URLRequestHeader ("Content-Type", contentType != null ? contentType : "application/x-www-form-urlencoded"));
			
		}
		
		return res;
		
	}
	
	
}


#else
typedef URLRequest = openfl._legacy.net.URLRequest;
#end