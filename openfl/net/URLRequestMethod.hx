package openfl.net; #if (!openfl_legacy || disable_legacy_networking)


@:enum abstract URLRequestMethod(String) from String to String {
	
	var DELETE = "DELETE";
	var GET = "GET";
	var HEAD = "HEAD";
	var OPTIONS = "OPTIONS";
	var POST = "POST";
	var PUT = "PUT";
	
}


#else
typedef URLRequestMethod = openfl._legacy.net.URLRequestMethod;
#end