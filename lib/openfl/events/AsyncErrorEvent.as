package openfl.events {
	
	
	// import haxe.io.Error;
	
	
	/**
	 * @externs
	 */
	public class AsyncErrorEvent extends ErrorEvent {
		
		
		public static const ASYNC_ERROR:String = "asyncError";
		
		public var error:Error;
		
		
		public function AsyncErrorEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", error:Error = null) { super (type); }
		
		
	}
	
	
}