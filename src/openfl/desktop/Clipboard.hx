package openfl.desktop;

#if !flash
import openfl.utils.Object;
#if lime
import lime.system.Clipboard as LimeClipboard;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Clipboard
{
	public static var generalClipboard(get, never):Clipboard;

	@:noCompletion private static var __generalClipboard:Clipboard;

	public var formats(get, never):Array<ClipboardFormats>;

	@:noCompletion private var __htmlText:String;
	@:noCompletion private var __richText:String;
	@:noCompletion private var __systemClipboard:Bool;
	@:noCompletion private var __text:String;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped global.Object.defineProperty(Clipboard, "generalClipboard", {
			get: function()
			{
				return Clipboard.get_generalClipboard();
			}
		});
		untyped global.Object.defineProperty(Clipboard.prototype, "formats", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_formats (); }")
		});
	}
	#end

	@:noCompletion private function new() {}

	public function clear():Void
	{
		#if lime
		if (__systemClipboard)
		{
			LimeClipboard.text = null;
			return;
		}
		#end

		__htmlText = null;
		__richText = null;
		__text = null;
	}

	public function clearData(format:ClipboardFormats):Void
	{
		#if lime
		if (__systemClipboard)
		{
			switch (format)
			{
				case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT:
					LimeClipboard.text = null;

				default:
			}

			return;
		}
		#end

		switch (format)
		{
			case HTML_FORMAT:
				__htmlText = null;

			case RICH_TEXT_FORMAT:
				__richText = null;

			case TEXT_FORMAT:
				__text = null;

			default:
		}
	}

	public function getData(format:ClipboardFormats, transferMode:ClipboardTransferMode = null):Object
	{
		if (transferMode == null)
		{
			transferMode = ORIGINAL_PREFERRED;
		}

		#if lime
		if (__systemClipboard)
		{
			return switch (format)
			{
				case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: LimeClipboard.text;
				default: null;
			}
		}
		#end

		return switch (format)
		{
			case HTML_FORMAT: __htmlText;
			case RICH_TEXT_FORMAT: __richText;
			case TEXT_FORMAT: __text;
			default: null;
		}
	}

	public function hasFormat(format:ClipboardFormats):Bool
	{
		#if lime
		if (__systemClipboard)
		{
			return switch (format)
			{
				case HTML_FORMAT, RICH_TEXT_FORMAT, TEXT_FORMAT: LimeClipboard.text != null;
				default: false;
			}
		}
		#end

		return switch (format)
		{
			case HTML_FORMAT: __htmlText != null;
			case RICH_TEXT_FORMAT: __richText != null;
			case TEXT_FORMAT: __text != null;
			default: false;
		}
	}

	public function setData(format:ClipboardFormats, data:Object, serializable:Bool = true):Bool
	{
		#if lime
		if (__systemClipboard)
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
		#end

		switch (format)
		{
			case HTML_FORMAT:
				__htmlText = data;
				return true;

			case RICH_TEXT_FORMAT:
				__richText = data;
				return true;

			case TEXT_FORMAT:
				__text = data;
				return true;

			default:
				return false;
		}
	}

	#if !openfl_strict
	@SuppressWarnings("checkstyle:Dynamic")
	public function setDataHandler(format:ClipboardFormats, handler:Void->Dynamic, serializable:Bool = true):Bool
	{
		openfl._internal.Lib.notImplemented();
		return false;
	}
	#end

	// Get & Set Methods
	@:noCompletion private function get_formats():Array<ClipboardFormats>
	{
		var formats:Array<ClipboardFormats> = [];
		if (hasFormat(HTML_FORMAT)) formats.push(HTML_FORMAT);
		if (hasFormat(RICH_TEXT_FORMAT)) formats.push(RICH_TEXT_FORMAT);
		if (hasFormat(TEXT_FORMAT)) formats.push(TEXT_FORMAT);
		return formats;
	}

	@:noCompletion private static function get_generalClipboard():Clipboard
	{
		if (__generalClipboard == null)
		{
			__generalClipboard = new Clipboard();
			__generalClipboard.__systemClipboard = true;
		}

		return __generalClipboard;
	}
}
#else
typedef Clipboard = flash.desktop.Clipboard;
#end
