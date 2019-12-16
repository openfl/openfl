package flash.net;

#if flash
@:final extern class URLRequestHeader
{
	public var name:String;
	public var value:String;
	public function new(name:String = "", value:String = "");
}
#else
typedef URLRequestHeader = openfl.net.URLRequestHeader;
#end
