package openfl.net; #if (!openfl_legacy || disable_legacy_networking)


@:enum abstract URLRequestMethod(String) from String to String {
	
	public var DELETE = "DELETE";
	public var GET = "GET";
	public var HEAD = "HEAD";
	public var OPTIONS = "OPTIONS";
	public var POST = "POST";
	public var PUT = "PUT";
	
}


#else
typedef URLRequestMethod = openfl._legacy.net.URLRequestMethod;
#end