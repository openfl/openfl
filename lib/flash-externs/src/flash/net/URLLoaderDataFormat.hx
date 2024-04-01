package flash.net;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract URLLoaderDataFormat(String) from String to String

{
	public var BINARY = "binary";
	public var TEXT = "text";
	public var VARIABLES = "variables";
}
#else
typedef URLLoaderDataFormat = openfl.net.URLLoaderDataFormat;
#end
