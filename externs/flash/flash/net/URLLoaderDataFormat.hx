package flash.net;

#if flash
@:enum abstract URLLoaderDataFormat(String) from String to String
{
	public var BINARY = "binary";
	public var TEXT = "text";
	public var VARIABLES = "variables";
}
#else
typedef URLLoaderDataFormat = openfl.net.URLLoaderDataFormat;
#end
