namespace openfl._internal.backend.html5;

#if openfl_html5
import js.html.TextAreaElement;
import js.Browser;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.ClipboardTransferMode;
import openfl.utils.Object;

class HTML5ClipboardBackend
{
	private parent: Clipboard;
	private text: Object;
	private textArea: TextAreaElement;

	public new(parent: Clipboard)
	{
		this.parent = parent;
		text = null;
	}

	public clear(): void
	{
		setData(TEXT_FORMAT, null);
	}

	public clearData(format: ClipboardFormats): void
	{
		switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
				setData(TEXT_FORMAT, null);

			default:
		}
	}

	public getData(format: ClipboardFormats, transferMode: ClipboardTransferMode = null): Object
	{
		return switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: text;
			default: null;
		}
	}

	public hasFormat(format: ClipboardFormats): boolean
	{
		return switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: text != null;
			default: false;
		}
	}

	public setData(format: ClipboardFormats, data: Object, serializable: boolean = true): boolean
	{
		if (textArea == null)
		{
			textArea = cast Browser.document.createElement("textarea");
			textArea.style.height = "0px";
			textArea.style.left = "-100px";
			textArea.style.opacity = "0";
			textArea.style.position = "fixed";
			textArea.style.top = "-100px";
			textArea.style.width = "0px";
			Browser.document.body.appendChild(textArea);
		}

		switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
				text = data;

				textArea.value = data;
				textArea.focus();
				textArea.select();

				if (Browser.document.queryCommandEnabled("copy"))
				{
					Browser.document.execCommand("copy");
				}
				return true;

			default:
				return false;
		}
	}
}
#end
