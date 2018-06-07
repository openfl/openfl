package openfl.events {
	
	
	/**
	 * @externs
	 */
	public class UncaughtErrorEvent extends ErrorEvent {
		
		
		public static const UNCAUGHT_ERROR:String = "uncaughtError";
		
		public function get error ():* { return null; }
		
		
		public function UncaughtErrorEvent (type:String, bubbles:Boolean = true, cancelable:Boolean = true, error:* = null) { super (type); }
		
		
	}
	
	
}