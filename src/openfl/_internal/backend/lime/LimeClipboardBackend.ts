namespace openfl._internal.backend.lime;

#if lime
import lime.system.Clipboard as LimeClipboard;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.ClipboardTransferMode;
import openfl.utils.Object;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class LimeClipboardBackend
{
	private parent: Clipboard;

	public new(parent: Clipboard)
	{
		this.parent = parent;
	}

	public clear(): void
	{
		LimeClipboard.text = null;
		return;
	}

	public clearData(format: ClipboardFormats): void
	{
		switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
				LimeClipboard.text = null;

			default:
		}
	}

	public getData(format: ClipboardFormats, transferMode: ClipboardTransferMode = null): Object
	{
		return switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: LimeClipboard.text;
			default: null;
		}
	}

	public hasFormat(format: ClipboardFormats): boolean
	{
		return switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: LimeClipboard.text != null;
			default: false;
		}
	}

	public setData(format: ClipboardFormats, data: Object, serializable: boolean = true): boolean
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
