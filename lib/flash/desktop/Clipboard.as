package flash.desktop {
	
	
	// import flash.utils.Object;
	
	/**
	 * @externs
	 */
	public class Clipboard {
		
		
		public static function get generalClipboard ():Clipboard { return null; }
		
		public function get formats ():Array { return null; }
		
		protected function get_formats ():Array { return null; }
		
		public function clear ():void {}
		public function clearData (format:String):void {}
		public function getData (format:String, transferMode:String = null):Object { return null; }
		public function hasFormat (format:String):Boolean { return false; }
		public function setData (format:String, data:Object, serializable:Boolean = true):Boolean { return false; }
		public function setDataHandler (format:String, handler:Function, serializable:Boolean = true):Boolean { return false; }
		
		
	}
	
	
}