package flash.net;

#if flash
@:enum abstract SharedObjectFlushStatus(String) from String to String
{
	public var FLUSHED = "flushed";
	public var PENDING = "pending";
}
#else
typedef SharedObjectFlushStatus = openfl.net.SharedObjectFlushStatus;
#end
