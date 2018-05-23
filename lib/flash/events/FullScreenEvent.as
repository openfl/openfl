package flash.events {
	
	
	/**
	 * @externs
	 */
	public class FullScreenEvent extends ActivityEvent {
		
		
		public static const FULL_SCREEN:String = "fullScreen";
		public static const FULL_SCREEN_INTERACTIVE_ACCEPTED:String = "fullScreenInteractiveAccepted";
		
		public var fullScreen:Boolean;
		public var interactive:Boolean;
		
		
		public function FullScreenEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false, fullScreen:Boolean = false, interactive:Boolean = false) { super (type); }
		
		
	}
	
	
}