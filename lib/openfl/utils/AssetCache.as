package openfl.utils {
	
	
	import openfl.display.BitmapData;
	import openfl.media.Sound;
	import openfl.text.Font;
	
	
	/**
	 * @externs
	 */
	public class AssetCache implements IAssetCache {
		
		
		public function get enabled ():Boolean { return false; }
		public function set enabled (value:Boolean):void {}
		// public var enabled:Boolean;
		
		protected function get_enabled ():Boolean { return false; }
		protected function set_enabled (value:Boolean):Boolean { return false; }
		
		public function AssetCache () {}
		
		public function clear (prefix:String = null):void {}
		public function getBitmapData (id:String):BitmapData { return null; }
		public function getFont (id:String):Font { return null; }
		public function getSound (id:String):Sound { return null; }
		public function hasBitmapData (id:String):Boolean { return false; }
		public function hasFont (id:String):Boolean { return false; }
		public function hasSound (id:String):Boolean { return false; }
		public function removeBitmapData (id:String):Boolean { return false; }
		public function removeFont (id:String):Boolean { return false; }
		public function removeSound (id:String):Boolean { return false; }
		public function setBitmapData (id:String, bitmapData:BitmapData):void {}
		public function setFont (id:String, font:Font):void {}
		public function setSound (id:String, sound:Sound):void {}
		
		
	}
	
	
}