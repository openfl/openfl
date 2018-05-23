package openfl.events {
	
	
	import openfl.utils.ByteArray;
	
	
	/**
	 * @externs
	 */
	public class SampleDataEvent extends Event {
		
		
		public static const SAMPLE_DATA:String = "sampleData";
		
		public var data:ByteArray;
		public var position:Number;
		
		
		public function SampleDataEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false) { super (type); }
		
		
	}
	
	
}