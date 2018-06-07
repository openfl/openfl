package openfl.events {
	
	
	/**
	 * @externs
	 */
	public class DataEvent extends TextEvent {
		
		
		public static const DATA:String = "data";
		public static const UPLOAD_COMPLETE_DATA:String = "uploadCompleteData";
		
		public var data:String;
		
		
		public function DataEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:String = "") { super (type); }
		
		
	}
	
	
}