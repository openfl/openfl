package openfl.desktop;

#if lime
import lime.system.Clipboard as LimeClipboard;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.ClipboardTransferMode;
import openfl.utils.Object;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Clipboard
{
	private var parent:Clipboard;

	public function new(parent:Clipboard)
	{
		this.parent = parent;
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
}
#end
