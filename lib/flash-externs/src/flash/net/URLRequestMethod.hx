package flash.net;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract URLRequestMethod(String) from String to String

{
	@:require(flash10_1) public var DELETE = "DELETE";
	public var GET = "GET";
	@:require(flash10_1) public var HEAD = "HEAD";
	@:require(flash10_1) public var OPTIONS = "OPTIONS";
	public var POST = "POST";
	@:require(flash10_1) public var PUT = "PUT";
}
#else
typedef URLRequestMethod = openfl.net.URLRequestMethod;
#end
