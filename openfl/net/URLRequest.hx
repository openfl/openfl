package openfl.net;


@:final class URLRequest {
	
	
	public var contentType:String;
	public var data:Dynamic;
	public var method:String;
	public var requestHeaders:Array<URLRequestHeader>;
	public var url:String;
	public var userAgent:String;
	
	
	public function new (url:String = null) {
		
		if (url != null) {
			
			this.url = url;
			
		}
		
		requestHeaders = [];
		method = URLRequestMethod.GET;
		contentType = null; // "application/x-www-form-urlencoded";
		
	}
	
	
}