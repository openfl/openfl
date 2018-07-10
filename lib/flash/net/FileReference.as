package flash.net {
	
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	
	/**
	 * @externs
	 */
	public class FileReference extends EventDispatcher {
		
		
		/**
		 * The creation date of the file on the local disk.
		 */
		public function get creationDate ():Date { return null; }
		
		/**
		 * The Macintosh creator type of the file, which is only used in Mac OS versions prior to Mac OS X.
		 */
		public function get creator ():String { return null; }
		
		/**
		 * The ByteArray object representing the data from the loaded file after a successful call to the load() method.
		 */
		public function get data ():ByteArray { return null; }
		
		/**
		 * The date that the file on the local disk was last modified.
		 */
		public function get modificationDate ():Date { return null; }
		
		/**
		 * The name of the file on the local disk.
		 */
		public function get name ():String { return null; }
		
		/**
		 * The size of the file on the local disk in bytes.
		 */
		public function get size ():int { return 0; }
		
		/**
		 * The file type.
		 */
		public function get type ():String { return null; }
		
		
		public function FileReference () {}
		
		
		public function browse (typeFilter:Array = null):Boolean { return false; }
		
		
		public function cancel ():void {}
		
		
		public function download (request:URLRequest, defaultFileName:String = null):void {}
		
		
		public function load ():void {}
		
		
		public function save (data:Object, defaultFileName:String = null):void {}
		
		
		public function upload (request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Boolean = false):void {}
		
		
	}
	
	
}