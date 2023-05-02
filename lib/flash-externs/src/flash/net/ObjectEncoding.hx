package flash.net;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ObjectEncoding(Int) from Int to Int from UInt to UInt

{
	public var AMF0 = 0;
	public var AMF3 = 3;
	public var HXSF = 10;
	public var JSON = 12;
	public var DEFAULT = 3;
}
#else
typedef ObjectEncoding = openfl.net.ObjectEncoding;
#end
