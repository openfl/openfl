package openfl.net;


@:enum abstract SharedObjectFlushStatus(String) from String to String {
	
	public var FLUSHED = "flushed";
	public var PENDING = "pending";
	
}