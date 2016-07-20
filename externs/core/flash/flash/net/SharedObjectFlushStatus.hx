package flash.net; #if (!display && flash)


@:enum abstract SharedObjectFlushStatus(String) from String to String {
	
	public var FLUSHED = "flushed";
	public var PENDING = "pending";
	
}


#else
typedef SharedObjectFlushStatus = openfl.net.SharedObjectFlushStatus;
#end