package flash.net;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SharedObjectFlushStatus(String) from String to String

{
	public var FLUSHED = "flushed";
	public var PENDING = "pending";
}
#else
typedef SharedObjectFlushStatus = openfl.net.SharedObjectFlushStatus;
#end
