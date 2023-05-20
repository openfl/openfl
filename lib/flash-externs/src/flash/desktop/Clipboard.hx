package flash.desktop;

#if flash
import openfl.utils.Object;

@:require(flash10)
extern class Clipboard
{
	#if (haxe_ver < 4.3)
	public static var generalClipboard(default, never):Clipboard;
	public var formats(default, never):Array<ClipboardFormats>;
	#if air
	public var supportsFilePromise(default, never):Bool;
	#end
	#else
	@:flash.property var formats(get, never):Array<ClipboardFormats>;
	@:flash.property static var generalClipboard(get, never):Clipboard;
	#if air
	@:flash.property public var supportsFilePromise(get, never):Bool;
	#end
	#end
	public function clear():Void;
	public function clearData(format:ClipboardFormats):Void;
	public function getData(format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object;
	public function hasFormat(format:ClipboardFormats):Bool;
	public function setData(format:ClipboardFormats, data:Object, serializable:Bool = true):Bool;
	public function setDataHandler(format:ClipboardFormats, handler:Void->Dynamic, serializable:Bool = true):Bool;

	#if (haxe_ver >= 4.3)
	private function get_formats():Array<ClipboardFormats>;
	private static function get_generalClipboard():Clipboard;
	#if air
	private function get_supportsFilePromise():Bool;
	#end
	#end
}
#else
typedef Clipboard = openfl.desktop.Clipboard;
#end
