package openfl.events {
	
	
	/**
	 * @externs
	 */
	public class ActivityEvent extends Event {
		
		
		public static const ACTIVITY:String = "activity";
		
		public var activating:Boolean;
		
		
		public function ActivityEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false, activating:Boolean = false) { super (type); }
		
		
	}
	
	
}