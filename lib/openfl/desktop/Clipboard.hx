package openfl.desktop;

#if (display || !flash)
import openfl.utils.Object;

@:jsRequire("openfl/desktop/Clipboard", "default")
extern class Clipboard
{
	public static var generalClipboard(default, null):Clipboard;
	public var formats(get, never):Array<ClipboardFormats>;
	@:noCompletion private function get_formats():Array<ClipboardFormats>;
	public function clear():Void;
	public function clearData(format:ClipboardFormats):Void;
	public function getData(format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object;
	public function hasFormat(format:ClipboardFormats):Bool;
	public function setData(format:ClipboardFormats, data:Object, serializable:Bool = true):Bool;
	public function setDataHandler(format:ClipboardFormats, handler:Void->Dynamic, serializable:Bool = true):Bool;
}
#else
typedef Clipboard = flash.desktop.Clipboard;
#end
