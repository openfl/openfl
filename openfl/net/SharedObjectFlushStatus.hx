package openfl.net;


@:enum abstract SharedObjectFlushStatus(Int) {
	
	public var FLUSHED = 0;
	public var PENDING = 1;
	
	@:from private static inline function fromString (value:String):SharedObjectFlushStatus {
		
		return switch (value) {
			
			case "pending": PENDING;
			default: return FLUSHED;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case SharedObjectFlushStatus.PENDING: "pending";
			default: "flushed";
			
		}
		
	}
	
}