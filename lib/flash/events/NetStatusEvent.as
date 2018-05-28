package flash.events {
	
	
	/**
	 * @externs
	 */
	public class NetStatusEvent extends Event {
		
		
		public static const NET_STATUS:String = "netStatus";
		
		public var info:Object;
		
		
		public function NetStatusEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false, info:Object = null) { super (type); }
		
		
	}
	
	
}