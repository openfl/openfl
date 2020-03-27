namespace openfl._internal.backend.dummy;

import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.ClipboardTransferMode;
import openfl.utils.Object;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyClipboardBackend
{
	private htmlText: string;
	private richText: string;
	private text: string;

	public constructor(parent: Clipboard)
	{
		htmlText = null;
		richText = null;
		text = null;
	}

	public clear(): void
	{
		htmlText = null;
		richText = null;
		text = null;
	}

	public clearData(format: ClipboardFormats): void
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

	public getData(format: ClipboardFormats, transferMode: ClipboardTransferMode = null): Object
	{
		return switch (format)
		{
			case HTML_FORMAT: htmlText;
			case RICH_TEXT_FORMAT: richText;
			case TEXT_FORMAT: text;
			default: null;
		}
	}

	public hasFormat(format: ClipboardFormats): boolean
	{
		return switch (format)
		{
			case HTML_FORMAT: htmlText != null;
			case RICH_TEXT_FORMAT: richText != null;
			case TEXT_FORMAT: text != null;
			default: false;
		}
	}

	public setData(format: ClipboardFormats, data: Object, serializable: boolean = true): boolean
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
