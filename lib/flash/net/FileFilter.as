package flash.net {
	
	
	/**
	 * @externs
	 */
	final public class FileFilter {
		
		
		/**
		 * The description string for the filter.
		 */
		public var description:String;
		
		/**
		 * A list of file extensions.
		 */
		public var extension:String;
		
		/**
		 * A list of Macintosh file types.
		 */
		public var macType:String;
		
		
		public function FileFilter (description:String, extension:String, macType:String = null) {}
		
		
	}
	
	
}