package openfl.utils {
	
	
	/**
	 * @externs
	 */
	public class Future {
		
		
		public function get error ():Object { return null; }
		public function get isComplete ():Boolean { return false; }
		public function get isError ():Boolean { return false; }
		public function get value ():* { return false; }
		
		public function onComplete (listener:Function):Future { return null; }
		public function onError (listener:Function):Future { return null; }
		public function onProgress (listener:Function):Future { return null; }
		public function ready (waitTime:int = -1):Future { return null; }
		public function result (waitTime:int = -1):* { return null; }
		public function then (next:Function):Future { return null; }
		public static function withError (error:Object):Future { return null; }
		public static function withValue (value:*):Future { return null; }
		
		
	}
	
	
}