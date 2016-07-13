package openfl.net;


@:enum abstract URLRequestMethod(Null<Int>) {
	
	public var DELETE = 0;
	public var GET = 1;
	public var HEAD = 2;
	public var OPTIONS = 3;
	public var POST = 4;
	public var PUT = 5;
	
	@:from private static function fromString (value:String):URLRequestMethod {
		
		return switch (value) {
			
			case "DELETE": DELETE;
			case "GET": GET;
			case "HEAD": HEAD;
			case "OPTIONS": OPTIONS;
			case "POST": POST;
			case "PUT": PUT;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case URLRequestMethod.DELETE: "DELETE";
			case URLRequestMethod.GET: "GET";
			case URLRequestMethod.HEAD: "HEAD";
			case URLRequestMethod.OPTIONS: "OPTIONS";
			case URLRequestMethod.POST: "POST";
			case URLRequestMethod.PUT: "PUT";
			default: null;
			
		}
		
	}
	
}