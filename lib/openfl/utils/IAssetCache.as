package openfl.utils {
	
	
	import openfl.display.BitmapData;
	import openfl.media.Sound;
	import openfl.text.Font;
	
	/**
	 * @externs
	 */	
	public interface IAssetCache {
		
		function get enabled ():Boolean;
		function set enabled (value:Boolean):void;
		
		function clear (prefix:String = null):void;
		function getBitmapData (id:String):BitmapData;
		function getFont (id:String):Font;
		function getSound (id:String):Sound;
		function hasBitmapData (id:String):Boolean;
		function hasFont (id:String):Boolean;
		function hasSound (id:String):Boolean;
		function removeBitmapData (id:String):Boolean;
		function removeFont (id:String):Boolean;
		function removeSound (id:String):Boolean;
		function setBitmapData (id:String, bitmapData:BitmapData):void;
		function setFont (id:String, font:Font):void;
		function setSound (id:String, sound:Sound):void;
		
	}
	
	
}
