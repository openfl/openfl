package openfl._internal.backend.html5;

#if openfl_html5
import js.html.TextAreaElement;
import js.Browser;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.ClipboardTransferMode;
import openfl.utils.Object;

class HTML5ClipboardBackend
{
	private var parent:Clipboard;
	private var text:Object;
	private var textArea:TextAreaElement;

	public function new(parent:Clipboard)
	{
		this.parent = parent;
		text = null;
	}

	public function clear():Void
	{
		setData(TEXT_FORMAT, null);
	}

	public function clearData(format:ClipboardFormats):Void
	{
		switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
				setData(TEXT_FORMAT, null);

			default:
		}
	}

	public function getData(format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object
	{
		return switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: text;
			default: null;
		}
	}

	public function hasFormat(format:ClipboardFormats):Bool
	{
		return switch (format)
		{
			case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: text != null;
			default: false;
		}
	}

	public function setData(format:ClipboardFormats, data:Object, serializable:Bool = true):Bool
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
