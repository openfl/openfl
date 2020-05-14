package openfl.desktop;

import lime.system.Clipboard as LimeClipboard;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.ClipboardTransferMode;
import openfl.utils.Object;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.desktop.Clipboard)
@:noCompletion
class _Clipboard
{
	public static var generalClipboard(get, never):Clipboard;

	public static var __generalClipboard:Clipboard;

	public var formats(get, never):Array<ClipboardFormats>;

	private var clipboard:Clipboard;

	public function new(clipboard:Clipboard)
	{
		this.clipboard = clipboard;
	}

	public function clear():Void
	{
		LimeClipboard.text = null;
		return;
	}

	public function clearData(format:ClipboardFormats):Void
	{
		switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
				LimeClipboard.text = null;

			default:
		}
	}

	public function getData(format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object
	{
		return switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: LimeClipboard.text;
			default: null;
		}
	}

	public function hasFormat(format:ClipboardFormats):Bool
	{
		return switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: LimeClipboard.text != null;
			default: false;
		}
	}

	public function setData(format:ClipboardFormats, data:Object, serializable:Bool = true):Bool
	{
		switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
				LimeClipboard.text = data;
				return true;

			default:
				return false;
		}
	}

	// Get & Set Methods

	private function get_formats():Array<ClipboardFormats>
	{
		var formats:Array<ClipboardFormats> = [];
		if (hasFormat(HTML_FORMAT)) formats.push(HTML_FORMAT);
		if (hasFormat(RICH_TEXT_FORMAT)) formats.push(RICH_TEXT_FORMAT);
		if (hasFormat(TEXT_FORMAT)) formats.push(TEXT_FORMAT);
		return formats;
	}

	public static function get_generalClipboard():Clipboard
	{
		if (__generalClipboard == null)
		{
			__generalClipboard = new Clipboard();
		}

		return __generalClipboard;
	}
}
