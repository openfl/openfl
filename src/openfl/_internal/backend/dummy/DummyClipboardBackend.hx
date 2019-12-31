package openfl._internal.backend.dummy;

import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.ClipboardTransferMode;
import openfl.utils.Object;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyClipboardBackend
{
	private var htmlText:String;
	private var richText:String;
	private var text:String;

	public function new(parent:Clipboard)
	{
		htmlText = null;
		richText = null;
		text = null;
	}

	public function clear():Void
	{
		htmlText = null;
		richText = null;
		text = null;
	}

	public function clearData(format:ClipboardFormats):Void
	{
		switch (format)
		{
			case HTML_FORMAT:
				htmlText = null;

			case RICH_TEXT_FORMAT:
				richText = null;

			case TEXT_FORMAT:
				text = null;

			default:
		}
	}

	public function getData(format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object
	{
		return switch (format)
		{
			case HTML_FORMAT: htmlText;
			case RICH_TEXT_FORMAT: richText;
			case TEXT_FORMAT: text;
			default: null;
		}
	}

	public function hasFormat(format:ClipboardFormats):Bool
	{
		return switch (format)
		{
			case HTML_FORMAT: htmlText != null;
			case RICH_TEXT_FORMAT: richText != null;
			case TEXT_FORMAT: text != null;
			default: false;
		}
	}

	public function setData(format:ClipboardFormats, data:Object, serializable:Bool = true):Bool
	{
		switch (format)
		{
			case HTML_FORMAT:
				htmlText = data;
				return true;

			case RICH_TEXT_FORMAT:
				richText = data;
				return true;

			case TEXT_FORMAT:
				text = data;
				return true;

			default:
				return false;
		}
	}
}
