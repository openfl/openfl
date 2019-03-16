package flash.desktop;

#if flash
import openfl.utils.Object;

@:require(flash10)
extern class Clipboard
{
	public static var generalClipboard(default, never):Clipboard;
	public var formats(default, never):Array<ClipboardFormats>;
	#if air
	public var supportsFilePromise(default, never):Bool;
	#end
	public function clear():Void;
	public function clearData(format:ClipboardFormats):Void;
	public function getData(format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object;
	public function hasFormat(format:ClipboardFormats):Bool;
	public function setData(format:ClipboardFormats, data:Object, serializable:Bool = true):Bool;
	public function setDataHandler(format:ClipboardFormats, handler:Void->Dynamic, serializable:Bool = true):Bool;
}
#else
typedef Clipboard = openfl.desktop.Clipboard;
#end
