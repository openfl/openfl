package openfl.net;


@:enum abstract SharedObjectFlushStatus(Null<Int>) {
	
	public var FLUSHED = 0;
	public var PENDING = 1;
	
	@:from private static function fromString (value:String):SharedObjectFlushStatus {
		
		return switch (value) {
			
			case "flushed": FLUSHED;
			case "pending": PENDING;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case SharedObjectFlushStatus.FLUSHED: "flushed";
			case SharedObjectFlushStatus.PENDING: "pending";
			default: null;
			
		}
		
	}
	
}