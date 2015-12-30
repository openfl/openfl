package openfl.net; #if (!openfl_legacy || disable_legacy_networking)


@:enum abstract URLRequestMethod(Int) {
	
	public var DELETE = 0;
	public var GET = 1;
	public var HEAD = 2;
	public var OPTIONS = 3;
	public var POST = 4;
	public var PUT = 5;
	
	@:from private static inline function fromString (value:String):URLRequestMethod {
		
		return switch (value) {
			
			case "DELETE": DELETE;
			case "HEAD": HEAD;
			case "OPTIONS": OPTIONS;
			case "POST": POST;
			case "PUT": PUT;
			default: return GET;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case URLRequestMethod.DELETE: "DELETE";
			case URLRequestMethod.HEAD: "HEAD";
			case URLRequestMethod.OPTIONS: "OPTIONS";
			case URLRequestMethod.POST: "POST";
			case URLRequestMethod.PUT: "PUT";
			default: "GET";
			
		}
		
	}
	
}


#else
typedef URLRequestMethod = openfl._legacy.net.URLRequestMethod;
#end