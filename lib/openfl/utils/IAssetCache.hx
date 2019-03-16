package openfl.utils;

import openfl.display.BitmapData;
import openfl.media.Sound;
import openfl.text.Font;

@:jsRequire("openfl/utils/IAssetCache", "default")
@:dox(hide) interface IAssetCache
{
	public var enabled(get, set):Bool;
	@:noCompletion private function get_enabled():Bool;
	@:noCompletion private function set_enabled(value:Bool):Bool;
	public function clear(prefix:String = null):Void;
	public function getBitmapData(id:String):BitmapData;
	public function getFont(id:String):Font;
	public function getSound(id:String):Sound;
	public function hasBitmapData(id:String):Bool;
	public function hasFont(id:String):Bool;
	public function hasSound(id:String):Bool;
	public function removeBitmapData(id:String):Bool;
	public function removeFont(id:String):Bool;
	public function removeSound(id:String):Bool;
	public function setBitmapData(id:String, bitmapData:BitmapData):Void;
	public function setFont(id:String, font:Font):Void;
	public function setSound(id:String, sound:Sound):Void;
}
