package openfl.net {
	
	
	import openfl.events.EventDispatcher;
	
	
	/**
	 * @externs
	 */
	public class FileReferenceList extends EventDispatcher {
		
		
		/**
		 * An array of FileReference objects.
		 */
		public function get fileList ():Array { return null; }
		
		
		public function FileReferenceList ();
		
		
		public function browse (typeFilter:Array = null):Boolean { return false; }
		
		
	}
	
	
}